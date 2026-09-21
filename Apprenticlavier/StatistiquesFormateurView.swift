import SwiftUI
import AppKit

private struct ErreurStatistiqueAffichee: Identifiable {
    let id: String
    let statistique: StatistiqueExercice
    let type: TypeErreurSaisie
    let detail: DetailErreurSaisie?
    let nombreAncien: Int
}

private struct GroupeLeconErreur: Identifiable {
    let id: String
    let titre: String
    let erreurs: [ErreurStatistiqueAffichee]
}

private struct GroupeSourceErreur: Identifiable {
    let id: String
    let titre: String
    let lecons: [GroupeLeconErreur]
}

struct StatistiquesFormateurView: View {
    let retour: () -> Void

    @ObservedObject private var progression = ProgressionManager.shared
    @ObservedObject private var erreurs = StatistiquesErreursManager.shared
    @State private var apprenantSelectionne: String? = nil
    @State private var messageExportation = ""
    @State private var confirmationExportationPresentee = false
    @State private var dernierFichierExporte: URL?
    @State private var moniteurClavier: Any?

    private enum Focus: Hashable {
        case titre, informationsGenerales, apprenant(String)
    }
    @AccessibilityFocusState private var elementEnFocus: Focus?
    @Namespace private var espaceEntetes
    @Namespace private var espaceBoutons

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Statistiques des apprenants")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($elementEnFocus, equals: .titre)
                    .accessibilityRotorEntry(
                        id: "statistiques-formateur-titre",
                        in: espaceEntetes
                    )

                Button(titreBoutonExportation) { exporterStatistiques() }
                    .accessibilityRotorEntry(id: "stats-formateur-exporter", in: espaceBoutons)

                Picker("Choisir un apprenant", selection: $apprenantSelectionne) {
                    Text("Aucun apprenant sélectionné").tag(nil as String?)
                    ForEach(progression.profilsUtilisateurs, id: \.self) { apprenant in
                        Text(apprenant).tag(Optional(apprenant))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: apprenantSelectionne) { valeur in
                    placerFocusApresSelection(valeur)
                }

                if !messageExportation.isEmpty { Text(messageExportation) }

                if let apprenant = apprenantSelectionne {
                    details(apprenant)
                } else {
                    vueGenerale
                }

                HStack {
                    Spacer()

                    Button("Fermer") {
                        retour()
                    }
                    .keyboardShortcut("w", modifiers: .command)
                    .accessibilityLabel("Fermer")
                    .accessibilityRotorEntry(
                        id: "stats-formateur-fermer",
                        in: espaceBoutons
                    )
                }

            }
            .padding(36)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .frame(minWidth: 780, minHeight: 640)
        .accessibilityRotor("Boutons Apprenti Clavier") {
            AccessibilityRotorEntry(Text(titreBoutonExportation), id: "stats-formateur-exporter", in: espaceBoutons)
            AccessibilityRotorEntry(
                "Fermer",
                id: "stats-formateur-fermer",
                in: espaceBoutons
            )
        }
        .accessibilityRotor("En-têtes Apprenti Clavier") {
            ForEach(entetesStatistiques, id: \.id) { entete in
                AccessibilityRotorEntry(Text(entete.titre), id: entete.id, in: espaceEntetes)
            }
        }
        .alert("Exportation réussie", isPresented: $confirmationExportationPresentee) {
            Button("D’accord") {
                if let adresse = dernierFichierExporte {
                    NSWorkspace.shared.activateFileViewerSelecting([adresse])
                }
                dernierFichierExporte = nil
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("Exportation réussie dans le dossier Téléchargements. Appuyez sur Entrée pour fermer cette fenêtre.")
        }
        .onAppear {
            placerFocusTitre()
            installerMoniteurClavier()
        }
        .onDisappear { retirerMoniteurClavier() }
        .onExitCommand { retour() }
    }

    // Un seul rotor sur le conteneur commun inclut aussi le titre de la fenêtre.
    // Les branches restent hors du constructeur AccessibilityRotorContent.
    private var entetesStatistiques: [(id: String, titre: String)] {
        var entetes = [(id: "statistiques-formateur-titre", titre: "Statistiques des apprenants")]
        if let apprenant = apprenantSelectionne {
            let donnees = erreurs.statistiques(pour: apprenant)
            entetes.append(("details-apprenant-\(apprenant)", "Statistiques de \(apprenant)"))
            entetes.append(("details-difficultes-\(apprenant)", "Difficultés repérées"))
            for type in categoriesAvecErreurs(donnees) {
                entetes.append((idCategorie(type, apprenant: apprenant), titreCategorie(type)))
                for source in groupesErreurs(type: type, donnees: donnees) {
                    entetes.append((idSource(source, type: type, apprenant: apprenant), source.titre))
                    for lecon in source.lecons {
                        entetes.append((idLecon(lecon, source: source, type: type, apprenant: apprenant), lecon.titre))
                        for erreur in lecon.erreurs where erreur.detail != nil {
                            entetes.append(("exercice|\(apprenant)|\(erreur.id)", "Exercice \(erreur.statistique.exerciceNumero)"))
                        }
                    }
                }
            }
            entetes.append(("details-personnalisees-\(apprenant)", "Résultats des leçons personnalisées"))
            let groupes = Dictionary(grouping: donnees.filter { $0.leconPersonnaliseeID != nil }) {
                ($0.formateur ?? "Formateur") + "|" + ($0.leconPersonnaliseeID?.uuidString ?? $0.leconTitre)
            }
            for cle in groupes.keys.sorted() {
                if let premiere = groupes[cle]?.first {
                    entetes.append(("resultat-personnalise|\(apprenant)|\(cle)", premiere.leconTitre))
                }
            }
        } else {
            entetes.append(("statistiques-formateur-general", "Informations générales"))
            for apprenant in progression.profilsUtilisateurs {
                entetes.append(("general-apprenant-\(apprenant)", apprenant))
            }
        }
        return entetes
    }

    private func installerMoniteurClavier() {
        retirerMoniteurClavier()
        moniteurClavier = NSEvent.addLocalMonitorForEvents(
            matching: .keyDown
        ) { evenement in
            guard evenement.keyCode == 53 else { return evenement }
            DispatchQueue.main.async { retour() }
            return nil
        }
    }

    private func retirerMoniteurClavier() {
        if let moniteurClavier {
            NSEvent.removeMonitor(moniteurClavier)
            self.moniteurClavier = nil
        }
    }

    private var titreBoutonExportation: String {
        apprenantSelectionne.map { "Exporter les statistiques de \($0)" }
            ?? "Exporter les statistiques de tous les apprenants"
    }

    private var vueGenerale: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informations générales")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($elementEnFocus, equals: .informationsGenerales)
                .accessibilityRotorEntry(
                    id: "statistiques-formateur-general",
                    in: espaceEntetes
                )

            if progression.profilsUtilisateurs.isEmpty {
                Text("Aucun profil apprenant n’est enregistré.")
            }

            ForEach(progression.profilsUtilisateurs, id: \.self) { apprenant in
                let donnees = erreurs.statistiques(pour: apprenant)
                VStack(alignment: .leading, spacing: 5) {
                    Text(apprenant)
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: "general-apprenant-\(apprenant)",
                            in: espaceEntetes
                        )
                    Text(libelleLecons(progression.nombreLeconsTerminees(pour: apprenant)))
                    Text(libelleErreurs(donnees.reduce(0) { $0 + $1.erreurs }))
                    Text(libelleTentatives(donnees.reduce(0) { $0 + $1.tentatives }))
                }
            }
        }

    }

    private func details(_ apprenant: String) -> some View {
        let donnees = erreurs.statistiques(pour: apprenant)
        let vitesse = progression.statistiquesVitesse(pour: apprenant)
        let categories = categoriesAvecErreurs(donnees)

        return VStack(alignment: .leading, spacing: 18) {
            Text("Statistiques de \(apprenant)")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($elementEnFocus, equals: .apprenant(apprenant))
                .accessibilityRotorEntry(
                    id: "details-apprenant-\(apprenant)",
                    in: espaceEntetes
                )

            Text(libelleLecons(progression.nombreLeconsTerminees(pour: apprenant)) + " dans les 14 modules")
            Text(libelleTentatives(donnees.reduce(0) { $0 + $1.tentatives }))
            Text(libelleReussites(donnees.reduce(0) { $0 + $1.reussites }))
            Text(libelleErreurs(donnees.reduce(0) { $0 + $1.erreurs }))
            if vitesse.dureeTotale > 0 {
                Text(String(format: "Vitesse moyenne : %.1f mots par minute", vitesse.vitesseMoyenneMPM))
            }

            Text("Difficultés repérées")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityRotorEntry(
                    id: "details-difficultes-\(apprenant)",
                    in: espaceEntetes
                )

            if categories.isEmpty {
                Text("Aucune erreur n’est actuellement enregistrée pour cet apprenant.")
            }

            ForEach(categories, id: \.rawValue) { type in
                let groupes = groupesErreurs(type: type, donnees: donnees)
                VStack(alignment: .leading, spacing: 12) {
                    Text(titreCategorie(type))
                        .font(.title3.bold())
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: idCategorie(type, apprenant: apprenant),
                            in: espaceEntetes
                        )

                    ForEach(groupes) { source in
                        Text(source.titre)
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityRotorEntry(
                                id: idSource(source, type: type, apprenant: apprenant),
                                in: espaceEntetes
                            )

                        ForEach(source.lecons) { lecon in
                            VStack(alignment: .leading, spacing: 7) {
                                Text(lecon.titre)
                                    .font(.headline)
                                    .accessibilityAddTraits(.isHeader)
                                    .accessibilityRotorEntry(
                                        id: idLecon(lecon, source: source, type: type, apprenant: apprenant),
                                        in: espaceEntetes
                                    )
                                ForEach(lecon.erreurs) { erreur in
                                    vueErreur(erreur, apprenant: apprenant)
                                }
                            }
                        }
                    }
                }
            }

            sectionLeconsPersonnalisees(donnees, apprenant: apprenant)
        }

    }

    private func sectionLeconsPersonnalisees(
        _ donnees: [StatistiqueExercice],
        apprenant: String
    ) -> some View {
        let personnalisees = donnees.filter { $0.leconPersonnaliseeID != nil }
        let groupes = Dictionary(grouping: personnalisees) {
            ($0.formateur ?? "Formateur") + "|" + ($0.leconPersonnaliseeID?.uuidString ?? $0.leconTitre)
        }

        return VStack(alignment: .leading, spacing: 10) {
            Text("Résultats des leçons personnalisées")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityRotorEntry(
                    id: "details-personnalisees-\(apprenant)",
                    in: espaceEntetes
                )

            if groupes.isEmpty {
                Text("Aucune leçon personnalisée n’a encore été effectuée.")
            }

            ForEach(groupes.keys.sorted(), id: \.self) { cle in
                let valeurs = groupes[cle] ?? []
                if let premiere = valeurs.first {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(premiere.leconTitre)
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityRotorEntry(id: "resultat-personnalise|\(apprenant)|\(cle)", in: espaceEntetes)
                        Text("Formateur : \(premiere.formateur ?? "Formateur")")
                        if let objectif = premiere.objectifPedagogique {
                            Text(objectif.descriptionPourApprenant)
                        }
                        Text(libelleTentatives(valeurs.reduce(0) { $0 + $1.tentatives }))
                        Text(libelleReussites(valeurs.reduce(0) { $0 + $1.reussites }))
                        Text(libelleErreurs(valeurs.reduce(0) { $0 + $1.erreurs }))
                    }
                }
            }
        }
    }

    private func categoriesAvecErreurs(_ donnees: [StatistiqueExercice]) -> [TypeErreurSaisie] {
        TypeErreurSaisie.allCases.filter { type in
            donnees.contains { $0.erreursParType[type.rawValue, default: 0] > 0 }
        }
    }

    private func groupesErreurs(
        type: TypeErreurSaisie,
        donnees: [StatistiqueExercice]
    ) -> [GroupeSourceErreur] {
        var erreursAffichees: [ErreurStatistiqueAffichee] = []

        for statistique in donnees {
            let details = (statistique.detailsErreurs ?? []).filter { $0.type == type }
            if details.isEmpty {
                let ancienNombre = statistique.erreursParType[type.rawValue, default: 0]
                if ancienNombre > 0 {
                    erreursAffichees.append(
                        ErreurStatistiqueAffichee(
                            id: statistique.id + "|ancien|" + type.rawValue,
                            statistique: statistique,
                            type: type,
                            detail: nil,
                            nombreAncien: ancienNombre
                        )
                    )
                }
            } else {
                for detail in details {
                    erreursAffichees.append(
                        ErreurStatistiqueAffichee(
                            id: detail.id.uuidString,
                            statistique: statistique,
                            type: type,
                            detail: detail,
                            nombreAncien: 0
                        )
                    )
                }
            }
        }

        let parSource = Dictionary(grouping: erreursAffichees) { erreur in
            if let formateur = erreur.statistique.formateur {
                return "personnalisee|" + formateur
            }
            return "module|\(erreur.statistique.moduleNumero ?? 0)"
        }

        return parSource.keys.sorted().map { cleSource in
            let valeursSource = parSource[cleSource] ?? []
            let parLecon = Dictionary(grouping: valeursSource) { $0.statistique.leconTitre }
            let lecons = parLecon.keys.sorted().map { titreLecon in
                GroupeLeconErreur(
                    id: cleSource + "|" + titreLecon,
                    titre: titreLecon,
                    erreurs: (parLecon[titreLecon] ?? []).sorted {
                        $0.statistique.exerciceNumero < $1.statistique.exerciceNumero
                    }
                )
            }
            return GroupeSourceErreur(
                id: cleSource,
                titre: titreSourceErreur(valeursSource.first?.statistique),
                lecons: lecons
            )
        }
    }

    private func titreSourceErreur(_ statistique: StatistiqueExercice?) -> String {
        guard let statistique else { return "Parcours pédagogique" }
        if let formateur = statistique.formateur {
            return "Leçons personnalisées de \(formateur)"
        }
        return statistique.moduleTitre ?? "Parcours pédagogique"
    }

    private func descriptionErreur(_ erreur: ErreurStatistiqueAffichee) -> String {
        let numero = erreur.statistique.exerciceNumero
        guard let detail = erreur.detail else {
            return "Exercice \(numero) : \(libelleErreurs(erreur.nombreAncien)). Le détail de cette ancienne saisie n’est pas disponible."
        }
        let saisi = detail.texteSaisi.isEmpty
            ? "aucun caractère"
            : "« \(detail.texteSaisi) »"
        return [
            "Exercice \(numero)",
            "Texte attendu : « \(detail.texteAttendu) »",
            "Texte saisi : \(saisi)",
            "Type d’erreur : \(detail.type.rawValue)"
        ].joined(separator: "\n")
    }

    @ViewBuilder
    private func vueErreur(_ erreur: ErreurStatistiqueAffichee, apprenant: String) -> some View {
        if let detail = erreur.detail {
            VStack(alignment: .leading, spacing: 4) {
                Text("Exercice \(erreur.statistique.exerciceNumero)")
                    .font(.subheadline.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityRotorEntry(id: "exercice|\(apprenant)|\(erreur.id)", in: espaceEntetes)
                Text("Texte attendu : « \(detail.texteAttendu) »")
                    .accessibilityLabel(
                        "Texte attendu. "
                            + descriptionCaracteresPourVoiceOver(
                                detail.texteAttendu
                            )
                    )
                Text(
                    detail.texteSaisi.isEmpty
                        ? "Texte saisi : aucun caractère"
                        : "Texte saisi : « \(detail.texteSaisi) »"
                )
                .accessibilityLabel(
                    detail.texteSaisi.isEmpty
                        ? "Texte saisi. Aucun caractère."
                        : "Texte saisi. "
                            + descriptionCaracteresPourVoiceOver(
                                detail.texteSaisi
                            )
                )
                Text("Type d’erreur : \(detail.type.rawValue)")
            }
        } else {
            Text(descriptionErreur(erreur))
        }
    }

    private func descriptionCaracteresPourVoiceOver(
        _ texte: String
    ) -> String {
        var resultat: [String] = []
        var mot = ""

        func ajouterMot() {
            guard !mot.isEmpty else { return }
            resultat.append(mot)
            for caractere in mot {
                if let accent = nomAccentPourVoiceOver(caractere) {
                    resultat.append(accent)
                } else if caractere.isUppercase {
                    resultat.append("\(caractere) majuscule")
                }
            }
            mot = ""
        }

        for caractere in texte {
            switch caractere {
            case " ":
                ajouterMot()
                resultat.append("espace")
            case "'", "’", "‘", "ʼ":
                ajouterMot()
                resultat.append("apostrophe")
            case ".":
                ajouterMot()
                resultat.append("point")
            case ",":
                ajouterMot()
                resultat.append("virgule")
            case ";":
                ajouterMot()
                resultat.append("point-virgule")
            case ":":
                ajouterMot()
                resultat.append("deux-points")
            case "!":
                ajouterMot()
                resultat.append("point d’exclamation")
            case "?":
                ajouterMot()
                resultat.append("point d’interrogation")
            case "-":
                ajouterMot()
                resultat.append("trait d’union")
            case "\n":
                ajouterMot()
                resultat.append("retour à la ligne")
            default:
                mot.append(caractere)
            }
        }

        ajouterMot()
        return resultat.joined(separator: ", ")
    }

    private func nomAccentPourVoiceOver(_ caractere: Character) -> String? {
        switch caractere {
        case "é": return "E accent aigu"
        case "É": return "E accent aigu majuscule"
        case "è": return "E accent grave"
        case "È": return "E accent grave majuscule"
        case "à": return "A accent grave"
        case "À": return "A accent grave majuscule"
        case "ù": return "U accent grave"
        case "Ù": return "U accent grave majuscule"
        case "ç": return "C cédille"
        case "Ç": return "C cédille majuscule"
        case "â": return "A accent circonflexe"
        case "ê": return "E accent circonflexe"
        case "î": return "I accent circonflexe"
        case "ô": return "O accent circonflexe"
        case "û": return "U accent circonflexe"
        case "ä": return "A tréma"
        case "ë": return "E tréma"
        case "ï": return "I tréma"
        case "ö": return "O tréma"
        case "ü": return "U tréma"
        default: return nil
        }
    }

    private func titreCategorie(_ type: TypeErreurSaisie) -> String {
        switch type {
        case .accent: return "Erreurs d’accent"
        case .ponctuation: return "Erreurs de ponctuation"
        case .casse: return "Majuscules ou minuscules"
        case .caractereManquant: return "Caractères manquants"
        case .caractereSuperflu: return "Caractères en trop"
        case .caractereIncorrect: return "Caractères incorrects"
        }
    }

    private func idCategorie(_ type: TypeErreurSaisie, apprenant: String) -> String {
        "categorie|\(apprenant)|\(type.rawValue)"
    }

    private func idSource(
        _ source: GroupeSourceErreur,
        type: TypeErreurSaisie,
        apprenant: String
    ) -> String {
        "source|\(apprenant)|\(type.rawValue)|\(source.id)"
    }

    private func idLecon(
        _ lecon: GroupeLeconErreur,
        source: GroupeSourceErreur,
        type: TypeErreurSaisie,
        apprenant: String
    ) -> String {
        "lecon|\(apprenant)|\(type.rawValue)|\(source.id)|\(lecon.id)"
    }

    private func placerFocusTitre() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            elementEnFocus = .titre
        }
    }

    private func placerFocusApresSelection(_ apprenant: String?) {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if let apprenant {
                elementEnFocus = .apprenant(apprenant)
            } else {
                elementEnFocus = .informationsGenerales
            }
        }
    }

    private func libelleLecons(_ nombre: Int) -> String {
        nombre == 1 ? "1 leçon terminée" : "\(nombre) leçons terminées"
    }

    private func libelleTentatives(_ nombre: Int) -> String {
        nombre == 1 ? "1 tentative enregistrée" : "\(nombre) tentatives enregistrées"
    }

    private func libelleReussites(_ nombre: Int) -> String {
        nombre == 1 ? "1 réussite" : "\(nombre) réussites"
    }

    private func libelleErreurs(_ nombre: Int) -> String {
        nombre == 1 ? "1 erreur" : "\(nombre) erreurs"
    }

    private func exporterStatistiques() {
        let apprenants = apprenantSelectionne.map { [$0] }
            ?? progression.profilsUtilisateurs
        let contenu = apprenants.map(texteStatistiques).joined(separator: "\n\n")
        guard let dossier = FileManager.default.urls(
            for: .downloadsDirectory,
            in: .userDomainMask
        ).first else {
            messageExportation = "Le dossier Téléchargements est introuvable."
            return
        }

        let nomFormateur = nomFichierSecurise(FormateurManager.shared.formateurActif ?? "Formateur")
        let base = apprenantSelectionne.map {
            "Statistiques-de-l-apprenant-\(nomFichierSecurise($0))-Formateur-\(nomFormateur)-Apprenti-Clavier"
        } ?? "Statistiques-de-tous-les-apprenants-Formateur-\(nomFormateur)-Apprenti-Clavier"

        var adresse = dossier.appendingPathComponent(base + ".txt")
        var numero = 2
        while FileManager.default.fileExists(atPath: adresse.path) {
            adresse = dossier.appendingPathComponent("\(base)-\(numero).txt")
            numero += 1
        }

        do {
            try contenu.write(to: adresse, atomically: true, encoding: .utf8)
            ExportFileIcon.appliquer(a: adresse)
            messageExportation = ""
            dernierFichierExporte = adresse
            confirmationExportationPresentee = true
        } catch {
            messageExportation = "Exportation impossible : \(error.localizedDescription)"
        }
    }

    private func texteStatistiques(_ apprenant: String) -> String {
        let donnees = erreurs.statistiques(pour: apprenant)
        var lignes = [
            "Statistiques de \(apprenant)",
            libelleLecons(progression.nombreLeconsTerminees(pour: apprenant)),
            libelleTentatives(donnees.reduce(0) { $0 + $1.tentatives }),
            libelleReussites(donnees.reduce(0) { $0 + $1.reussites }),
            libelleErreurs(donnees.reduce(0) { $0 + $1.erreurs }),
            "",
            "Difficultés repérées"
        ]

        let categories = categoriesAvecErreurs(donnees)
        if categories.isEmpty { lignes.append("Aucune erreur enregistrée.") }

        for type in categories {
            lignes.append("")
            lignes.append(titreCategorie(type))
            for source in groupesErreurs(type: type, donnees: donnees) {
                lignes.append(source.titre)
                for lecon in source.lecons {
                    lignes.append(lecon.titre)
                    lignes.append(contentsOf: lecon.erreurs.map(descriptionErreur))
                }
            }
        }

        lignes.append("")
        lignes.append("Résultats des leçons personnalisées")
        let personnalisees = donnees.filter { $0.leconPersonnaliseeID != nil }
        let groupes = Dictionary(grouping: personnalisees) {
            ($0.formateur ?? "Formateur") + "|" + ($0.leconPersonnaliseeID?.uuidString ?? $0.leconTitre)
        }
        if groupes.isEmpty { lignes.append("Aucune leçon personnalisée effectuée.") }
        for cle in groupes.keys.sorted() {
            let valeurs = groupes[cle] ?? []
            guard let premiere = valeurs.first else { continue }
            lignes.append(premiere.leconTitre)
            lignes.append("Formateur : \(premiere.formateur ?? "Formateur")")
            if let objectif = premiere.objectifPedagogique {
                lignes.append(objectif.descriptionPourApprenant)
            }
            lignes.append(libelleTentatives(valeurs.reduce(0) { $0 + $1.tentatives }))
            lignes.append(libelleReussites(valeurs.reduce(0) { $0 + $1.reussites }))
            lignes.append(libelleErreurs(valeurs.reduce(0) { $0 + $1.erreurs }))
        }

        return lignes.joined(separator: "\n")
    }

    private func nomFichierSecurise(_ texte: String) -> String {
        let autorises = CharacterSet.alphanumerics
            .union(CharacterSet(charactersIn: "-_ "))
        return texte.components(separatedBy: autorises.inverted)
            .joined()
            .replacingOccurrences(of: " ", with: "-")
    }
}
