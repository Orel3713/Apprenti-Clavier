import AppKit
import SwiftUI
import UniformTypeIdentifiers

private struct MessageFormateurView: View {
    let titre: String
    let message: String
    let fermer: () -> Void
    @AccessibilityFocusState private var titreEnFocus: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(titre)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(
                    titre + ". " + message
                    + " Appuyez sur Entrée pour fermer cette fenêtre."
                )
                .accessibilityFocused($titreEnFocus)
            Text(message)
                .accessibilityHidden(true)
            HStack {
                Spacer()
                Button("D’accord") { fermer() }
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(26)
        .frame(width: 480)
        .onAppear {
            DispatchQueue.main.async { titreEnFocus = true }
        }
        .onExitCommand { }
    }
}

@MainActor
final class MenuFormateurDynamique: NSObject {
    static let shared = MenuFormateurDynamique()

    private var elementMenu: NSMenuItem?
    private var elementProfil: NSMenuItem?
    private var indexProfil = 0
    private var fenetreMessage: NSWindow?

    func mettreAJour(estConnecte: Bool) {
        DispatchQueue.main.async {
            estConnecte ? self.installer() : self.retirer()
        }
    }

    private func installer() {
        guard let barre = NSApp.mainMenu else { return }

        if let menuPresent = barre.items.first(where: { $0.title == "Formateur" }) {
            elementMenu = menuPresent
            return
        }

        // La barre des menus peut être reconstruite par SwiftUI. Dans ce cas,
        // la référence mémorisée ne correspond plus à un élément réellement
        // affiché et ne doit pas empêcher une nouvelle installation.
        elementMenu = nil

        if let index = barre.items.firstIndex(where: { $0.title == "Apprenant" }) {
            indexProfil = index
            elementProfil = barre.items[index]
            barre.removeItem(at: index)
        }

        let element = NSMenuItem(title: "Formateur", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "Formateur")

        let identite = NSMenuItem(
            title: "Formateur actuel : \(FormateurManager.shared.formateurActif ?? "")",
            action: nil,
            keyEquivalent: ""
        )
        identite.isEnabled = false
        menu.addItem(identite)
        menu.addItem(.separator())
        menu.addItem(elementAction("Afficher mes leçons", #selector(afficherLecons)))
        menu.addItem(elementAction("Importer des leçons…", #selector(importerLecons)))
        menu.addItem(elementAction("Exporter mes leçons…", #selector(exporterLecons)))
        menu.addItem(elementAction("Afficher les statistiques des apprenants", #selector(afficherStatistiques)))
        menu.addItem(.separator())
        menu.addItem(elementAction("Accéder à l’espace apprenant…", #selector(accederApprenant)))
        menu.addItem(elementAction("Changer de formateur…", #selector(changerFormateur)))

        element.submenu = menu
        let indexContact = barre.items.firstIndex { $0.title == "Contact" } ?? barre.items.count
        barre.insertItem(element, at: indexContact)
        elementMenu = element
    }

    private func retirer() {
        guard let barre = NSApp.mainMenu else { return }
        if let elementMenu,
           barre.items.contains(where: { $0 === elementMenu }) {
            barre.removeItem(elementMenu)
        } else if let index = barre.items.firstIndex(where: { $0.title == "Formateur" }) {
            barre.removeItem(at: index)
        }
        elementMenu = nil

        if let elementProfil,
           !barre.items.contains(where: { $0 === elementProfil }) {
            barre.insertItem(elementProfil, at: min(indexProfil, barre.items.count))
        }
        self.elementProfil = nil
    }

    private func elementAction(_ titre: String, _ action: Selector) -> NSMenuItem {
        let element = NSMenuItem(title: titre, action: action, keyEquivalent: "")
        element.target = self
        return element
    }

    @objc private func afficherLecons() {
        NotificationCenter.default.post(name: .afficherLeconsFormateur, object: nil)
    }

    @objc private func accederApprenant() {
        NotificationCenter.default.post(name: .accederEspaceApprenant, object: nil)
    }

    @objc private func afficherStatistiques() {
        NotificationCenter.default.post(name: .afficherStatistiquesFormateur, object: nil)
    }

    @objc private func changerFormateur() {
        NotificationCenter.default.post(name: .changerDeFormateur, object: nil)
    }

    @objc private func importerLecons() {
        let panneau = NSOpenPanel()
        panneau.title = "Importer des leçons"
        panneau.message = "Choisissez un fichier de leçons personnalisées Apprenti Clavier."
        panneau.prompt = "Importer"
        panneau.canChooseFiles = true
        panneau.canChooseDirectories = false
        panneau.allowsMultipleSelection = false
        panneau.allowedContentTypes = [.data, .json]
        panneau.begin { reponse in
            guard reponse == .OK, let adresse = panneau.url else { return }
            do {
                let resultat = try FormateurManager.shared.importer(
                    depuis: Data(contentsOf: adresse)
                )
                self.afficherMessage(
                    titre: resultat.ajoutees == 0 && resultat.misesAJour == 0
                        ? "Leçons déjà présentes"
                        : "Importation réussie",
                    message: self.messageImportation(resultat),
                    apresFermeture: {
                        NotificationCenter.default.post(
                            name: .afficherLeconsFormateur,
                            object: nil
                        )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            NotificationCenter.default.post(
                                name: .replacerFocusListeLeconsFormateur,
                                object: nil
                            )
                        }
                    }
                )
            } catch {
                self.afficherMessage(titre: "Importation impossible", message: error.localizedDescription)
            }
        }
    }

    @objc private func exporterLecons() {
        do {
            let donnees = try FormateurManager.shared.donneesPourExportation()
            guard let dossier = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                throw NSError(domain: "ApprentiClavier", code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "Le dossier Téléchargements est introuvable."])
            }
            let nomFormateur = nomFichierSecurise(FormateurManager.shared.formateurActif ?? "Formateur")
            let base = "Lecons-personnalisees-\(nomFormateur)-Apprenti-Clavier"
            var adresse = dossier.appendingPathComponent("\(base).apprenticlavierlecons")
            var numero = 2
            while FileManager.default.fileExists(atPath: adresse.path) {
                adresse = dossier.appendingPathComponent("\(base)-\(numero).apprenticlavierlecons")
                numero += 1
            }
            try donnees.write(to: adresse, options: .atomic)
            ExportFileIcon.appliquer(a: adresse)
            NSWorkspace.shared.activateFileViewerSelecting([adresse])
            afficherMessage(
                titre: "Exportation réussie",
                message: "Les leçons personnalisées ont été exportées dans le dossier Téléchargements.",
                apresFermeture: replacerFocusListeSiPresente
            )
        } catch FormateurManager.ErreurLecons.aucuneLecon {
            afficherMessage(
                titre: "Aucune leçon à exporter",
                message: "Créez une leçon personnalisée avant d’effectuer une exportation.",
                apresFermeture: replacerFocusListeSiPresente
            )
        } catch {
            afficherMessage(titre: "Exportation impossible", message: error.localizedDescription)
        }
    }

    private func afficherMessage(
        titre: String,
        message: String,
        apresFermeture: @escaping () -> Void = { }
    ) {
        if let fenetreMessage, fenetreMessage.isVisible {
            fenetreMessage.close()
        }

        var fenetre: NSWindow? = nil
        let vue = MessageFormateurView(titre: titre, message: message) {
            fenetre?.close()
            apresFermeture()
        }
        let nouvelleFenetre = NSWindow(
            contentViewController: NSHostingController(rootView: vue)
        )
        fenetre = nouvelleFenetre
        // Le titre visuel est fourni par le contenu SwiftUI. Un titre natif
        // identique provoquerait une première annonce interrompue, puis une
        // seconde annonce lors du placement du focus VoiceOver.
        nouvelleFenetre.title = ""
        nouvelleFenetre.titleVisibility = .hidden
        nouvelleFenetre.styleMask = [.titled]
        nouvelleFenetre.isReleasedWhenClosed = false
        nouvelleFenetre.center()
        fenetreMessage = nouvelleFenetre
        NSApp.activate(ignoringOtherApps: true)
        nouvelleFenetre.makeKeyAndOrderFront(nil)
    }

    private func replacerFocusListeSiPresente() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            NotificationCenter.default.post(
                name: .replacerFocusListeLeconsFormateur,
                object: nil
            )
        }
    }

    private func messageImportation(
        _ resultat: ResultatImportationLecons
    ) -> String {
        if resultat.ajoutees == 0 && resultat.misesAJour == 0 {
            return resultat.dejaPresentes == 1
                ? "Aucune nouvelle leçon importée. Cette leçon est déjà présente."
                : "Aucune nouvelle leçon importée. Toutes les leçons de ce fichier sont déjà présentes."
        }

        var parties: [String] = []
        if resultat.ajoutees > 0 {
            parties.append(
                resultat.ajoutees == 1
                    ? "1 leçon importée"
                    : "\(resultat.ajoutees) leçons importées"
            )
        }
        if resultat.misesAJour > 0 {
            parties.append(
                resultat.misesAJour == 1
                    ? "1 leçon mise à jour"
                    : "\(resultat.misesAJour) leçons mises à jour"
            )
        }
        if resultat.dejaPresentes > 0 {
            parties.append(
                resultat.dejaPresentes == 1
                    ? "1 leçon déjà présente"
                    : "\(resultat.dejaPresentes) leçons déjà présentes"
            )
        }
        return parties.joined(separator: ", ") + "."
    }

    private func nomFichierSecurise(_ nom: String) -> String {
        let interdits = CharacterSet(charactersIn: "/:\\?%*|\"<>")
        let valeur = nom.components(separatedBy: interdits).joined(separator: "-")
        return valeur.isEmpty ? "Formateur" : valeur
    }
}
