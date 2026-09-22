//
//  StatistiquesView.swift
//  Apprenti Clavier
//
//  Première version de la page Statistiques.
//

import SwiftUI
import AppKit

struct StatistiquesView: View {

    @ObservedObject private var progression =
        ProgressionManager.shared

    @State private var messageExportation = ""

    @AccessibilityFocusState
    private var titreEnFocus: Bool
    @Namespace private var espaceEntetes
    @Namespace private var espaceBoutons

    private var nombreTotalLecons: Int {
        ModuleDefinition.toutesLesLecons.count
    }

    private var progressionGenerale: Int {
        progression.pourcentageProgression(
            nombreTotalDeLecons: nombreTotalLecons
        )
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                Text("Mes statistiques")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused(
                        $titreEnFocus
                    )
                    .acAccessibilityRotorEntry(
                        id: "statistiques-titre",
                        in: espaceEntetes
                    )

                Button("Exporter mes statistiques…") {
                    exporterStatistiques()
                }
                .accessibilityLabel("Exporter mes statistiques")
                .acAccessibilityRotorEntry(id: "stats-exporter", in: espaceBoutons)

                if let utilisateur =
                    progression.utilisateurActif {
                    Text(
                        "Profil : \(utilisateur)"
                    )
                    .font(.title2)
                    .accessibilityLabel(
                        "Profil actif : \(utilisateur)"
                    )
                }

                if !messageExportation.isEmpty {
                    Text(messageExportation)
                        .accessibilityLabel(
                            messageExportation
                        )
                }

                sectionProgressionGenerale

                Divider()

                sectionVitesseFrappe

                Divider()

                sectionParModule

                HStack {
                    Spacer()

                    Button("Fermer") {
                        NSApplication.shared.keyWindow?
                            .performClose(nil)
                    }
                    .keyboardShortcut("w", modifiers: .command)
                    .accessibilityLabel("Fermer")
                    .acAccessibilityRotorEntry(id: "stats-fermer", in: espaceBoutons)
                }
            }
            .padding(32)
            .frame(
                maxWidth: 760,
                alignment: .leading
            )
        }
        .navigationTitle("Mes statistiques")
        .onAppear {
            titreEnFocus = false

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.4
            ) {
                titreEnFocus = true
            }
        }
        .onExitCommand {
            NSApplication.shared.keyWindow?
                .performClose(nil)
        }
        .acAccessibilityRotor("Boutons Apprenti Clavier", montereyEntries: {
            ACMontereyRotorEntry(
                "Exporter mes statistiques",
                id: "stats-exporter",
                in: espaceBoutons
            )
            ACMontereyRotorEntry(
                "Fermer",
                id: "stats-fermer",
                in: espaceBoutons
            )
        }) {
            AccessibilityRotorEntry(
                "Exporter mes statistiques",
                id: "stats-exporter",
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Fermer",
                id: "stats-fermer",
                in: espaceBoutons
            )
        }
        .onDisappear {
            NotificationCenter.default.post(
                name: .replacerFocusEspaceApprenant,
                object: nil
            )
        }
        .acAccessibilityRotor("En-têtes Apprenti Clavier", montereyEntries: {
            ACMontereyRotorEntry(
                "Mes statistiques",
                id: "statistiques-titre",
                in: espaceEntetes
            )
            ACMontereyRotorEntry(
                "Progression générale",
                id: "statistiques-progression",
                in: espaceEntetes
            )
            ACMontereyRotorEntry(
                "Vitesse de frappe",
                id: "statistiques-vitesse",
                in: espaceEntetes
            )
            ACMontereyRotorEntry(
                "Progression par module",
                id: "statistiques-modules",
                in: espaceEntetes
            )
            acMontereyRotorItems(ModuleDefinition.tousLesModules) { module in
                ACMontereyRotorEntry(
                    module.titre,
                    id: "statistiques-module-\(module.id)",
                    in: espaceEntetes
                )
            }
        }) {
            AccessibilityRotorEntry(
                "Mes statistiques",
                id: "statistiques-titre",
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Progression générale",
                id: "statistiques-progression",
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Vitesse de frappe",
                id: "statistiques-vitesse",
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Progression par module",
                id: "statistiques-modules",
                in: espaceEntetes
            )
            ForEach(ModuleDefinition.tousLesModules) { module in
                AccessibilityRotorEntry(
                    Text(module.titre),
                    id: "statistiques-module-\(module.id)",
                    in: espaceEntetes
                )
            }
        }
    }

    private var sectionProgressionGenerale: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Progression générale")
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: "statistiques-progression",
                    in: espaceEntetes
                )

            Text(
                "\(progression.nombreLeconsTerminees) "
                + "leçons terminées sur "
                + "\(nombreTotalLecons)"
            )
            .accessibilityLabel(
                "\(progression.nombreLeconsTerminees) "
                + "leçons terminées sur "
                + "\(nombreTotalLecons)"
            )

            ProgressView(
                value: Double(progressionGenerale),
                total: 100
            )
            .accessibilityLabel(
                "Progression générale"
            )
            .accessibilityValue(
                "\(progressionGenerale) pour cent"
            )

            Text(
                "\(progressionGenerale) %"
            )
            .font(.title3)
            .fontWeight(.semibold)
            .accessibilityLabel(
                "Progression générale : "
                + "\(progressionGenerale) pour cent"
            )
        }
    }

    private var sectionVitesseFrappe: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Vitesse de frappe")
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: "statistiques-vitesse",
                    in: espaceEntetes
                )

            if progression.statistiquesVitesse.dureeTotale > 0 {
                let moyenne =
                    progression.statistiquesVitesse
                        .vitesseMoyenneMPM

                let meilleure =
                    progression.statistiquesVitesse
                        .meilleureVitesseMPM

                Text(
                    "Vitesse moyenne : "
                    + String(format: "%.1f", moyenne)
                    + " mots par minute"
                )
                .accessibilityLabel(
                    "Vitesse moyenne : "
                    + String(format: "%.1f", moyenne)
                    + " mots par minute"
                )

                Text(
                    "Meilleure vitesse : "
                    + String(format: "%.1f", meilleure)
                    + " mots par minute"
                )
                .accessibilityLabel(
                    "Meilleure vitesse : "
                    + String(format: "%.1f", meilleure)
                    + " mots par minute"
                )

                Text(
                    "La vitesse est mesurée en arrière-plan "
                    + "à partir du premier caractère saisi. "
                    + "Un mot correspond à cinq caractères."
                )
                .font(.callout)
            } else {
                Text(
                    "Aucune donnée de vitesse pour le moment. "
                    + "La mesure commencera avec les exercices "
                    + "de mots du Module 5."
                )
            }
        }
    }

    private var sectionParModule: some View {
        VStack(
            alignment: .leading,
            spacing: 18
        ) {
            Text("Progression par module")
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: "statistiques-modules",
                    in: espaceEntetes
                )

            ForEach(
                ModuleDefinition.tousLesModules
            ) { module in
                blocModule(module)
            }
        }
    }

    private func blocModule(
        _ module: ModuleDefinition
    ) -> some View {
        let terminees =
            progression.nombreLeconsTerminees(
                dans: module
            )

        let total = module.lecons.count

        let pourcentage =
            progression.pourcentageProgression(
                dans: module
            )

        return VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(module.titre)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: "statistiques-module-\(module.id)",
                    in: espaceEntetes
                )

            Text(
                "\(terminees) leçons terminées sur \(total)"
            )

            ProgressView(
                value: Double(pourcentage),
                total: 100
            )
            .accessibilityLabel(
                "Progression de \(module.titre)"
            )
            .accessibilityValue(
                "\(pourcentage) pour cent"
            )

            Text("\(pourcentage) %")
                .accessibilityLabel(
                    "\(pourcentage) pour cent"
                )
        }
        .padding(.vertical, 4)
        .accessibilityElement(
            children: .contain
        )
    }

    private func exporterStatistiques() {
        guard let utilisateur =
                progression.utilisateurActif else {
            messageExportation =
                "Aucun profil actif. L’exportation est impossible."
            return
        }

        var lignes: [String] = [
            "Apprenti Clavier – Mes statistiques",
            "",
            "Profil : \(utilisateur)",
            "Progression générale : \(progressionGenerale) %",
            "Vitesse moyenne : "
                + String(
                    format: "%.1f",
                    progression.statistiquesVitesse
                        .vitesseMoyenneMPM
                )
                + " mots par minute",
            "Meilleure vitesse : "
                + String(
                    format: "%.1f",
                    progression.statistiquesVitesse
                        .meilleureVitesseMPM
                )
                + " mots par minute",
            "Leçons terminées : \(progression.nombreLeconsTerminees) sur \(nombreTotalLecons)",
            "",
            "Progression par module"
        ]

        for module in ModuleDefinition.tousLesModules {
            let terminees =
                progression.nombreLeconsTerminees(
                    dans: module
                )

            let total = module.lecons.count

            let pourcentage =
                progression.pourcentageProgression(
                    dans: module
                )

            lignes.append(
                "\(module.titre) : \(terminees) leçons terminées sur \(total), \(pourcentage) %."
            )
        }

        let contenu =
            lignes.joined(separator: "\n") + "\n"

        do {
            let dossier =
                try dossierTelechargements()

            let nomFichier =
                "Statistiques-"
                + nomDeFichierSecurise(utilisateur)
                + "-Apprenti-Clavier.txt"

            let adresse =
                adresseDisponible(
                    dans: dossier,
                    nomFichier: nomFichier
                )

            try contenu.write(
                to: adresse,
                atomically: true,
                encoding: .utf8
            )
            ExportFileIcon.appliquer(a: adresse)

            NSWorkspace.shared
                .activateFileViewerSelecting(
                    [adresse]
                )

            messageExportation =
                "Vos statistiques ont été exportées dans le dossier Téléchargements. "
                + "Le fichier est sélectionné dans le Finder."
        } catch {
            messageExportation =
                "L’exportation des statistiques a échoué : "
                + error.localizedDescription
        }
    }

    private func dossierTelechargements() throws -> URL {
        guard let dossier =
                FileManager.default.urls(
                    for: .downloadsDirectory,
                    in: .userDomainMask
                ).first else {
            throw NSError(
                domain: "ApprentiClavier",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Le dossier Téléchargements est introuvable."
                ]
            )
        }

        return dossier
    }

    private func adresseDisponible(
        dans dossier: URL,
        nomFichier: String
    ) -> URL {
        let gestionnaire =
            FileManager.default

        let nomSansExtension =
            (nomFichier as NSString)
                .deletingPathExtension

        let extensionFichier =
            (nomFichier as NSString)
                .pathExtension

        var adresse =
            dossier.appendingPathComponent(
                nomFichier,
                isDirectory: false
            )

        var numero = 2

        while gestionnaire.fileExists(
            atPath: adresse.path
        ) {
            let nouveauNom =
                "\(nomSansExtension)-\(numero).\(extensionFichier)"

            adresse =
                dossier.appendingPathComponent(
                    nouveauNom,
                    isDirectory: false
                )

            numero += 1
        }

        return adresse
    }

    private func nomDeFichierSecurise(
        _ nom: String
    ) -> String {
        let caracteresInterdits =
            CharacterSet(
                charactersIn: "/:\\?%*|\"<>"
            )

        return nom
            .components(
                separatedBy: caracteresInterdits
            )
            .joined(separator: "-")
            .replacingOccurrences(
                of: " ",
                with: "-"
            )
    }
}

struct StatistiquesView_Previews: PreviewProvider {
    static var previews: some View {
        StatistiquesView()
    }
}
