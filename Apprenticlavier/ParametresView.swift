//
//  ParametresView.swift
//  Apprenti Clavier
//
//  Réglages d’accessibilité, de progression et de profil.
//

import SwiftUI
import AppKit

struct ParametresView: View {

    private enum ElementAccessible: Hashable {
        case titre
        case confirmation
    }

    private enum EnteteReglages: Hashable {
        case titre
        case apparence
        case accessibilite
        case sonsValidationExercices
        case modificationCodePIN
        case progression
        case suppression
    }

    @Namespace private var espaceEntetesReglages

    private enum AlerteActive {
        case aucune
        case reinitialisation
        case suppression
    }

    private let retourMenuPrincipal: (() -> Void)?

    @ObservedObject private var reglages =
        AppSettings.shared

    @ObservedObject private var progression =
        ProgressionManager.shared

    @ObservedObject private var formateurs =
        FormateurManager.shared

    @AppStorage("apparenceApplication")
    private var apparenceApplication = "automatique"

    @State private var alerteActive:
        AlerteActive = .aucune

    @State private var messageConfirmation = ""

    @State private var moniteurClavier: Any?

    @State private var contexteModificationPIN: ContexteCodePIN?

    @AccessibilityFocusState
    private var focusVoiceOver: ElementAccessible?

    init(
        retourMenuPrincipal: (() -> Void)? = nil
    ) {
        self.retourMenuPrincipal = retourMenuPrincipal
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                Text("Réglages")
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityRotorEntry(id: EnteteReglages.titre, in: espaceEntetesReglages)
                    .accessibilityFocused(
                        $focusVoiceOver,
                        equals: .titre
                    )

                if let formateur = formateurs.formateurActif {
                    GroupBox("Formateur actuel") {
                        Text(formateur)
                            .font(.title2)
                            .padding(.vertical, 8)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Formateur actuel, \(formateur)")
                } else if let utilisateur = progression.utilisateurActif {
                    GroupBox("Utilisateur actuel") {
                        Text(utilisateur)
                            .font(.title2)
                            .padding(.vertical, 8)
                    }
                    .accessibilityElement(
                        children: .combine
                    )
                    .accessibilityLabel(
                        "Utilisateur actuel, \(utilisateur)"
                    )
                } else {
                    GroupBox("Utilisateur actuel") {
                        Text("Aucun utilisateur sélectionné")
                            .padding(.vertical, 8)
                    }
                    .accessibilityElement(
                        children: .combine
                    )
                }

                GroupBox {
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        Text("Choisissez l’apparence de l’application")
                            .font(.title2)
                            .accessibilityRemoveTraits(.isHeader)

                        Button {
                            selectionnerApparence(
                                "automatique"
                            )
                        } label: {
                            Label(
                                "Automatique",
                                systemImage:
                                    apparenceApplication == "automatique"
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            apparenceApplication == "automatique"
                            ? "Automatique, sélectionné"
                            : "Automatique"
                        )
                        .accessibilityHint(
                            "Suit automatiquement l’apparence choisie dans macOS."
                        )

                        Button {
                            selectionnerApparence(
                                "clair"
                            )
                        } label: {
                            Label(
                                "Clair",
                                systemImage:
                                    apparenceApplication == "clair"
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            apparenceApplication == "clair"
                            ? "Clair, sélectionné"
                            : "Clair"
                        )
                        .accessibilityHint(
                            "Utilise toujours l’apparence claire."
                        )

                        Button {
                            selectionnerApparence(
                                "sombre"
                            )
                        } label: {
                            Label(
                                "Sombre",
                                systemImage:
                                    apparenceApplication == "sombre"
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            apparenceApplication == "sombre"
                            ? "Sombre, sélectionné"
                            : "Sombre"
                        )
                        .accessibilityHint(
                            "Utilise toujours l’apparence sombre."
                        )

                        Text(
                            "Choisissez une apparence automatique, claire ou sombre."
                        )
                    }
                    .padding(.vertical, 8)
                } label: {
                    Text("Apparence")
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(id: EnteteReglages.apparence, in: espaceEntetesReglages)
                }

                GroupBox {
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        Toggle(
                            "Annoncer automatiquement le texte restant à taper",
                            isOn: $reglages.annoncerTexteRestant
                        )
                        .toggleStyle(.checkbox)
                        .accessibilityHint(
                            "Active ou désactive les annonces automatiques "
                            + "du texte restant pendant la frappe."
                        )

                        Text(
                            "Annonce automatiquement ce qu’il reste à taper pendant les exercices."
                        )

                        Divider()

                        Text("Délai des annonces VoiceOver")
                            .font(.title2)
                            .accessibilityRemoveTraits(.isHeader)

                        Button {
                            selectionnerDelaiAnnonce(0.25)
                        } label: {
                            Label(
                                "Très rapide, un quart de seconde",
                                systemImage:
                                    reglages.delaiAnnonce == 0.25
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            reglages.delaiAnnonce == 0.25
                            ? "Très rapide, un quart de seconde, sélectionné"
                            : "Très rapide, un quart de seconde"
                        )
                        .disabled(
                            !reglages.annoncerTexteRestant
                        )

                        Button {
                            selectionnerDelaiAnnonce(0.5)
                        } label: {
                            Label(
                                "Rapide, une demi-seconde",
                                systemImage:
                                    reglages.delaiAnnonce == 0.5
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            reglages.delaiAnnonce == 0.5
                            ? "Rapide, une demi-seconde, sélectionné"
                            : "Rapide, une demi-seconde"
                        )
                        .disabled(
                            !reglages.annoncerTexteRestant
                        )

                        Button {
                            selectionnerDelaiAnnonce(1.0)
                        } label: {
                            Label(
                                "Normal, une seconde",
                                systemImage:
                                    reglages.delaiAnnonce == 1.0
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            reglages.delaiAnnonce == 1.0
                            ? "Normal, une seconde, sélectionné"
                            : "Normal, une seconde"
                        )
                        .disabled(
                            !reglages.annoncerTexteRestant
                        )

                        Button {
                            selectionnerDelaiAnnonce(1.5)
                        } label: {
                            Label(
                                "Confortable, une seconde et demie",
                                systemImage:
                                    reglages.delaiAnnonce == 1.5
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            reglages.delaiAnnonce == 1.5
                            ? "Confortable, une seconde et demie, sélectionné"
                            : "Confortable, une seconde et demie"
                        )
                        .disabled(
                            !reglages.annoncerTexteRestant
                        )

                        Button {
                            selectionnerDelaiAnnonce(2.0)
                        } label: {
                            Label(
                                "Lent, deux secondes",
                                systemImage:
                                    reglages.delaiAnnonce == 2.0
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .accessibilityLabel(
                            reglages.delaiAnnonce == 2.0
                            ? "Lent, deux secondes, sélectionné"
                            : "Lent, deux secondes"
                        )
                        .disabled(
                            !reglages.annoncerTexteRestant
                        )

                        Text(
                            "Choisissez le temps d’attente avant l’annonce VoiceOver."
                        )
                    }
                    .padding(.vertical, 8)
                } label: {
                    Text("Accessibilité VoiceOver")
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(id: EnteteReglages.accessibilite, in: espaceEntetesReglages)
                }

                GroupBox {
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {

                        Toggle(
                            "Sons de validation",
                            isOn: $reglages.sonsExercicesActifs
                        )
                        .toggleStyle(.checkbox)
                        .accessibilityHint(
                            "Active ou désactive les sons de bonne et de mauvaise réponse pendant les exercices."
                        )

                        Text(
                            "Joue un son après une bonne ou une mauvaise réponse."
                        )
                    }
                    .padding(.vertical, 8)
                } label: {
                    Text("Sons de validation des exercices")
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(id: EnteteReglages.sonsValidationExercices, in: espaceEntetesReglages)
                }

                if let formateur = formateurs.formateurActif {
                    GroupBox {
                        VStack(
                            alignment: .leading,
                            spacing: 16
                        ) {
                            Text(
                                "Choisissez un nouveau code PIN pour remplacer celui que vous utilisez actuellement."
                            )

                            Button("Modifier mon code PIN…") {
                                contexteModificationPIN = ContexteCodePIN(
                                    nomFormateur: formateur,
                                    mode: .modification
                                )
                            }
                            .accessibilityLabel("Modifier le code PIN")
                            .accessibilityHint(
                                "Permet de choisir un nouveau code PIN à quatre chiffres."
                            )
                        }
                        .padding(.vertical, 8)
                    } label: {
                        Text("Modification du code PIN")
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityRotorEntry(id: EnteteReglages.modificationCodePIN, in: espaceEntetesReglages)
                    }
                }

                if formateurs.formateurActif == nil {
                    GroupBox {
                        VStack(
                            alignment: .leading,
                            spacing: 16
                        ) {
                            Text(
                                "Consultez ou réinitialisez la progression de l’utilisateur actuel."
                            )

                            Text(texteProgression)

                            Button(
                                "Réinitialiser ma progression…",
                                role: .destructive
                            ) {
                                alerteActive =
                                    .reinitialisation
                            }
                            .disabled(
                                progression.utilisateurActif == nil
                            )
                            .accessibilityHint(
                                "Efface toutes les leçons terminées "
                                + "pour l’utilisateur actuel."
                            )
                        }
                        .padding(.vertical, 8)
                    } label: {
                        Text("Progression")
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityRotorEntry(id: EnteteReglages.progression, in: espaceEntetesReglages)
                    }

                }

                GroupBox {
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        Text(texteSectionSuppression)

                        Button(
                            "Supprimer ce profil…",
                            role: .destructive
                        ) {
                            alerteActive = .suppression
                        }
                        .disabled(profilActuel == nil)
                        .accessibilityHint(texteIndiceSuppression)
                    }
                    .padding(.vertical, 8)
                } label: {
                    Text(titreSectionSuppression)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(id: EnteteReglages.suppression, in: espaceEntetesReglages)
                }

                if !messageConfirmation.isEmpty {
                    Text(messageConfirmation)
                        .accessibilityLabel(
                            messageConfirmation
                        )
                        .accessibilityFocused(
                            $focusVoiceOver,
                            equals: .confirmation
                        )
                }

                if let retourMenuPrincipal {
                    Divider()

                    Button("Retour au menu principal") {
                        retourMenuPrincipal()
                    }
                }
            }
            .padding(40)
            .frame(
                minWidth: 650,
                minHeight: 610,
                alignment: .topLeading
            )
        }
        .alert(
            titreAlerte,
            isPresented: alerteEstPresentee
        ) {
            Button(
                "Annuler",
                role: .cancel
            ) {
                alerteActive = .aucune
            }

            Button(
                libelleBoutonConfirmation,
                role: .destructive
            ) {
                confirmerAlerte()
            }
        } message: {
            Text(messageAlerte)
        }
        .accessibilityRotor("En-têtes Réglages") {
            AccessibilityRotorEntry("Réglages", id: EnteteReglages.titre, in: espaceEntetesReglages)
            AccessibilityRotorEntry("Apparence", id: EnteteReglages.apparence, in: espaceEntetesReglages)
            AccessibilityRotorEntry("Accessibilité VoiceOver", id: EnteteReglages.accessibilite, in: espaceEntetesReglages)
            AccessibilityRotorEntry("Sons de validation des exercices", id: EnteteReglages.sonsValidationExercices, in: espaceEntetesReglages)
            if formateurs.formateurActif != nil {
                AccessibilityRotorEntry("Modification du code PIN", id: EnteteReglages.modificationCodePIN, in: espaceEntetesReglages)
            }
            if formateurs.formateurActif == nil {
                AccessibilityRotorEntry("Progression", id: EnteteReglages.progression, in: espaceEntetesReglages)
            }
            AccessibilityRotorEntry(Text(titreSectionSuppression), id: EnteteReglages.suppression, in: espaceEntetesReglages)
        }
        .sheet(item: $contexteModificationPIN) { contexte in
            CodePINFormateurView(
                contexte: contexte,
                terminer: {
                    contexteModificationPIN = nil
                    messageConfirmation = "Code PIN modifié."
                    annoncerConfirmation()
                },
                annuler: {
                    contexteModificationPIN = nil
                }
            )
        }
        .onAppear {
            messageConfirmation = ""
            alerteActive = .aucune
            focusVoiceOver = nil

            installerMoniteurClavier()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.9
            ) {
                focusVoiceOver = .titre
            }
        }
        .onDisappear {
            messageConfirmation = ""
            alerteActive = .aucune
            retirerMoniteurClavier()
        }
        .onReceive(
            progression.$utilisateurActif
        ) { _ in
            messageConfirmation = ""
            alerteActive = .aucune
        }
    }

    private var alerteEstPresentee: Binding<Bool> {
        Binding(
            get: {
                alerteActive != .aucune
            },
            set: { nouvelleValeur in
                if !nouvelleValeur {
                    alerteActive = .aucune
                }
            }
        )
    }

    private var titreAlerte: String {
        switch alerteActive {
        case .reinitialisation:
            return "Réinitialiser la progression ?"
        case .suppression:
            return "Supprimer ce profil ?"
        case .aucune:
            return ""
        }
    }

    private var libelleBoutonConfirmation: String {
        switch alerteActive {
        case .reinitialisation:
            return "Réinitialiser"
        case .suppression:
            return "Supprimer"
        case .aucune:
            return "Confirmer"
        }
    }

    private var profilActuel: String? {
        formateurs.formateurActif ?? progression.utilisateurActif
    }

    private var messageAlerte: String {
        guard let profil = profilActuel else {
            return "Aucun profil n’est actuellement sélectionné."
        }

        switch alerteActive {
        case .reinitialisation:
            return
                "Voulez-vous vraiment effacer toute la progression "
                + "de \(profil) ? Cette action est irréversible."

        case .suppression:
            if formateurs.formateurActif != nil {
                return
                    "Voulez-vous vraiment supprimer le profil formateur "
                    + "\(profil) ? Le profil et ses leçons personnalisées "
                    + "seront définitivement effacés."
            }
            return
                "Voulez-vous vraiment supprimer le profil "
                + "\(profil) ? Le profil et toute sa progression "
                + "seront définitivement effacés."

        case .aucune:
            return ""
        }
    }

    private var titreSectionSuppression: String {
        guard let profil = profilActuel else {
            return "Suppression du profil"
        }
        return "Suppression du profil de \(profil)"
    }

    private var texteSectionSuppression: String {
        if formateurs.formateurActif != nil {
            return "Supprime définitivement le profil formateur actuel et ses leçons personnalisées."
        }
        return "Supprime définitivement le profil actuel et toute sa progression."
    }

    private var texteIndiceSuppression: String {
        if formateurs.formateurActif != nil {
            return "Supprime définitivement le profil formateur actuel."
        }
        return "Supprime définitivement l’utilisateur actuel."
    }

    private var texteDelai: String {
        if reglages.delaiAnnonce == 0.25 {
            return "Un quart de seconde"
        }

        if reglages.delaiAnnonce == 0.5 {
            return "Une demi-seconde"
        }

        if reglages.delaiAnnonce == 1.0 {
            return "Une seconde"
        }

        if reglages.delaiAnnonce == 1.5 {
            return "Une seconde et demie"
        }

        return "Deux secondes"
    }

    private var texteProgression: String {
        guard let utilisateur =
            progression.utilisateurActif else {
            return
                "Sélectionnez un utilisateur avant "
                + "de gérer sa progression."
        }

        let nombre =
            progression.nombreLeconsTerminees

        if nombre == 0 {
            return
                "\(utilisateur) n’a encore terminé aucune leçon."
        }

        if nombre == 1 {
            return
                "\(utilisateur) a terminé une leçon."
        }

        return
            "\(utilisateur) a terminé \(nombre) leçons."
    }

    private func installerMoniteurClavier() {
        retirerMoniteurClavier()

        moniteurClavier = NSEvent.addLocalMonitorForEvents(
            matching: .keyDown
        ) { evenement in
            if alerteActive != .aucune {
                return evenement
            }

            if evenement.keyCode == 53 {
                if let retourMenuPrincipal {
                    DispatchQueue.main.async {
                        retourMenuPrincipal()
                    }
                } else {
                    let fenetre = evenement.window

                    DispatchQueue.main.async {
                        fenetre?.performClose(nil)
                    }
                }

                return nil
            }

            let commandeW =
                evenement.modifierFlags.contains(.command)
                && evenement.charactersIgnoringModifiers?
                    .lowercased() == "w"

            if commandeW,
               let retourMenuPrincipal {
                DispatchQueue.main.async {
                    retourMenuPrincipal()
                }

                return nil
            }

            return evenement
        }
    }

    private func retirerMoniteurClavier() {
        if let moniteurClavier {
            NSEvent.removeMonitor(moniteurClavier)
            self.moniteurClavier = nil
        }
    }

    private func selectionnerDelaiAnnonce(
        _ valeur: Double
    ) {
        reglages.delaiAnnonce = valeur
    }

    private func selectionnerApparence(
        _ valeur: String
    ) {
        apparenceApplication = valeur

        GestionnaireApparence.appliquer(
            valeur
        )
    }

    private func confirmerAlerte() {
        switch alerteActive {
        case .reinitialisation:
            progression.reinitialiserProgression()

            messageConfirmation =
                "Progression réinitialisée. "
                + "Vous pouvez recommencer depuis la première leçon."

            annoncerConfirmation()

        case .suppression:
            let nomSupprime: String?
            if formateurs.formateurActif != nil {
                nomSupprime = formateurs.supprimerFormateurActif()
            } else {
                nomSupprime = progression.supprimerUtilisateurActif()
            }

            if let nomSupprime {
                messageConfirmation =
                    "Le profil \(nomSupprime) a été supprimé."

                annoncerConfirmation()
            } else {
                messageConfirmation =
                    "Aucun profil n’a été supprimé."

                annoncerConfirmation()
            }

        case .aucune:
            break
        }

        alerteActive = .aucune
    }

    private func annoncerConfirmation() {
        focusVoiceOver = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            focusVoiceOver = .confirmation
        }
    }

}





