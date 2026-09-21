//
//  ReusableLessonView.swift
//  Apprenti Clavier
//
//  Vue réutilisable pour les leçons interactives.
//  Validation des exercices avec la touche Entrée.
//  Aucun bouton de vérification et aucune annonce vocale de résultat :
//  un signal sonore bref confirme la réussite ou l’erreur, puis
//  une bonne réponse enchaîne immédiatement l’exercice suivant.
//

import SwiftUI
import AppKit

struct ReusableLessonView: View {

    let lesson: LessonDefinition
    let retourMenuChapitres: () -> Void
    var enregistrerProgression: Bool = true
    var prioriserConsigneInitiale: Bool = false

    @ObservedObject private var reglages =
        AppSettings.shared

    private enum PhaseLecon {
        case etapes
        case exercices
        case resume
    }

    @State private var phase: PhaseLecon = .etapes
    @State private var indexEtape = 0
    @State private var indexExercice = 0
    @State private var texteSaisi = ""
    @State private var messageResultat = ""
    @State private var exerciceReussi = false
    @State private var inclureTitreDansConsigne = false
    @State private var champSaisieAccessibleVoiceOver = false
    @State private var demandeFocusClavier = 0
    @State private var debutChronometrage: Date?
    @State private var boutonFinLeconAccessible = false
    @State private var boutonPrincipalAccessibleVoiceOver = false
    @State private var objectifDejaAnnonce = false


    @AccessibilityFocusState private var titreLeconEnFocus: Bool
    @AccessibilityFocusState private var consigneExerciceEnFocus: Bool
    @AccessibilityFocusState private var boutonPrincipalEnFocus: Bool
    @AccessibilityFocusState private var resumeEnFocus: Bool

    init(
        lesson: LessonDefinition,
        retourMenuChapitres: @escaping () -> Void,
        enregistrerProgression: Bool = true,
        prioriserConsigneInitiale: Bool = false
    ) {
        self.lesson = lesson
        self.retourMenuChapitres = retourMenuChapitres
        self.enregistrerProgression = enregistrerProgression
        self.prioriserConsigneInitiale = prioriserConsigneInitiale
        _phase = State(initialValue: lesson.etapes.isEmpty ? .exercices : .etapes)
    }

    private var etapeActuelle: LessonStepDefinition {
        lesson.etapes[indexEtape]
    }

    private var exerciceActuel: TypingExerciseDefinition {
        lesson.exercices[indexExercice]
    }

    private var estEnEtapes: Bool {
        phase == .etapes
    }

    private var estEnExercices: Bool {
        phase == .exercices
    }

    private var estEnResume: Bool {
        phase == .resume
    }

    private var estPremiereLeconDUnModule: Bool {
        ModuleDefinition.tousLesModules.contains { module in
            module.lecons.first?.id == lesson.id
        }
    }

    private var instructionNavigationFicheInitiale: String {
        let concerneUneLeconPersonnaliseeOuUnDebutDeModule =
            lesson.identifiantLeconPersonnalisee != nil
            || estPremiereLeconDUnModule

        guard estEnEtapes,
              indexEtape == 0,
              concerneUneLeconPersonnaliseeOuUnDebutDeModule else {
            return ""
        }

        if lesson.etapes.count > 1 {
            return "Pour passer à la fiche suivante, appuyez sur la touche Entrée."
        }

        return "Pour commencer les exercices, appuyez sur la touche Entrée."
    }

    var body: some View {
        VStack(spacing: 20) {

            Text(lesson.titre)
                .font(.largeTitle)
                .bold()
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($titreLeconEnFocus)

            Text(lesson.sousTitre)
                .font(.title2)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        lesson.sousTitre
                    )
                )

            if let objectif = lesson.objectifPedagogique {
                Text(objectif.descriptionPourApprenant)
                    .font(.headline)
                    .accessibilityLabel(objectif.descriptionPourApprenant)
            }

            ficheStable

            Spacer()
        }
        .padding(40)
        .frame(minWidth: 720, minHeight: 600)
        .onAppear {
            if lesson.etapes.isEmpty {
                titreLeconEnFocus = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    annoncerExerciceEtPreparerSaisie(
                        inclureTitreLecon: true
                    )
                }
            } else {
                placerFocusInitial()

                let annonceObjectif = objectifPourEtape(
                    index: 0,
                    inclureIntroduction: true
                )
                if !annonceObjectif.isEmpty {
                    objectifDejaAnnonce = true
                }

                let annonceInitiale =
                    annonceObjectif
                    + lesson.introduction
                    + " "
                    + titreFiche
                    + ". "
                    + texteFiche

                let instruction = instructionNavigationFicheInitiale
                let annonceInitialeComplete = instruction.isEmpty
                    ? annonceInitiale
                    : annonceInitiale + "\n\n" + instruction

                VoiceOverAnnouncer.annoncerTexte(
                    annonceInitialeComplete,
                    apres: 0.8
                )
            }
        }
    }

    private var ficheStable: some View {
        VStack(spacing: 18) {

            Text(indicateurProgression)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if !titreFiche.isEmpty && !estEnResume {
                Text(titreFiche)
                    .font(.title2)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(
                        VoiceOverAnnouncer.textePourPrononciation(
                            titreFiche
                        )
                    )
                    .accessibilityHidden(true)
            }

            if estEnResume {
                (
                    Text("Résumé de la leçon\n\n")
                        .font(.title2)
                        .bold()
                    + Text(texteFiche)
                )
                .multilineTextAlignment(.center)
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        "Résumé de la leçon. "
                        + texteFiche
                        + " Appuyez sur la touche Entrée pour terminer la leçon."
                    )
                )
                .accessibilityFocused($resumeEnFocus)
            } else {
                VStack(spacing: 10) {
                    ForEach(
                        Array(paragraphesFiche.enumerated()),
                        id: \.offset
                    ) { _, paragraphe in
                        Text(paragraphe)
                            .multilineTextAlignment(.center)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        texteAvecPrononciationPullPourVoiceOver(
                            titreFiche
                            + ". "
                            + texteFiche
                        )
                    )
                )
                .accessibilityHidden(estEnExercices)
            }

            Text(
                "Texte à taper : "
                + texteAffiche()
            )
            .font(.system(size: 28, weight: .bold))
            .opacity(estEnExercices ? 1 : 0)
            .frame(height: estEnExercices ? nil : 0)
            .accessibilityHidden(!estEnExercices)
            .accessibilityLabel(
                VoiceOverAnnouncer.textePourPrononciation(
                    consigneExerciceVoiceOver
                )
            )
            .accessibilityFocused($consigneExerciceEnFocus)

            KeyboardReadyTextField(
                text: saisieAccessible,
                isEnabled: estEnExercices && !exerciceReussi,
                focusRequest: demandeFocusClavier,
                onModifierFlagsChanged: {
                    programmerAnnonceRestante(
                        pour: texteSaisi
                    )
                },
                onSubmit: {
                    guard estEnExercices,
                          !exerciceReussi else {
                        return
                    }

                    verifierReponse()
                }
            )
            .frame(
                width: 420,
                height: estEnExercices ? 28 : 0
            )
            .opacity(estEnExercices ? 1 : 0)
            .accessibilityHidden(
                !estEnExercices
                || !champSaisieAccessibleVoiceOver
            )
            .accessibilityLabel(
                lesson.id >= 48 && lesson.id <= 53
                ? "Champ de saisie. "
                    + texteAnnonce()
                : "Champ de saisie du texte à taper"
            )
            .accessibilityHint(
                lesson.id >= 48 && lesson.id <= 53
                ? "Saisissez ici le mot demandé."
                : "Saisissez ici le contenu demandé."
            )

            Text(messageResultat.isEmpty ? " " : messageResultat)
                .multilineTextAlignment(.center)
                .accessibilityHidden(messageResultat.isEmpty)
                .accessibilityLabel(messageResultat)

            if !estEnExercices {
                Button(texteBoutonPrincipal) {
                    executerActionPrincipale()
                }
                .keyboardShortcut(.defaultAction)
                .accessibilityHidden(
                    !boutonPrincipalAccessibleVoiceOver
                    || (
                        estEnResume
                        && !boutonFinLeconAccessible
                    )
                )
                .accessibilityFocused($boutonPrincipalEnFocus)
            }
        }
    }

    private var indicateurProgression: String {
        switch phase {
        case .etapes:
            return "Étape "
                + String(indexEtape + 1)
                + " sur "
                + String(lesson.etapes.count)

        case .exercices:
            return "Exercice "
                + String(indexExercice + 1)
                + " sur "
                + String(lesson.exercices.count)

        case .resume:
            return "Leçon terminée"
        }
    }

    private var titreFiche: String {
        switch phase {
        case .etapes:
            return etapeActuelle.titre

        case .exercices:
            return exerciceActuel.instruction

        case .resume:
            return ""
        }
    }

    private var texteFiche: String {
        switch phase {
        case .etapes:
            if indexEtape == lesson.etapes.count - 1 {
                return etapeActuelle.texte
                    + " Pour chaque exercice, saisissez votre réponse "
                    + "dans le champ de texte, puis appuyez sur la touche "
                    + "Entrée pour la valider."
            }

            return etapeActuelle.texte

        case .exercices:
            return "Saisis le texte demandé dans le champ ci-dessous."

        case .resume:
            return lesson.resumeFinal
        }
    }

    private var paragraphesFiche: [String] {
        texteFiche
            .components(separatedBy: "\n")
            .map {
                $0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .filter {
                !$0.isEmpty
            }
    }

    private var texteBoutonPrincipal: String {
        switch phase {
        case .etapes:
            if indexEtape < lesson.etapes.count - 1 {
                return "J’ai compris"
            }

            return "Commencer les exercices"

        case .exercices:
            if exerciceReussi {
                return ""
            }

            return ""

        case .resume:
            return "Terminer la leçon"
        }
    }

    private var saisieAccessible: Binding<String> {
        Binding(
            get: {
                texteSaisi
            },
            set: { nouvelleValeur in
                if debutChronometrage == nil,
                   !nouvelleValeur.isEmpty,
                   lesson.id >= 24 {
                    debutChronometrage = Date()
                }

                texteSaisi = nouvelleValeur
                programmerAnnonceRestante(
                    pour: nouvelleValeur
                )
            }
        )
    }

    private func executerActionPrincipale() {
        switch phase {
        case .etapes:
            passerEtapeSuivante()

        case .exercices:
            if exerciceReussi {
                passerExerciceSuivant()
            } else {
                verifierReponse()
            }

        case .resume:
            terminerLecon()
        }
    }

    private func passerEtapeSuivante() {
        boutonPrincipalEnFocus = false

        if indexEtape < lesson.etapes.count - 1 {
            indexEtape += 1

            let annonceObjectif = objectifPourEtape(
                index: indexEtape,
                inclureIntroduction: false
            )
            if !annonceObjectif.isEmpty {
                objectifDejaAnnonce = true
            }

            VoiceOverAnnouncer.annoncerTexte(
                annonceObjectif
                + titreFiche
                + ". "
                + texteFiche,
                apres: 0.25
            )
        } else {
            phase = .exercices
            boutonFinLeconAccessible = false
            texteSaisi = ""
            debutChronometrage = nil
            messageResultat = ""
            exerciceReussi = false

            annoncerExerciceEtPreparerSaisie(
                inclureTitreLecon: true
            )
        }
    }

    private func texteAffiche() -> String {
        guard estEnExercices else {
            return ""
        }

        switch exerciceActuel.modeLecture {
        case .epeler:
            return exerciceActuel.texteAttendu
                .uppercased()
                .map { String($0) }
                .joined(separator: " ")

        case .lireNaturellement:
            return exerciceActuel.texteAttendu
        }
    }

    private func texteAnnonce() -> String {
        guard estEnExercices else {
            return ""
        }

        switch exerciceActuel.modeLecture {
        case .epeler:
            if lesson.id >= 42 && lesson.id <= 47 {
                return exerciceActuel.texteAttendu.map { caractere in
                    if caractere.isLetter {
                        let nomLettre =
                            descriptionCaractereRestantPourVoiceOver(
                                Character(
                                    String(caractere).lowercased()
                                )
                            )
                        return nomLettre + " majuscule"
                    }

                    return descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                }
                .joined(separator: ", ")
            }

            return descriptionEpelleePourVoiceOver(
                exerciceActuel.texteAttendu
            )

        case .lireNaturellement:
            if prioriserConsigneInitiale {
                return descriptionTextePersonnalisePourVoiceOver(
                    exerciceActuel.texteAttendu
                )
            }

            // Module 14 : priorité au formateur de phrase afin d’annoncer
            // à la fois la majuscule initiale et les signes de ponctuation.
            // Les espaces restent naturels dans « Texte à taper ».
            if lesson.id >= 77 && lesson.id <= 82 {
                return descriptionPhraseModule14PourVoiceOver(
                    exerciceActuel.texteAttendu
                )
            }

            if let descriptionMajuscule =
                descriptionMajusculeInitialeGlobalePourVoiceOver(
                    exerciceActuel.texteAttendu
                ) {
                return descriptionMajuscule
            }

            if lesson.id >= 54 && lesson.id <= 59 {
                return exerciceActuel.texteAttendu
                    .split(separator: " ")
                    .map(String.init)
                    .joined(separator: ", espace, ")
            }

            if lesson.id >= 60 && lesson.id <= 65 {
                return descriptionTexteAccentuePourVoiceOver(
                    exerciceActuel.texteAttendu
                )
            }

            if lesson.id >= 66 && lesson.id <= 71 {
                return descriptionMotAccentueModule12PourVoiceOver(
                    exerciceActuel.texteAttendu
                )
            }

            if lesson.id >= 72 && lesson.id <= 76 {
                return descriptionPonctuationModule13PourVoiceOver(
                    exerciceActuel.texteAttendu
                )
            }

            return descriptionNaturelleAvecEspaces(
                exerciceActuel.texteAttendu
            )
        }
    }

    private func texteAvecPrononciationPullPourVoiceOver(
        _ texte: String
    ) -> String {
        texte
            .replacingOccurrences(
                of: "pull",
                with: "pule",
                options: [.caseInsensitive]
            )
    }

    private func descriptionNaturelleAvecEspaces(
        _ texte: String
    ) -> String {
        let description = texte
            .split(
                separator: " ",
                omittingEmptySubsequences: false
            )
            .map { morceau in
                guard !morceau.isEmpty else {
                    return "espace"
                }

                let mot = String(morceau)

                switch mot.lowercased() {
                case "mer":
                    return "mère"
                case "bus":
                    return "busse"
                case "vénus":
                    return "Vénusse"
                case "pull":
                    return "pule"
                case "basket":
                    return "baskette"
                default:
                    return VoiceOverAnnouncer.descriptionNaturelle(
                        de: mot
                    )
                }
            }
            .joined(separator: ", espace, ")
            .replacingOccurrences(
                of: "espace, espace, espace",
                with: "espace"
            )

        guard let premiereLettre = texte.first,
              premiereLettre.isLetter,
              premiereLettre.isUppercase else {
            return description
        }

        return description
    }

    private func descriptionLettreMajuscule(
        _ caractere: Character
    ) -> String {
        switch caractere {
        case "m", "M":
            return "M majuscule"
        case "l", "L":
            return "L majuscule"
        case "u", "U":
            return "U majuscule"
        case "v", "V":
            return "V majuscule"
        default:
            return String(caractere).uppercased()
                + " majuscule"
        }
    }

    private func descriptionEpelleePourVoiceOver(
        _ texte: String
    ) -> String {
        texte.map { caractere in
            switch caractere {
            case " ":
                return "espace"
            case "\n":
                return "retour à la ligne"
            case ".":
                return "point"
            case ",":
                return "virgule"
            case ";":
                return "point-virgule"
            case ":":
                return "deux-points"
            case "!":
                return "point d’exclamation"
            case "?":
                return "point d’interrogation"
            case "m", "M":
                return "aime"
            case "l", "L":
                return "elle"
            case "u", "U":
                return "la lettre U"
            case "v", "V":
                return "la lettre V"
            default:
                return String(caractere).uppercased()
            }
        }
        .joined(separator: ", ")
    }

    private func nomCaractereAccentuePourVoiceOver(
        _ caractere: Character
    ) -> String? {
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

    private func descriptionTexteAccentuePourVoiceOver(
        _ texte: String
    ) -> String {
        texte.map { caractere in
            if caractere == " " {
                return "espace"
            }

            if let nomAccentue =
                nomCaractereAccentuePourVoiceOver(
                    caractere
                ) {
                return nomAccentue
            }

            return descriptionCaractereRestantPourVoiceOver(
                caractere
            )
        }
        .joined(separator: ", ")
    }

    private func descriptionCaractereRestantPourVoiceOver(
        _ caractere: Character
    ) -> String {
        switch caractere {
        case " ":
            return "espace"
        case "\n":
            return "retour à la ligne"
        case ".":
            return "point"
        case ",":
            return "virgule"
        case ";":
            return "point-virgule"
        case ":":
            return "deux-points"
        case "!":
            return "point d’exclamation"
        case "?":
            return "point d’interrogation"
        case "'":
            return "apostrophe"
        case "-":
            return "trait d’union"
        default:
            break
        }

        guard caractere.isLetter else {
            return String(caractere)
        }

        let lettreMinuscule = String(caractere).lowercased()
        let nomLettre: String

        switch lettreMinuscule {
        case "m":
            nomLettre = "aime"
        case "l":
            nomLettre = "elle"
        case "r":
            nomLettre = "lettre R"
        case "u":
            nomLettre = "la lettre u"
        case "v":
            nomLettre = "la lettre v"
        case "y":
            nomLettre = "i grec"
        default:
            nomLettre = lettreMinuscule
        }

        if caractere.isUppercase {
            return nomLettre + " majuscule"
        }

        return nomLettre
    }

    private func descriptionMajusculeInitialeGlobalePourVoiceOver(
        _ texte: String
    ) -> String? {
        guard let premiereLettre = texte.first,
              premiereLettre.isLetter,
              premiereLettre.isUppercase else {
            return nil
        }

        if let nomAccentue =
            nomCaractereAccentuePourVoiceOver(
                premiereLettre
            ) {
            let reste = String(
                texte.dropFirst()
            )

            if reste.isEmpty {
                return nomAccentue
            }

            let resteNettoye =
                reste.trimmingCharacters(
                    in: .whitespaces
                )

            if resteNettoye.isEmpty {
                return nomAccentue
            }

            return nomAccentue
                + ", "
                + descriptionNaturelleAvecToFrancais(
                    resteNettoye
                )
        }

        let nomMajuscule =
            descriptionCaractereRestantPourVoiceOver(
                premiereLettre
            )

        return nomMajuscule
            + ", "
            + texte
    }

    private func descriptionTexteRestantModule9PourVoiceOver(
        _ texte: String
    ) -> String {
        guard let premiereLettre = texte.first else {
            return texte
        }

        guard premiereLettre.isUppercase else {
            return descriptionNaturelleAvecToFrancais(
                texte
            )
        }

        return descriptionCaractereRestantPourVoiceOver(
            premiereLettre
        )
        + ", "
        + texte
    }

    private func descriptionMotAccentueModule12PourVoiceOver(
        _ texte: String
    ) -> String {
        guard let premiereLettre = texte.first,
              premiereLettre.isUppercase else {
            return texte
        }

        return descriptionCaractereRestantPourVoiceOver(
            premiereLettre
        ) + ", " + texte
    }

    private func descriptionTexteRestantModule12PourVoiceOver(
        _ texte: String
    ) -> String {
        guard let premiereLettre = texte.first else {
            return texte
        }

        guard premiereLettre.isUppercase else {
            return descriptionNaturelleAvecEspaces(
                texte
            )
        }

        let reste = String(
            texte.dropFirst()
        )

        if reste.isEmpty {
            return descriptionCaractereRestantPourVoiceOver(
                premiereLettre
            )
        }

        return descriptionCaractereRestantPourVoiceOver(
            premiereLettre
        )
        + ", "
        + descriptionNaturelleAvecEspaces(
            reste
        )
    }

    private func descriptionPonctuationModule13PourVoiceOver(
        _ texte: String
    ) -> String {
        texte.map { caractere in
            descriptionCaractereRestantPourVoiceOver(
                caractere
            )
        }
        .joined(separator: ", ")
    }

    private func descriptionPhraseModule14PourVoiceOver(
        _ texte: String
    ) -> String {
        var resultat: [String] = []
        var mot = ""

        func ajouterMot() {
            guard !mot.isEmpty else { return }

            if let premiereLettre = mot.first,
               premiereLettre.isLetter,
               premiereLettre.isUppercase {
                resultat.append(
                    nomCaractereAccentuePourVoiceOver(
                        premiereLettre
                    ) ?? descriptionCaractereRestantPourVoiceOver(
                        premiereLettre
                    )
                )
                let reste = String(mot.dropFirst())
                if !reste.isEmpty {
                    resultat.append(
                        premiereLettre.description + reste
                    )
                }
            } else {
                resultat.append(mot)
            }

            mot = ""
        }

        for caractere in texte {
            switch caractere {
            case " ":
                ajouterMot()
                // Dans « Texte à taper », l’espace reste une séparation
                // naturelle entre les mots et n’est pas annoncé.
            case ".", ",", ";", ":", "!", "?":
                ajouterMot()
                resultat.append(
                    descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                )
            default:
                // Apostrophes and hyphens remain naturally integrated
                // into words in "Texte à taper".
                mot.append(caractere)
            }
        }

        ajouterMot()
        return resultat.joined(separator: ", ")
    }

    private func descriptionTextePersonnalisePourVoiceOver(
        _ texte: String
    ) -> String {
        var resultat: [String] = []
        var mot = ""

        func ajouterMot() {
            guard !mot.isEmpty else { return }

            let accents = mot.compactMap {
                nomCaractereAccentuePourVoiceOver($0)
            }

            if mot.count == 1, let caractere = mot.first {
                resultat.append(
                    accents.first
                    ?? descriptionCaractereRestantPourVoiceOver(caractere)
                )
            } else {
                if let premiereLettre = mot.first,
                   premiereLettre.isUppercase {
                    resultat.append(
                        nomCaractereAccentuePourVoiceOver(premiereLettre)
                        ?? descriptionCaractereRestantPourVoiceOver(premiereLettre)
                    )
                }
                resultat.append(mot)
                resultat.append(contentsOf: accents)
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
            case ".", ",", ";", ":", "!", "?":
                ajouterMot()
                resultat.append(
                    descriptionCaractereRestantPourVoiceOver(caractere)
                )
            case "-":
                ajouterMot()
                resultat.append("trait d’union")
            case "«":
                ajouterMot()
                resultat.append("guillemet ouvrant")
            case "»":
                ajouterMot()
                resultat.append("guillemet fermant")
            case "\"":
                ajouterMot()
                resultat.append("guillemet")
            default:
                mot.append(caractere)
            }
        }

        ajouterMot()
        return resultat.joined(separator: ", ")
    }

    private func descriptionTexteRestantModule14PourVoiceOver(
        _ texte: String
    ) -> String {
        var resultat: [String] = []
        var mot = ""

        func ajouterMot() {
            guard !mot.isEmpty else { return }

            // Un Y isolé dans une phrase (par exemple « Ça y est »)
            // doit être annoncé comme la lettre Y / i grec et non
            // interprété phonétiquement comme le son « i ».
            if mot.count == 1,
               let caractere = mot.first,
               String(caractere).lowercased() == "y" {
                resultat.append(
                    descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                )
                mot = ""
                return
            }

            // Quand le fragment restant est exactement « nt »,
            // VoiceOver peut l’interpréter comme une abréviation.
            // On l’épelle donc explicitement.
            if mot.lowercased() == "nt" {
                resultat.append("N")
                resultat.append("T")
                mot = ""
                return
            }

            if mot.count == 1,
               let caractere = mot.first,
               nomCaractereAccentuePourVoiceOver(
                    caractere
               ) != nil {
                resultat.append(
                    nomCaractereAccentuePourVoiceOver(
                        caractere
                    ) ?? descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                )
            } else if let premiereLettre = mot.first,
                      premiereLettre.isLetter,
                      premiereLettre.isUppercase {
                resultat.append(
                    nomCaractereAccentuePourVoiceOver(
                        premiereLettre
                    ) ?? descriptionCaractereRestantPourVoiceOver(
                        premiereLettre
                    )
                )
                let reste = String(mot.dropFirst())
                if !reste.isEmpty {
                    resultat.append(
                        premiereLettre.description + reste
                    )
                }
            } else {
                resultat.append(mot)
            }

            mot = ""
        }

        for caractere in texte {
            switch caractere {
            case " ":
                ajouterMot()
                resultat.append("espace")
            case ".", ",", ";", ":", "!", "?", "'", "-":
                ajouterMot()
                resultat.append(
                    descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                )
            default:
                mot.append(caractere)
            }
        }

        ajouterMot()
        return resultat.joined(separator: ", ")
    }

    private func descriptionNaturelleAvecToFrancais(
        _ texte: String
    ) -> String {
        let morceaux = texte.split(
            separator: " ",
            omittingEmptySubsequences: false
        )

        guard !morceaux.isEmpty else {
            return descriptionNaturelleAvecEspaces(
                texte
            )
        }

        return morceaux.enumerated().map { index, morceau in
            if morceau.isEmpty {
                return "espace"
            }

            let mot = String(morceau)
            let motMinuscule = mot.lowercased()

            if motMinuscule == "pull" {
                return "pule"
            }

            if motMinuscule == "ak" {
                return "aque"
            }

            if motMinuscule == "gby" {
                return "gue bi"
            }

            if motMinuscule == "by" {
                return "B, i grec"
            }

            if motMinuscule == "basket" {
                return "baskette"
            }

            if motMinuscule == "asket" {
                return "askette"
            }

            if motMinuscule == "sket" {
                return "skette"
            }

            if motMinuscule == "ket" {
                return "kette"
            }

            if motMinuscule == "space" {
                return "spasse"
            }

            if motMinuscule == "pace" {
                return "passe"
            }

            if motMinuscule == "lite" {
                return "litte"
            }

            if motMinuscule == "bite" {
                return "bitte"
            }

            if index == 0 {
                if motMinuscule == "to" {
                    return "tôt"
                }

                if motMinuscule == "yo-yo" {
                    return "yoyo"
                }

                if motMinuscule == "o-yo" {
                    // Forme uniquement phonétique pour VoiceOver :
                    // le H reste muet et évite l’épellation O, Y, O.
                    return "hoyo"
                }
            }

            return VoiceOverAnnouncer.descriptionNaturelle(
                de: mot
            )
        }
        .joined(separator: ", espace, ")
        .replacingOccurrences(
            of: "espace, espace, espace",
            with: "espace"
        )
    }

    private func descriptionTexteRestantModule10(
        _ texte: String
    ) -> String {
        let morceaux = texte.split(
            separator: " ",
            omittingEmptySubsequences: false
        )

        return morceaux.map { morceau in
            guard !morceau.isEmpty else {
                return "espace"
            }

            let mot = String(morceau)

            guard let premiereLettre = mot.first,
                  premiereLettre.isLetter,
                  premiereLettre.isUppercase else {
                return mot
            }

            return descriptionCaractereRestantPourVoiceOver(
                premiereLettre
            )
            + ". "
            + mot
        }
        .joined(separator: ", espace, ")
        .replacingOccurrences(
            of: "espace, espace, espace",
            with: "espace"
        )
    }

    private func placerFocusInitial() {
        titreLeconEnFocus = false
        consigneExerciceEnFocus = false
        boutonPrincipalEnFocus = false
        resumeEnFocus = false
        champSaisieAccessibleVoiceOver = false
        boutonPrincipalAccessibleVoiceOver = false

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.45
        ) {
            titreLeconEnFocus = true
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.75
        ) {
            boutonPrincipalAccessibleVoiceOver = true
        }
    }

    private func programmerAnnonceRestante(
        pour valeur: String
    ) {
        guard estEnExercices,
              reglages.annoncerTexteRestant else {
            return
        }

        let valeurCapturee = valeur
        let exerciceCapture = indexExercice

        DispatchQueue.main.asyncAfter(
            deadline: .now() + reglages.delaiAnnonce
        ) {
            guard phase == .exercices,
                  indexExercice == exerciceCapture,
                  texteSaisi == valeurCapturee else {
                return
            }

            annoncerReste()
        }
    }

    private func annoncerReste() {
        let attendu = exerciceActuel.texteAttendu

        if texteSaisi.count >= attendu.count {
            VoiceOverAnnouncer.annoncerTexteRestant(
                "Texte complet."
            )
            return
        }

        let nombreCaracteres = min(
            texteSaisi.count,
            attendu.count
        )

        let index = attendu.index(
            attendu.startIndex,
            offsetBy: nombreCaracteres
        )

        let reste = String(attendu[index...])

        // Règle globale : lorsqu’un mot se termine par « nt » et que
        // ces deux caractères sont exactement ce qu’il reste à taper,
        // VoiceOver les épelle simplement : N, T.
        if reste.lowercased() == "nt" {
            VoiceOverAnnouncer.annoncerTexteRestant(
                "N, T"
            )
            return
        }

        switch exerciceActuel.modeLecture {
        case .epeler:
            VoiceOverAnnouncer.annoncerTexteRestant(
                reste.map { caractere in
                    if lesson.id >= 42 && lesson.id <= 47,
                       caractere.isLetter {
                        let nomLettre =
                            descriptionCaractereRestantPourVoiceOver(
                                Character(
                                    String(caractere).lowercased()
                                )
                            )
                        return nomLettre + " majuscule"
                    }

                    return descriptionCaractereRestantPourVoiceOver(
                        caractere
                    )
                }
                .joined(separator: ", ")
            )

        case .lireNaturellement:
            let restePourVoiceOver: String

            if prioriserConsigneInitiale {
                VoiceOverAnnouncer.annoncerTexteRestant(
                    descriptionTextePersonnalisePourVoiceOver(reste)
                )
                return
            }

            if let descriptionMajuscule =
                descriptionMajusculeInitialeGlobalePourVoiceOver(
                    reste
                ) {
                VoiceOverAnnouncer.annoncerTexteRestant(
                    descriptionMajuscule
                )
                return
            }

            let premierMorceauRestant =
                reste.split(
                    separator: " ",
                    omittingEmptySubsequences: false
                )
                .first
                .map(String.init)?
                .lowercased() ?? ""

            if premierMorceauRestant == "to"
                || premierMorceauRestant == "yo-yo"
                || premierMorceauRestant == "o-yo"
                || premierMorceauRestant == "ak"
                || premierMorceauRestant == "gby"
                || premierMorceauRestant == "by"
                || premierMorceauRestant == "basket"
                || premierMorceauRestant == "asket"
                || premierMorceauRestant == "sket"
                || premierMorceauRestant == "ket"
                || premierMorceauRestant == "space"
                || premierMorceauRestant == "pace"
                || premierMorceauRestant == "lite"
                || premierMorceauRestant == "bite" {
                restePourVoiceOver =
                    descriptionNaturelleAvecToFrancais(
                        reste
                    )
            } else if lesson.id >= 54 && lesson.id <= 59 {
                restePourVoiceOver =
                    descriptionTexteRestantModule10(
                        reste
                    )
            } else if lesson.id >= 60 && lesson.id <= 65 {
                restePourVoiceOver =
                    descriptionTexteAccentuePourVoiceOver(
                        reste
                    )
            } else if lesson.id >= 66 && lesson.id <= 71 {
                restePourVoiceOver =
                    descriptionTexteRestantModule12PourVoiceOver(
                        reste
                    )
            } else if lesson.id >= 72 && lesson.id <= 76 {
                restePourVoiceOver =
                    descriptionPonctuationModule13PourVoiceOver(
                        reste
                    )
            } else if lesson.id >= 77 && lesson.id <= 82 {
                restePourVoiceOver =
                    descriptionTexteRestantModule14PourVoiceOver(
                        reste
                    )
            } else {
                restePourVoiceOver =
                    descriptionNaturelleAvecToFrancais(
                        reste
                    )
            }

            VoiceOverAnnouncer.annoncerTexteRestant(
                restePourVoiceOver
            )
        }
    }

    private func verifierReponse() {
        let reponse: String
        let texteAttendu: String

        if prioriserConsigneInitiale {
            reponse = normaliserTextePersonnalisePourValidation(texteSaisi)
            texteAttendu = normaliserTextePersonnalisePourValidation(
                exerciceActuel.texteAttendu
            )
        } else {
            reponse = texteSaisi.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            texteAttendu = exerciceActuel.texteAttendu
        }

        let reponseCorrecte: Bool

        if lesson.id >= 42 {
            // À partir du module 8, la casse fait partie de l’exercice.
            // Une minuscule ne peut donc pas valider une majuscule attendue.
            reponseCorrecte = reponse == texteAttendu
        } else {
            reponseCorrecte =
                reponse.lowercased()
                == texteAttendu.lowercased()
        }

        enregistrerStatistiqueTentative(
            saisie: texteSaisi,
            attendu: exerciceActuel.texteAttendu,
            reussie: reponseCorrecte
        )

        if reponseCorrecte {

            exerciceReussi = true
            messageResultat = ""
            jouerSonValidation(reussi: true)
            enregistrerVitesseExerciceSiNecessaire()

            if indexExercice < lesson.exercices.count - 1 {
                passerExerciceSuivant()
            } else if lesson.resumeFinal.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty {
                terminerLecon()
            } else {
                afficherResumeFinal()
            }
        } else {
            exerciceReussi = false
            texteSaisi = ""
            messageResultat = ""
            jouerSonValidation(reussi: false)

            // Aucune annonce supplémentaire : le champ est vidé
            // et reste immédiatement prêt pour une nouvelle saisie.
            placerFocusSurChampSaisie(
                apres: 0.05
            )
        }
    }

    private func enregistrerStatistiqueTentative(
        saisie: String,
        attendu: String,
        reussie: Bool
    ) {
        guard let apprenant = ProgressionManager.shared.utilisateurActif else {
            return
        }
        StatistiquesErreursManager.shared.enregistrerTentative(
            apprenant: apprenant,
            lesson: lesson,
            exerciceNumero: indexExercice + 1,
            saisie: saisie,
            attendu: attendu,
            reussie: reussie
        )
    }

    private func normaliserTextePersonnalisePourValidation(
        _ texte: String
    ) -> String {
        texte
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "ʼ", with: "'")
            .replacingOccurrences(of: "\u{00A0}", with: " ")
    }

    private func enregistrerVitesseExerciceSiNecessaire() {
        guard lesson.id >= 24,
              let debut = debutChronometrage else {
            debutChronometrage = nil
            return
        }

        let duree = Date().timeIntervalSince(debut)

        ProgressionManager.shared.enregistrerVitesse(
            caracteresValides:
                exerciceActuel.texteAttendu.count,
            duree: duree
        )

        debutChronometrage = nil
    }

    private func jouerSonValidation(reussi: Bool) {
        guard reglages.sonsExercicesActifs else {
            return
        }

        let nomFichier = reussi ? "BonneReponse" : "MauvaiseReponse"

        guard let url = Bundle.main.url(
            forResource: nomFichier,
            withExtension: "wav"
        ),
        let son = NSSound(contentsOf: url, byReference: false) else {
            NSSound.beep()
            return
        }

        son.stop()
        son.play()
    }

    private func afficherResumeFinal() {
        // À la fin uniquement, retirer proprement le focus clavier
        // du champ avant de le faire disparaître. Cela évite que
        // VoiceOver annonce ou épelle son libellé pendant la transition.
        NSApp.keyWindow?.makeFirstResponder(nil)

        champSaisieAccessibleVoiceOver = false
        consigneExerciceEnFocus = false
        boutonPrincipalEnFocus = false
        resumeEnFocus = false
        boutonFinLeconAccessible = false

        phase = .resume
        messageResultat = ""
        texteSaisi = ""
        boutonPrincipalAccessibleVoiceOver = true

        let annonceResume =
            "Résumé de la leçon. "
            + lesson.resumeFinal
            + " Appuyez sur la touche Entrée pour terminer la leçon."

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            guard phase == .resume else { return }
            resumeEnFocus = true
        }

        let delaiBouton =
            0.45
            + dureeSecuriseeDeLecture(
                pour: annonceResume
            )

        DispatchQueue.main.asyncAfter(
            deadline: .now() + delaiBouton
        ) {
            guard phase == .resume else {
                return
            }

            boutonFinLeconAccessible = true
        }
    }

    private func passerExerciceSuivant() {
        guard indexExercice < lesson.exercices.count - 1 else {
            return
        }

        boutonPrincipalEnFocus = false
        indexExercice += 1
        texteSaisi = ""
        debutChronometrage = nil
        messageResultat = ""
        exerciceReussi = false

        annoncerExerciceEtPreparerSaisie(
            inclureTitreLecon: false
        )
    }


    private var consigneExerciceVoiceOver: String {
        guard estEnExercices else {
            return ""
        }

        let consigne = "Exercice "
            + String(indexExercice + 1)
            + " sur "
            + String(lesson.exercices.count)
            + ". "
            + texteAvecPrononciationPullPourVoiceOver(
                exerciceActuel.instruction
            )
            + ". Texte à taper : "
            + texteAnnonce()

        if inclureTitreDansConsigne {
            let introduction = lesson.etapes.isEmpty
                && !lesson.introduction.isEmpty
                ? lesson.introduction + " "
                : ""
            let objectif = objectifDejaAnnonce
                ? ""
                : lesson.objectifPedagogique.map {
                    $0.descriptionPourApprenant + " "
                } ?? ""
            return lesson.titre + ". " + objectif + introduction + consigne
        }

        return consigne
    }

    private func objectifPourEtape(
        index: Int,
        inclureIntroduction: Bool
    ) -> String {
        guard let objectif = lesson.objectifPedagogique,
              !objectifDejaAnnonce else {
            return ""
        }

        let indexFicheObjectif = lesson.etapes.firstIndex { etape in
            etape.titre.range(
                of: "objectif",
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }

        if let indexFicheObjectif {
            return index == indexFicheObjectif
                ? objectif.descriptionPourApprenant + " "
                : ""
        }

        if inclureIntroduction,
           !lesson.introduction.trimmingCharacters(
                in: .whitespacesAndNewlines
           ).isEmpty {
            return objectif.descriptionPourApprenant + " "
        }

        if index == 0 {
            return objectif.descriptionPourApprenant + " "
        }

        return ""
    }

    private func annoncerExerciceEtPreparerSaisie(
        inclureTitreLecon: Bool
    ) {
        consigneExerciceEnFocus = false
        boutonPrincipalEnFocus = false
        resumeEnFocus = false
        // Le champ de saisie des leçons personnalisées suit désormais la
        // même règle d’accessibilité que celui des 14 modules : il est
        // disponible pour VoiceOver dès le début de l’exercice.
        champSaisieAccessibleVoiceOver = true

        inclureTitreDansConsigne = inclureTitreLecon
        let exerciceCapture = indexExercice

        // Le champ reçoit le focus clavier sans demander
        // le focus VoiceOver. Le curseur VoiceOver reste donc
        // libre de lire la consigne visible.
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.05
        ) {
            guard phase == .exercices,
                  indexExercice == exerciceCapture,
                  !exerciceReussi else {
                return
            }

            demandeFocusClavier += 1
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            guard phase == .exercices,
                  indexExercice == exerciceCapture,
                  !exerciceReussi else {
                return
            }

            consigneExerciceEnFocus = true
            inclureTitreDansConsigne = false
        }

    }

    private func dureeSecuriseeDeLecture(
        pour annonce: String
    ) -> TimeInterval {
        let mots = annonce.split { caractere in
            caractere.isWhitespace
        }.count

        let separateursEpellation = annonce.filter { caractere in
            caractere == "," || caractere == ";"
        }.count

        let ponctuation = annonce.filter { caractere in
            caractere == "."
                || caractere == ":"
                || caractere == "!"
                || caractere == "?"
        }.count

        let dureeMots = Double(mots) * 0.48
        let dureeEpellation = Double(separateursEpellation) * 0.42
        let dureePonctuation = Double(ponctuation) * 0.22
        let dureeCaracteres = Double(annonce.count) * 0.012

        let dureeAvecMarge = dureeMots
            + dureeEpellation
            + dureePonctuation
            + dureeCaracteres
            + 2.2

        return min(
            max(dureeAvecMarge, 5.0),
            30.0
        )
    }

    private func placerFocusSurChampSaisie(
        apres delai: TimeInterval
    ) {
        consigneExerciceEnFocus = false
        boutonPrincipalEnFocus = false
        resumeEnFocus = false
        champSaisieAccessibleVoiceOver = true

        DispatchQueue.main.asyncAfter(
            deadline: .now() + delai
        ) {
            guard phase == .exercices,
                  !exerciceReussi else {
                return
            }

            demandeFocusClavier += 1
        }
    }

    private func terminerLecon() {
        if enregistrerProgression {
            ProgressionManager.shared.terminerChapitre(
                lesson.id
            )
        }

        VoiceOverAnnouncer.annoncerTexte(
            "Leçon terminée. Retour au menu des leçons."
        )

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.2
        ) {
            retourMenuChapitres()
        }
    }
}

private struct KeyboardReadyTextField: NSViewRepresentable {

    @Binding var text: String
    let isEnabled: Bool
    let focusRequest: Int
    let onModifierFlagsChanged: () -> Void
    let onSubmit: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            onModifierFlagsChanged: onModifierFlagsChanged,
            onSubmit: onSubmit
        )
    }

    func makeNSView(
        context: Context
    ) -> NSTextField {
        let textField = NSTextField(string: text)
        textField.delegate = context.coordinator
        textField.isEditable = true
        textField.isSelectable = true
        textField.isBordered = true
        textField.bezelStyle = .roundedBezel
        textField.focusRingType = .default
        textField.setAccessibilityLabel(
            "Champ de saisie du texte à taper"
        )
        textField.setAccessibilityHelp(
            "Saisissez ici le contenu demandé."
        )
        context.coordinator.installerSurveillanceVerrouillageMajuscule()
        return textField
    }

    func updateNSView(
        _ textField: NSTextField,
        context: Context
    ) {
        context.coordinator.text = $text
        context.coordinator.onModifierFlagsChanged =
            onModifierFlagsChanged
        context.coordinator.onSubmit = onSubmit

        if textField.stringValue != text {
            textField.stringValue = text
        }

        textField.isEnabled = isEnabled
        textField.isEditable = isEnabled

        guard isEnabled,
              context.coordinator.lastFocusRequest != focusRequest else {
            return
        }

        context.coordinator.lastFocusRequest = focusRequest

        DispatchQueue.main.async {
            guard textField.window != nil else { return }
            textField.window?.makeFirstResponder(textField)
        }
    }

    final class Coordinator: NSObject, NSTextFieldDelegate {
        var text: Binding<String>
        var onModifierFlagsChanged: () -> Void
        var onSubmit: () -> Void
        var lastFocusRequest = -1
        private var moniteurModificateurs: Any?
        private var etatVerrouillageMajuscule =
            NSEvent.modifierFlags.contains(.capsLock)

        init(
            text: Binding<String>,
            onModifierFlagsChanged: @escaping () -> Void,
            onSubmit: @escaping () -> Void
        ) {
            self.text = text
            self.onModifierFlagsChanged = onModifierFlagsChanged
            self.onSubmit = onSubmit
        }

        deinit {
            if let moniteurModificateurs {
                NSEvent.removeMonitor(
                    moniteurModificateurs
                )
            }
        }

        func installerSurveillanceVerrouillageMajuscule() {
            guard moniteurModificateurs == nil else {
                return
            }

            moniteurModificateurs =
                NSEvent.addLocalMonitorForEvents(
                    matching: .flagsChanged
                ) { [weak self] evenement in
                    guard let self else {
                        return evenement
                    }

                    let nouvelEtat =
                        evenement.modifierFlags.contains(
                            .capsLock
                        )

                    if nouvelEtat !=
                        self.etatVerrouillageMajuscule {
                        self.etatVerrouillageMajuscule =
                            nouvelEtat

                        DispatchQueue.main.async {
                            self.onModifierFlagsChanged()
                        }
                    }

                    return evenement
                }
        }

        func controlTextDidChange(
            _ notification: Notification
        ) {
            guard let textField = notification.object
                    as? NSTextField else {
                return
            }

            text.wrappedValue = textField.stringValue
        }

        func control(
            _ control: NSControl,
            textView: NSTextView,
            doCommandBy commandSelector: Selector
        ) -> Bool {
            guard commandSelector == #selector(
                NSResponder.insertNewline(_:)
            ) else {
                return false
            }

            onSubmit()
            return true
        }
    }
}
