//
//  AccueilView.swift
//  Apprenti Clavier
//

import SwiftUI
import Foundation
import AppKit

struct AccueilView: View {

    private enum ElementAccessible: Hashable {
        case titreApplication, titreCreationApprenant, titreChoixFormateur, titreCreationFormateur
        case titreAccueil
        case description
        case titreApprenants
        case titreProfils
        case profil(String)
        case nouveauNom
        case titreFormateurs
        case formateur(String)
        case nouveauNomFormateur
    }

    private enum ChampClavier: Hashable {
        case nouveauNom
        case nouveauNomFormateur
    }

    @ObservedObject private var progression =
        ProgressionManager.shared
    @ObservedObject private var formateurs =
        FormateurManager.shared

    @State private var nouveauNom = ""
    @State private var nouveauNomFormateur = ""
    @State private var afficherMenuPrincipal = false
    @State private var sequenceAccueilLancee = false
    @State private var messageErreur = ""
    @State private var utilisateurEtaitConnecte = false
    @State private var retourDemandeVersApprenants = false
    @State private var messageErreurFormateur = ""
    @State private var contexteCodePIN: ContexteCodePIN?

    @AppStorage("accueilPresentationVoiceOverV3")
    private var accueilDejaPresente = false

    @AccessibilityFocusState
    private var focusVoiceOver: ElementAccessible?

    @Namespace
    private var espaceEntetesAccueil

    @FocusState
    private var focusClavier: ChampClavier?

    private let descriptionAccueil =
        "Bienvenue dans Apprenti Clavier. "
        + "Cette application vous accompagne pas à pas dans l’apprentissage de la frappe au clavier. "
        + "Grâce à des leçons et des exercices progressifs, vous apprendrez à positionner vos doigts, "
        + "à repérer les différentes touches et à développer progressivement votre précision "
        + "et votre aisance au clavier. "
        + "Entièrement accessible avec VoiceOver, Apprenti Clavier est conçu pour accompagner "
        + "aussi bien les personnes aveugles ou malvoyantes que les personnes voyantes."

    private var nomNettoye: String {
        nouveauNom.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private var nomFormateurNettoye: String {
        nouveauNomFormateur.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    var body: some View {
        Group {
            if let formateur = formateurs.formateurActif {
                MenuFormateurView(
                    nomFormateur: formateur
                )
            } else if afficherMenuPrincipal,
               let utilisateur =
                progression.utilisateurActif {
                MenuPrincipalView(
                    nomUtilisateur: utilisateur,
                    changerUtilisateur: revenirAuxProfils
                )
            } else {
                contenuAccueil
            }
        }
        .onAppear {
            synchroniserAvecUtilisateurActif()
            MenuFormateurDynamique.shared.mettreAJour(
                estConnecte: formateurs.formateurActif != nil
            )
        }
        .onReceive(
            progression.$utilisateurActif
        ) { _ in
            synchroniserAvecUtilisateurActif()
        }
        .onReceive(formateurs.$formateurActif) { valeur in
            MenuFormateurDynamique.shared.mettreAJour(
                estConnecte: valeur != nil
            )
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: NSApplication.didBecomeActiveNotification
            )
        ) { _ in
            MenuFormateurDynamique.shared.mettreAJour(
                estConnecte: formateurs.formateurActif != nil
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .accederEspaceApprenant)) { _ in
            formateurs.deconnecter()
            if progression.utilisateurActif != nil {
                progression.fermerSessionUtilisateur()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                focusClavier = nil
                focusVoiceOver = .titreApprenants
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .changerDeFormateur)) { _ in
            formateurs.deconnecter()
            if progression.utilisateurActif != nil {
                progression.fermerSessionUtilisateur()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                focusClavier = nil
                focusVoiceOver = .titreFormateurs
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .changerApprenant)) { _ in
            revenirAuxProfils()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: NSWindow.didBecomeKeyNotification
            )
        ) { notification in
            MenuFormateurDynamique.shared.mettreAJour(
                estConnecte: formateurs.formateurActif != nil
            )

            guard progression.utilisateurActif == nil else {
                return
            }

            guard formateurs.formateurActif == nil,
                  contexteCodePIN == nil,
                  focusClavier == nil else {
                return
            }

            guard accueilDejaPresente else {
                return
            }

            guard let fenetre = notification.object as? NSWindow,
                  fenetre.title != "Réglages" else {
                return
            }

            replacerFocusSurAccueil()
        }
        .sheet(item: $contexteCodePIN) { contexte in
            CodePINFormateurView(
                contexte: contexte,
                terminer: {
                    contexteCodePIN = nil
                },
                annuler: {
                    contexteCodePIN = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        focusVoiceOver = .formateur(contexte.nomFormateur)
                    }
                }
            )
        }
    }

    private var contenuAccueil: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                Text("Apprenti Clavier")
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .acAccessibilityRotorEntry(id: ElementAccessible.titreApplication, in: espaceEntetesAccueil)

                Text("Accueil")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .acAccessibilityRotorEntry(
                        id: ElementAccessible.titreAccueil,
                        in: espaceEntetesAccueil
                    )
                    .accessibilityFocused(
                        $focusVoiceOver,
                        equals: .titreAccueil
                    )

                Text(descriptionAccueil)
                    .accessibilityLabel(
                        descriptionAccueil
                    )
                    .accessibilityFocused(
                        $focusVoiceOver,
                        equals: .description
                    )

                HStack(spacing: 8) {
                    Image(systemName: "person.2")
                        .accessibilityHidden(true)
                    Text("Espace apprenant")
                        .font(.title2).bold()
                        .accessibilityAddTraits(.isHeader)
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: ElementAccessible.titreApprenants,
                    in: espaceEntetesAccueil
                )
                .accessibilityFocused(
                    $focusVoiceOver,
                    equals: .titreApprenants
                )

                if !progression.profilsUtilisateurs.isEmpty {
                    Text("Choisissez un apprenant")
                        .font(.title2)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                        .acAccessibilityRotorEntry(id: ElementAccessible.titreProfils, in: espaceEntetesAccueil)
                        .accessibilityFocused(
                            $focusVoiceOver,
                            equals: .titreProfils
                        )

                    ForEach(
                        progression.profilsUtilisateurs,
                        id: \.self
                    ) { profil in
                        Button {
                            ouvrirProfil(profil)
                        } label: {
                            Label(
                                "Continuer avec \(profil)",
                                systemImage: "person.crop.circle"
                            )
                        }
                        .accessibilityLabel(
                            "Continuer avec \(profil)"
                        )
                        .accessibilityFocused(
                            $focusVoiceOver,
                            equals: .profil(profil)
                        )
                    }

                    Divider()
                }

                HStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                        .accessibilityHidden(true)

                    Text("Créer un apprenant")
                    .font(.title2)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .acAccessibilityRotorEntry(id: ElementAccessible.titreCreationApprenant, in: espaceEntetesAccueil)
                }

                Text("Nom de l’apprenant :")
                    .font(.headline)

                TextField(
                    "Saisissez votre nom d’apprenant et appuyez sur Entrée",
                    text: $nouveauNom
                )
                .textFieldStyle(
                    RoundedBorderTextFieldStyle()
                )
                .frame(width: 320)
                .accessibilityLabel(
                    "Saisissez votre nom d’apprenant et appuyez sur Entrée"
                )
                .accessibilityHint(
                    "Saisissez votre nom d’apprenant, puis appuyez sur Entrée pour continuer."
                )
                .accessibilityFocused(
                    $focusVoiceOver,
                    equals: .nouveauNom
                )
                .focused(
                    $focusClavier,
                    equals: .nouveauNom
                )
                .onSubmit {
                    creerEtOuvrirProfil()
                }

                if !messageErreur.isEmpty {
                    Text(messageErreur)
                        .accessibilityLabel(messageErreur)
                }

                Divider()

                HStack(spacing: 8) {
                    Image(systemName: "graduationcap")
                        .accessibilityHidden(true)
                    Text("Espace formateur")
                        .font(.title2).bold()
                        .accessibilityAddTraits(.isHeader)
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: ElementAccessible.titreFormateurs,
                    in: espaceEntetesAccueil
                )
                .accessibilityFocused(
                    $focusVoiceOver,
                    equals: .titreFormateurs
                )

                if !formateurs.formateurs.isEmpty {
                    Text("Choisissez un formateur")
                        .font(.title2)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                        .acAccessibilityRotorEntry(id: ElementAccessible.titreChoixFormateur, in: espaceEntetesAccueil)

                    ForEach(formateurs.formateurs, id: \.self) { formateur in
                        Button("Continuer avec \(formateur)") {
                            contexteCodePIN = ContexteCodePIN(
                                nomFormateur: formateur,
                                mode: formateurs.possedeUnCodePIN(formateur)
                                    ? .connexion
                                    : .creation
                            )
                            focusClavier = nil
                            focusVoiceOver = nil
                        }
                        .accessibilityFocused(
                            $focusVoiceOver,
                            equals: .formateur(formateur)
                        )
                    }
                }

                HStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .accessibilityHidden(true)

                    Text("Créer un formateur")
                        .font(.title2)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                        .acAccessibilityRotorEntry(id: ElementAccessible.titreCreationFormateur, in: espaceEntetesAccueil)
                }

                Text("Nom du formateur :")
                    .font(.headline)

                TextField(
                    "Saisissez votre nom de formateur et appuyez sur Entrée",
                    text: $nouveauNomFormateur
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 320)
                .accessibilityLabel(
                    "Saisissez votre nom de formateur et appuyez sur Entrée"
                )
                .accessibilityHint(
                    "Saisissez votre nom de formateur, puis appuyez sur Entrée pour créer le profil formateur."
                )
                .accessibilityFocused(
                    $focusVoiceOver,
                    equals: .nouveauNomFormateur
                )
                .focused(
                    $focusClavier,
                    equals: .nouveauNomFormateur
                )
                .onSubmit {
                    creerEtOuvrirFormateur()
                }

                if !messageErreurFormateur.isEmpty {
                    Text(messageErreurFormateur)
                        .accessibilityLabel(messageErreurFormateur)
                }

                Spacer(minLength: 30)
            }
            .padding(40)
            .frame(
                minWidth: 650,
                minHeight: 520,
                alignment: .topLeading
            )
        }
        .acAccessibilityRotor("En-têtes Apprenti Clavier", montereyEntries: {
            acMontereyRotorItems(entetesAccueil, id: \.id) { entete in
                ACMontereyRotorEntry(entete.titre, id: entete.id, in: espaceEntetesAccueil)
            }
        }) {
            ForEach(entetesAccueil, id: \.id) { entete in
                AccessibilityRotorEntry(Text(entete.titre), id: entete.id, in: espaceEntetesAccueil)
            }
        }
    }

    // Les conditions portent sur les données, pas sur le constructeur du rotor (macOS 12).
    private var entetesAccueil: [(id: ElementAccessible, titre: String)] {
        var entetes: [(id: ElementAccessible, titre: String)] = [
            (.titreApplication, "Apprenti Clavier"),
            (.titreAccueil, "Accueil"),
            (.titreApprenants, "Espace apprenant")
        ]
        if !progression.profilsUtilisateurs.isEmpty {
            entetes.append((.titreProfils, "Choisissez un apprenant"))
        }
        entetes.append((.titreCreationApprenant, "Créer un apprenant"))
        entetes.append((.titreFormateurs, "Espace formateur"))
        if !formateurs.formateurs.isEmpty {
            entetes.append((.titreChoixFormateur, "Choisissez un formateur"))
        }
        entetes.append((.titreCreationFormateur, "Créer un formateur"))
        return entetes
    }

    private func synchroniserAvecUtilisateurActif() {
        if progression.utilisateurActif != nil {
            utilisateurEtaitConnecte = true
            afficherMenuPrincipal = true
            focusClavier = nil
            focusVoiceOver = nil
        } else {
            let retourDepuisUnProfil =
                utilisateurEtaitConnecte

            utilisateurEtaitConnecte = false
            afficherMenuPrincipal = false
            nouveauNom = ""
            messageErreur = ""
            sequenceAccueilLancee = false
            focusClavier = nil
            focusVoiceOver = nil

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.6
            ) {
                if retourDemandeVersApprenants,
                   accueilDejaPresente {
                    retourDemandeVersApprenants = false
                    focusVoiceOver = .titreApprenants
                } else if retourDepuisUnProfil,
                   accueilDejaPresente {
                    placerFocusSurTitreAccueil()
                } else {
                    lancerSequenceAccueilSiNecessaire()
                }
            }
        }
    }

    private func lancerSequenceAccueilSiNecessaire() {
        guard !sequenceAccueilLancee else {
            return
        }

        sequenceAccueilLancee = true

        if !accueilDejaPresente {
            focusVoiceOver = nil

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.7
            ) {
                guard focusClavier == nil,
                      contexteCodePIN == nil,
                      progression.utilisateurActif == nil,
                      formateurs.formateurActif == nil else { return }
                focusVoiceOver = .titreAccueil
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now()
                    + 0.7
                    + delaiPourLecture(
                        descriptionAccueil
                    )
            ) {
                guard focusClavier == nil,
                      contexteCodePIN == nil,
                      progression.utilisateurActif == nil,
                      formateurs.formateurActif == nil else { return }
                accueilDejaPresente = true
            }
        } else {
            placerFocusSurTitreAccueil()
        }
    }

    private func placerFocusSurTitreAccueil() {
        focusVoiceOver = nil
        focusClavier = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            guard focusClavier == nil,
                  contexteCodePIN == nil,
                  progression.utilisateurActif == nil,
                  formateurs.formateurActif == nil else { return }
            focusVoiceOver = .titreAccueil
        }
    }

    private func placerFocusInitial() {
        focusVoiceOver = nil
        focusClavier = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.2
        ) {
            guard focusClavier == nil,
                  contexteCodePIN == nil,
                  progression.utilisateurActif == nil,
                  formateurs.formateurActif == nil else {
                return
            }
            focusVoiceOver = .titreAccueil
        }
    }

    private func replacerFocusSurAccueil() {
        focusVoiceOver = nil
        focusClavier = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.8
        ) {
            guard focusClavier == nil,
                  contexteCodePIN == nil,
                  progression.utilisateurActif == nil,
                  formateurs.formateurActif == nil else {
                return
            }
            placerFocusInitial()
        }
    }

    private func ouvrirProfil(_ profil: String) {
        messageErreur = ""
        progression.activerUtilisateur(profil)
        focusClavier = nil
        focusVoiceOver = nil
        afficherMenuPrincipal = true
    }

    private func creerEtOuvrirProfil() {
        guard !nomNettoye.isEmpty else {
            messageErreur =
                "Veuillez saisir un nom d’apprenant."
            return
        }

        messageErreur = ""

        guard progression.creerEtActiverUtilisateur(
            nomNettoye
        ) else {
            messageErreur =
                "Impossible de créer cet utilisateur."
            return
        }

        // Une fois le profil créé, le champ de création n’a plus
        // besoin de conserver le nom saisi. Cela évite qu’il réapparaisse
        // plus tard si ce profil est supprimé et que l’on revient à l’accueil.
        nouveauNom = ""

        focusClavier = nil
        focusVoiceOver = nil
        afficherMenuPrincipal = true
    }

    private func creerEtOuvrirFormateur() {
        guard !nomFormateurNettoye.isEmpty else {
            messageErreurFormateur =
                "Veuillez saisir un nom de formateur."
            return
        }

        messageErreurFormateur = ""

        let nom = nomFormateurNettoye
        if let existant = formateurs.nomFormateurExistant(nom) {
            contexteCodePIN = ContexteCodePIN(
                nomFormateur: existant,
                mode: formateurs.possedeUnCodePIN(existant) ? .connexion : .creation
            )
        } else {
            contexteCodePIN = ContexteCodePIN(nomFormateur: nom, mode: .creation)
        }
        nouveauNomFormateur = ""
        focusClavier = nil
        focusVoiceOver = nil
    }

    private func revenirAuxProfils() {
        retourDemandeVersApprenants = true
        progression.fermerSessionUtilisateur()
    }

    private func delaiPourLecture(
        _ texte: String
    ) -> TimeInterval {
        let nombreDeMots =
            texte.split {
                $0.isWhitespace
            }.count

        let estimation =
            Double(nombreDeMots) * 0.42 + 2.0

        return min(
            max(estimation, 5.0),
            30.0
        )
    }
}
