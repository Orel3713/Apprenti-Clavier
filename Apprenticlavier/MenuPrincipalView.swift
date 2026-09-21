//
//  MenuPrincipalView.swift
//  Apprenti Clavier
//

import SwiftUI

extension Notification.Name {
    static let replacerFocusEspaceApprenant = Notification.Name("replacerFocusEspaceApprenant")
}

struct MenuPrincipalView: View {

    let nomUtilisateur: String
    let changerUtilisateur: () -> Void

    @ObservedObject private var progression =
        ProgressionManager.shared
    @ObservedObject private var formateurs =
        FormateurManager.shared

    @State private var afficherModules = false
    @State private var afficherParametres = false
    @State private var afficherLeconsPersonnalisees = false
    @State private var leconAReprendreID: Int? = nil
    @State private var messageInformation = ""
    @State private var premierePresentationDuMenu = true

    private enum CibleFocusMenu: Hashable {
        case salutation
        case espaceApprenant
    }
    @AccessibilityFocusState
    private var cibleFocusMenu: CibleFocusMenu?

    init(
        nomUtilisateur: String,
        changerUtilisateur: @escaping () -> Void = {}
    ) {
        self.nomUtilisateur = nomUtilisateur
        self.changerUtilisateur = changerUtilisateur
    }

    var body: some View {
        Group {
            if afficherLeconsPersonnalisees {
                LeconsPersonnaliseesApprenantView(
                    nomApprenant: nomUtilisateur,
                    retour: {
                        afficherLeconsPersonnalisees = false
                        placerFocusSurEspaceApprenant()
                    }
                )
            } else if afficherModules {
                ModulesView(
                    retourMenuPrincipal: {
                        afficherModules = false
                        leconAReprendreID = nil
                        placerFocusSurEspaceApprenant()
                    },
                    leconInitialeID:
                        leconAReprendreID
                )
            } else if afficherParametres {
                ParametresView(
                    retourMenuPrincipal: {
                        afficherParametres = false
                        placerFocusSurEspaceApprenant()
                    }
                )
            } else {
                menuPrincipal
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .replacerFocusEspaceApprenant)) { _ in
            if !afficherLeconsPersonnalisees && !afficherModules && !afficherParametres {
                placerFocusSurEspaceApprenant()
            }
        }
    }

    private var menuPrincipal: some View {
        VStack(spacing: 22) {
            Text("Bonjour, \(nomUtilisateur) !")
                .font(.largeTitle)
                .bold()
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused(
                    $cibleFocusMenu,
                    equals: .salutation
                )

            Text("Espace apprenant")
                .font(.title2)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused(
                    $cibleFocusMenu,
                    equals: .espaceApprenant
                )

            Text(texteProgression)
                .font(.headline)

            Button {
                reprendreProgression()
            } label: {
                Label(
                    "Reprendre ma progression",
                    systemImage: "arrow.right.circle"
                )
            }
            .accessibilityLabel(
                "Reprendre ma progression"
            )
            .keyboardShortcut(.defaultAction)

            Button {
                messageInformation = ""
                leconAReprendreID = nil
                afficherModules = true
            } label: {
                Label(
                    "Choisir un module",
                    systemImage: "book"
                )
            }
            .accessibilityLabel(
                "Choisir un module"
            )

            if formateurs.contientDesLeconsDisponibles(pour: nomUtilisateur) {
                Button {
                    afficherLeconsPersonnalisees = true
                } label: {
                    Label("Leçons personnalisées", systemImage: "doc.text")
                }
                .accessibilityLabel("Leçons personnalisées")
            }

            Button {
                messageInformation = ""

                GestionnaireFenetresAuxiliaires
                    .shared
                    .ouvrirStatistiques()
            } label: {
                Label(
                    "Statistiques",
                    systemImage: "chart.bar"
                )
            }
            .accessibilityLabel(
                "Statistiques"
            )

            Button {
                messageInformation = ""
                changerUtilisateur()
            } label: {
                Label(
                    "Changer d’apprenant",
                    systemImage: "person.2"
                )
            }
            .accessibilityLabel(
                "Changer d’apprenant"
            )

            Button {
                messageInformation = ""
                afficherParametres = true
            } label: {
                Label(
                    "Réglages",
                    systemImage: "gearshape"
                )
            }
            .accessibilityLabel(
                "Réglages"
            )

            if !messageInformation.isEmpty {
                Text(messageInformation)
                    .accessibilityLabel(
                        messageInformation
                    )
            }

            Spacer()
        }
        .padding(40)
        .frame(
            minWidth: 650,
            minHeight: 520
        )
        .onAppear {
            if premierePresentationDuMenu {
                premierePresentationDuMenu = false
                placerFocusSurMenu(.salutation)
            }
        }
    }

    private var texteProgression: String {
        let nombre =
            progression.nombreLeconsTerminees

        if nombre == 0 {
            return
                "Aucune leçon terminée pour cet utilisateur."
        }

        if nombre == 1 {
            return
                "1 leçon terminée pour cet utilisateur."
        }

        return
            "\(nombre) leçons terminées pour cet utilisateur."
    }

    private func reprendreProgression() {
        messageInformation = ""

        let lecons =
            ModuleDefinition.toutesLesLecons

        if let prochaine =
            progression.prochaineLecon(
                dans: lecons
            ) {
            leconAReprendreID = prochaine.id
            afficherModules = true
        } else {
            leconAReprendreID = nil
            messageInformation =
                "Toutes les leçons disponibles sont terminées."
            afficherModules = true
        }
    }

    private func placerFocusSurEspaceApprenant() {
        placerFocusSurMenu(.espaceApprenant)
    }

    private func placerFocusSurMenu(_ cible: CibleFocusMenu) {
        cibleFocusMenu = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.4
        ) {
            cibleFocusMenu = cible
        }
    }
}
