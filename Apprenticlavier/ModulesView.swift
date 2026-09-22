//
//  ModulesView.swift
//  Apprenti Clavier
//
//  Écran des modules et des leçons.
//  Le titre de chaque écran reçoit le focus VoiceOver en premier.
//

import SwiftUI
import AppKit

struct ModulesView: View {

    @ObservedObject private var progression =
        ProgressionManager.shared

    let retourMenuPrincipal: () -> Void
    let leconInitialeID: Int?

    @State private var moduleSelectionne: ModuleDefinition?
    @State private var leconSelectionnee: LessonDefinition?
    @State private var ouvertureInitialeEffectuee = false
    @State private var moniteurClavier: Any?

    private enum CibleFocus: Hashable {
        case titreModules
        case titreModule(Int)
    }

    private enum EnteteModules: Hashable {
        case titreModules
        case module(Int)
    }

    @AccessibilityFocusState
    private var cibleFocus: CibleFocus?
    @Namespace private var espaceEntetes

    init(
        retourMenuPrincipal: @escaping () -> Void,
        leconInitialeID: Int? = nil
    ) {
        self.retourMenuPrincipal = retourMenuPrincipal
        self.leconInitialeID = leconInitialeID
    }

    var body: some View {
        Group {
            if let lecon = leconSelectionnee {
                ReusableLessonView(
                    lesson: lecon,
                    retourMenuChapitres: {
                        leconSelectionnee = nil

                        if let module = moduleSelectionne {
                            placerFocusSurTitreModule(module.id)
                        }
                    }
                )
            } else if let module = moduleSelectionne {
                listeDesLecons(module)
            } else {
                listeDesModules
            }
        }
        .acAccessibilityRotor("En-têtes Apprenti Clavier", montereyEntries: {
            ACMontereyRotorEntry(
                "Modules",
                id: EnteteModules.titreModules,
                in: espaceEntetes
            )
            acMontereyRotorItems(ModuleDefinition.tousLesModules) { module in
                ACMontereyRotorEntry(
                    module.titre,
                    id: EnteteModules.module(module.id),
                    in: espaceEntetes
                )
            }
        }) {
            AccessibilityRotorEntry(
                "Modules",
                id: EnteteModules.titreModules,
                in: espaceEntetes
            )
            ForEach(ModuleDefinition.tousLesModules) { module in
                AccessibilityRotorEntry(
                    Text(module.titre),
                    id: EnteteModules.module(module.id),
                    in: espaceEntetes
                )
            }
        }
        .onAppear {
            ouvrirLeconInitialeSiNecessaire()
            installerMoniteurClavier()

            if leconInitialeID == nil {
                placerFocusSurTitreModules()
            }
        }
        .onDisappear {
            retirerMoniteurClavier()
        }
    }

    private func installerMoniteurClavier() {
        retirerMoniteurClavier()

        moniteurClavier = NSEvent.addLocalMonitorForEvents(
            matching: .keyDown
        ) { evenement in
            guard evenement.keyCode == 53 else {
                return evenement
            }

            // Ne rien faire pendant un exercice.
            guard leconSelectionnee == nil else {
                return evenement
            }

            if moduleSelectionne != nil {
                DispatchQueue.main.async {
                    moduleSelectionne = nil
                    placerFocusSurTitreModules()
                }
            } else {
                DispatchQueue.main.async {
                    retourMenuPrincipal()
                }
            }

            return nil
        }
    }

    private func retirerMoniteurClavier() {
        if let moniteurClavier {
            NSEvent.removeMonitor(moniteurClavier)
            self.moniteurClavier = nil
        }
    }

    private var listeDesModules: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

            Text("Modules")
                .font(.largeTitle)
                .bold()
                .accessibilityHeading(.h1)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused(
                    $cibleFocus,
                    equals: .titreModules
                )
                .acAccessibilityRotorEntry(
                    id: EnteteModules.titreModules,
                    in: espaceEntetes
                )

            Button("Retour au menu principal") {
                retourMenuPrincipal()
            }

            Text(
                "Choisissez un module pour découvrir ses leçons."
            )

            ForEach(ModuleDefinition.tousLesModules) { module in
                let disponible = moduleEstDisponible(module)
                let termine = moduleEstTermine(module)

                Button {
                    if disponible {
                        moduleSelectionne = module
                        placerFocusSurTitreModule(module.id)
                    } else {
                        signalerElementVerrouille(
                            messageVerrouillageModule(module)
                        )
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            if termine {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .accessibilityHidden(true)
                            } else if !disponible {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.red)
                                    .accessibilityHidden(true)
                            }

                            Text(
                                titreDuModule(
                                    module,
                                    termine: termine
                                )
                            )
                        }

                        Text(module.description)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        libelleAccessibleDuModule(
                            module,
                            disponible: disponible,
                            termine: termine
                        )
                        + ", "
                        + module.description
                    )
                )
                .accessibilityAddTraits(.isHeader)
                .acAccessibilityRotorEntry(
                    id: EnteteModules.module(module.id),
                    in: espaceEntetes
                )
                .accessibilityHint(
                    indiceAccessibleDuModule(
                        module,
                        disponible: disponible,
                        termine: termine
                    )
                )
                .accessibilityAction {
                    if disponible {
                        moduleSelectionne = module
                        placerFocusSurTitreModule(module.id)
                    } else {
                        signalerElementVerrouille(
                            messageVerrouillageModule(module)
                        )
                    }
                }
                
            }

            Spacer()
            }
            .padding(40)
            .frame(minWidth: 700, minHeight: 560, alignment: .topLeading)
        }
    }

    private func listeDesLecons(
        _ module: ModuleDefinition
    ) -> some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(module.titre)
                .font(.largeTitle)
                .bold()
                .accessibilityHeading(.h1)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused(
                    $cibleFocus,
                    equals: .titreModule(module.id)
                )
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        module.titre
                    )
                )

            Button("Retour aux modules") {
                moduleSelectionne = nil
                placerFocusSurTitreModules()
            }

            Text(module.description)
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        module.description
                    )
                )

            ForEach(module.lecons) { lecon in
                let estTerminee =
                    progression.leconEstTerminee(
                        lecon.id
                    )

                let estDisponible =
                    progression.leconEstDisponible(
                        lecon.id
                    )

                Button {
                    if estDisponible {
                        leconSelectionnee = lecon
                    } else {
                        signalerElementVerrouille(
                            "Leçon verrouillée. Terminez la leçon précédente."
                        )
                    }
                } label: {
                    HStack(spacing: 8) {
                        if estTerminee {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .accessibilityHidden(true)
                        } else if !estDisponible {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.red)
                                .accessibilityHidden(true)
                        }

                        Text(
                            titreDuBouton(
                                pour: lecon,
                                estTerminee: estTerminee
                            )
                        )
                    }
                }
                .accessibilityLabel(
                    VoiceOverAnnouncer.textePourPrononciation(
                        libelleAccessible(
                            pour: lecon,
                            estTerminee: estTerminee,
                            estDisponible: estDisponible
                        )
                    )
                )
                .accessibilityHint(
                    indiceAccessible(
                        pour: lecon,
                        estTerminee: estTerminee,
                        estDisponible: estDisponible
                    )
                )
            }

            Spacer()
        }
        .padding(40)
        .frame(minWidth: 700, minHeight: 560)
    }

    private func titreDuModule(
        _ module: ModuleDefinition,
        termine: Bool
    ) -> String {
        termine
            ? module.titre + " ✓ Terminé"
            : module.titre
    }

    private func libelleAccessibleDuModule(
        _ module: ModuleDefinition,
        disponible: Bool,
        termine: Bool
    ) -> String {
        if termine {
            return module.titre + ", terminé"
        }

        if !disponible {
            return module.titre + ", verrouillé"
        }

        return module.titre
    }

    private func indiceAccessibleDuModule(
        _ module: ModuleDefinition,
        disponible: Bool,
        termine: Bool
    ) -> String {
        if termine {
            return "Ce module est terminé. Activez pour revoir ses leçons."
        }

        if !disponible {
            return "Terminez le module précédent pour déverrouiller ce module."
        }

        return "Ouvre les leçons de ce module."
    }

    private func moduleEstDisponible(
        _ module: ModuleDefinition
    ) -> Bool {
        guard module.id > 1 else {
            return true
        }

        guard let index =
                ModuleDefinition.tousLesModules.firstIndex(
                    where: { $0.id == module.id }
                ),
              index > 0 else {
            return false
        }

        let modulePrecedent =
            ModuleDefinition.tousLesModules[index - 1]

        return moduleEstTermine(modulePrecedent)
    }

    private func messageVerrouillageModule(
        _ module: ModuleDefinition
    ) -> String {
        guard let index = ModuleDefinition.tousLesModules.firstIndex(
            where: { $0.id == module.id }
        ),
        index > 0 else {
            return "Module verrouillé."
        }

        let modulePrecedent =
            ModuleDefinition.tousLesModules[index - 1]

        let titreModulePrecedent =
            modulePrecedent.titre.prefix(1).lowercased()
            + String(modulePrecedent.titre.dropFirst())

        return "Module verrouillé. Pour déverrouiller ce module, terminez d’abord le "
            + titreModulePrecedent
            + "."
    }

    private func moduleEstTermine(
        _ module: ModuleDefinition
    ) -> Bool {
        !module.lecons.isEmpty
            && module.lecons.allSatisfy {
                progression.leconEstTerminee($0.id)
            }
    }

    private func titreDuBouton(
        pour lecon: LessonDefinition,
        estTerminee: Bool
    ) -> String {
        let titre =
            lecon.titre
            + " : "
            + lecon.sousTitre

        return estTerminee
            ? titre + " — terminée"
            : titre
    }

    private func libelleAccessible(
        pour lecon: LessonDefinition,
        estTerminee: Bool,
        estDisponible: Bool
    ) -> String {
        let libelle =
            lecon.titre
            + ", "
            + lecon.sousTitre

        if estTerminee {
            return libelle + ", terminée"
        }

        if !estDisponible {
            return libelle + ", verrouillée"
        }

        return libelle
    }

    private func indiceAccessible(
        pour lecon: LessonDefinition,
        estTerminee: Bool,
        estDisponible: Bool
    ) -> String {
        if estTerminee {
            return "Cette leçon est terminée. Activez pour la refaire."
        }

        if !estDisponible {
            return "Terminez la leçon précédente pour déverrouiller celle-ci."
        }

        return "Ouvre "
            + lecon.titre.lowercased()
            + " sur "
            + lecon.sousTitre.lowercased()
            + "."
    }


    private func signalerElementVerrouille(
        _ annonce: String
    ) {
        if let url = Bundle.main.url(
            forResource: "CadenasVerrouille",
            withExtension: "wav"
        ), let son = NSSound(
            contentsOf: url,
            byReference: false
        ) {
            son.stop()
            son.play()
        } else {
            NSSound.beep()
        }

        VoiceOverAnnouncer.annoncerTexte(
            annonce,
            apres: 0.15
        )
    }

    private func ouvrirLeconInitialeSiNecessaire() {
        guard !ouvertureInitialeEffectuee else {
            return
        }

        ouvertureInitialeEffectuee = true

        guard let identifiant = leconInitialeID else {
            return
        }

        for module in ModuleDefinition.tousLesModules {
            if let lecon = module.lecons.first(
                where: { $0.id == identifiant }
            ) {
                moduleSelectionne = module
                leconSelectionnee = lecon
                return
            }
        }
    }

    private func placerFocusSurTitreModules() {
        cibleFocus = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.35
        ) {
            cibleFocus = .titreModules
        }
    }

    private func placerFocusSurTitreModule(
        _ identifiant: Int
    ) {
        cibleFocus = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.35
        ) {
            cibleFocus = .titreModule(identifiant)
        }
    }
}
