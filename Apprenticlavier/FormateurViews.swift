import SwiftUI
import AppKit

extension Notification.Name {
    static let creerLeconFormateur = Notification.Name("creerLeconFormateur")
    static let afficherLeconsFormateur = Notification.Name("afficherLeconsFormateur")
    static let afficherStatistiquesFormateur = Notification.Name("afficherStatistiquesFormateur")
    static let accederEspaceApprenant = Notification.Name("accederEspaceApprenant")
    static let changerDeFormateur = Notification.Name("changerDeFormateur")
    static let changerApprenant = Notification.Name("changerApprenant")
    static let replacerFocusListeLeconsFormateur = Notification.Name("replacerFocusListeLeconsFormateur")
}

private func definitionPersonnalisee(
    _ lecon: LeconPersonnalisee,
    formateur: String
) -> LessonDefinition {
    LessonDefinition(
        id: 100_000,
        titre: lecon.titre,
        sousTitre: lecon.sousTitre,
        introduction: lecon.introduction,
        etapes: lecon.fiches.enumerated().map {
            LessonStepDefinition(id: $0.offset + 1, titre: $0.element.titre, texte: $0.element.contenu)
        },
        exercices: lecon.exercices.enumerated().map {
            TypingExerciseDefinition(
                id: $0.offset + 1,
                texteAttendu: $0.element.texteAttendu,
                instruction: $0.element.consigne,
                modeLecture: .lireNaturellement
            )
        },
        resumeFinal: lecon.resumeFinal,
        identifiantLeconPersonnalisee: lecon.id,
        nomFormateurSource: formateur,
        objectifPedagogique: lecon.objectifPedagogique
    )
}

struct MenuFormateurView: View {
    let nomFormateur: String
    @ObservedObject private var manager = FormateurManager.shared
    @State private var destination: Destination?
    @State private var premierePresentationDuMenu = true
    @State private var retourVersMenuEnCours = false
    private enum CibleFocusMenu: Hashable { case salutation, espaceFormateur }
    @AccessibilityFocusState private var cibleFocusMenu: CibleFocusMenu?
    private enum Destination { case creer, gerer, statistiques }

    var body: some View {
        Group {
            switch destination {
            case .creer:
                EditeurLeconView(lecon: nil) { revenirAuMenu() }
            case .gerer:
                GestionLeconsView { revenirAuMenu() }
            case .statistiques:
                StatistiquesFormateurView { revenirAuMenu() }
            case nil:
                menu
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .creerLeconFormateur)) { _ in
            destination = .creer
        }
        .onReceive(NotificationCenter.default.publisher(for: .afficherLeconsFormateur)) { _ in
            destination = .gerer
        }
        .onReceive(NotificationCenter.default.publisher(for: .afficherStatistiquesFormateur)) { _ in
            destination = .statistiques
        }
    }

    private var menu: some View {
        VStack(spacing: 22) {
            Text("Bonjour, \(nomFormateur) !")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($cibleFocusMenu, equals: .salutation)
                .accessibilityHidden(retourVersMenuEnCours)
            Text("Espace formateur")
                .font(.title2)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($cibleFocusMenu, equals: .espaceFormateur)
            Text(texteNombreLecons)
            Button {
                destination = .creer
            } label: {
                Label("Créer une leçon personnalisée", systemImage: "square.and.pencil")
            }
            .keyboardShortcut(.defaultAction)
            Button {
                destination = .gerer
            } label: {
                Label("Modifier ou prévisualiser mes leçons", systemImage: "doc.text.magnifyingglass")
            }
            Button {
                destination = .statistiques
            } label: {
                Label("Statistiques des apprenants", systemImage: "chart.bar.xaxis")
            }
            Spacer()
        }
        .padding(40)
        .frame(minWidth: 700, minHeight: 560)
        .onAppear {
            if premierePresentationDuMenu {
                premierePresentationDuMenu = false
                placerFocusMenu(.salutation)
            } else if retourVersMenuEnCours {
                cibleFocusMenu = .espaceFormateur
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    retourVersMenuEnCours = false
                }
            }
        }
    }

    private func revenirAuMenu() {
        retourVersMenuEnCours = true
        cibleFocusMenu = .espaceFormateur
        destination = nil
        DispatchQueue.main.async {
            cibleFocusMenu = .espaceFormateur
        }
    }

    private func placerFocusMenu(_ cible: CibleFocusMenu) {
        cibleFocusMenu = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            cibleFocusMenu = cible
        }
    }

    private var texteNombreLecons: String {
        manager.lecons.count == 1
            ? "1 leçon personnalisée créée"
            : "\(manager.lecons.count) leçons personnalisées créées"
    }
}

private struct ReductionNombre: Identifiable {
    enum TypeReduction: Equatable { case fiches, exercices }
    let id = UUID()
    let type: TypeReduction
    let nouveauNombre: Int
}

private struct ContexteSuppressionElements: Identifiable {
    enum TypeElement: Equatable { case fiches, exercices }
    let id = UUID()
    let type: TypeElement
}

private struct ElementASupprimer: Identifiable {
    let id: UUID
    let nom: String
}

private struct SelectionSuppressionView: View {
    let titre: String
    let titreBoutonSingulier: String
    let titreBoutonPluriel: String
    let noms: [ElementASupprimer]
    let interdireToutSupprimer: Bool
    let supprimer: (Set<UUID>) -> Void
    let annuler: () -> Void
    @State private var selection: Set<UUID> = []
    @AccessibilityFocusState private var titreEnFocus: Bool

    private var suppressionInterdite: Bool {
        selection.isEmpty
        || (interdireToutSupprimer && selection.count == noms.count)
    }

    private var titreBouton: String {
        selection.count == 1 ? titreBoutonSingulier : titreBoutonPluriel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(titre)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($titreEnFocus)
            Text("Sélectionnez les éléments à supprimer. Leur contenu sera définitivement supprimé.")
            if interdireToutSupprimer {
                Text("À noter : une leçon doit contenir au moins un exercice. Il n’est donc pas possible de supprimer tous les exercices.")
            }
            Text("Éléments à sélectionner")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Tout sélectionner", isOn: Binding(
                        get: { !noms.isEmpty && selection.count == noms.count },
                        set: { valeur in
                            selection = valeur ? Set(noms.map(\.id)) : []
                        }
                    ))
                    Divider()
                    ForEach(noms) { element in
                        Toggle(element.nom, isOn: Binding(
                            get: { selection.contains(element.id) },
                            set: { valeur in
                                if valeur { selection.insert(element.id) } else { selection.remove(element.id) }
                            }
                        ))
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Liste des éléments à sélectionner")

            Divider()
            HStack {
                Button("Annuler") { annuler() }
                Spacer()
                Button(titreBouton) {
                    if suppressionInterdite {
                        let annonce = interdireToutSupprimer
                            && selection.count == noms.count
                            ? "Suppression impossible. Une leçon doit conserver au moins un exercice."
                            : "Sélectionnez au moins un élément à supprimer."
                        VoiceOverAnnouncer.annoncerTexte(annonce)
                    } else {
                        supprimer(selection)
                    }
                }
                .opacity(suppressionInterdite ? 0.45 : 1)
                .accessibilityLabel(
                    suppressionInterdite
                        ? titreBouton + ", indisponible"
                        : titreBouton
                )
                .accessibilityHint(
                    suppressionInterdite && interdireToutSupprimer
                        ? "Une leçon doit conserver au moins un exercice."
                        : ""
                )
            }
        }
        .padding(26)
        .frame(width: 520, height: 440)
        .onAppear {
            DispatchQueue.main.async { titreEnFocus = true }
        }
        .onExitCommand { annuler() }
    }
}

struct EditeurLeconView: View {
    let lecon: LeconPersonnalisee?
    let retour: () -> Void
    @ObservedObject private var manager = FormateurManager.shared
    @ObservedObject private var progression = ProgressionManager.shared
    @State private var brouillon: LeconPersonnalisee
    @State private var ajouterFiches: Bool
    @State private var ajouterResume: Bool
    @State private var utiliserResumeAutomatique: Bool
    @State private var message = ""
    @State private var reductionDemandee: ReductionNombre?
    @State private var suppressionDemandee: ContexteSuppressionElements?

    private enum ElementFocus: Hashable {
        case titre
        case fiches
        case fiche(UUID)
        case exercices
        case exercice(UUID)
    }
    private enum EnteteEditeur: Hashable {
        case titre, informations, objectif, fiches, exercices, resume, beneficiaires
        case fiche(UUID)
        case exercice(UUID)
    }
    private enum BoutonEditeur: Hashable {
        case ajouterFiche, supprimerFiches, ajouterExercice, supprimerExercices
        case annuler, enregistrer
    }
    @AccessibilityFocusState private var elementEnFocus: ElementFocus?
    @AccessibilityFocusState private var resumeFinalEnFocus: Bool
    @Namespace private var espaceEntetes
    @Namespace private var espaceBoutons

    init(lecon: LeconPersonnalisee?, retour: @escaping () -> Void) {
        self.lecon = lecon
        self.retour = retour
        let valeur = lecon ?? LeconPersonnalisee(
            titre: "", sousTitre: "", introduction: "", fiches: [],
            exercices: [ExercicePersonnalise(consigne: "", texteAttendu: "")],
            resumeFinal: ""
        )
        _brouillon = State(initialValue: valeur)
        _ajouterFiches = State(initialValue: !valeur.fiches.isEmpty)
        _ajouterResume = State(initialValue: !valeur.resumeFinal.isEmpty)
        let resumeAttendu: String?
        if let objectif = valeur.objectifPedagogique {
            resumeAttendu = objectif == .revisionGenerale
                ? "Bravo. Cette leçon vous a permis de réviser et de consolider vos acquis généraux."
                : "Bravo. Cette leçon vous a permis de retravailler les difficultés rencontrées dans le \(objectif.libelle)."
        } else {
            resumeAttendu = nil
        }
        _utiliserResumeAutomatique = State(
            initialValue: resumeAttendu == valeur.resumeFinal
                && !valeur.resumeFinal.isEmpty
        )
    }

    var body: some View {
        Group {
            if let demande = suppressionDemandee {
                SelectionSuppressionView(
                    titre: demande.type == .fiches
                        ? "Supprimer des fiches pédagogiques"
                        : "Supprimer des exercices",
                    titreBoutonSingulier: demande.type == .fiches
                        ? "Supprimer la fiche sélectionnée"
                        : "Supprimer l’exercice sélectionné",
                    titreBoutonPluriel: demande.type == .fiches
                        ? "Supprimer les fiches sélectionnées"
                        : "Supprimer les exercices sélectionnés",
                    noms: nomsPourSuppression(demande.type),
                    interdireToutSupprimer: demande.type == .exercices,
                    supprimer: { selection in
                        supprimerElements(selection, type: demande.type)
                        suppressionDemandee = nil
                        deplacerFocusVers(
                            demande.type == .fiches ? .fiches : .exercices
                        )
                    },
                    annuler: { fermerSelectionSuppression() }
                )
            } else {
                VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(lecon == nil ? "Créer une leçon personnalisée" : "Modifier la leçon")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($elementEnFocus, equals: .titre)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.titre,
                            in: espaceEntetes
                        )

                    Text("Informations générales")
                        .font(.title2.bold()).accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.informations,
                            in: espaceEntetes
                        )
                    Text("Titre de la leçon :").font(.headline)
                    TextField("Saisissez le titre de la leçon", text: $brouillon.titre)
                        .accessibilityLabel("Saisissez le titre de la leçon")
                    Text("Sous-titre de la leçon :").font(.headline)
                    TextField("Saisissez le sous-titre de la leçon", text: $brouillon.sousTitre)
                        .accessibilityLabel("Saisissez le sous-titre de la leçon")
                    Text("Introduction générale de la leçon :").font(.headline)
                    Text("Cette introduction sera annoncée avant les fiches et les exercices.")
                        .font(.callout)
                    champMultiligne(
                        texte: $brouillon.introduction,
                        libelle: "Introduction générale de la leçon",
                        hauteur: 70
                    )

                    Text("Objectif pédagogique")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.objectif,
                            in: espaceEntetes
                        )
                    Picker("", selection: objectifSelectionne) {
                        Text("Aucun objectif sélectionné").tag(nil as ObjectifPedagogique?)
                        ForEach(ObjectifPedagogique.allCases) { objectif in
                            Text(objectif.libelle).tag(Optional(objectif))
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(MenuPickerStyle())
                    Text("Ce choix est facultatif. Il explique à l’apprenant la raison de cette leçon.")
                        .font(.callout)

                    Divider()
                    Text("Fiches pédagogiques")
                        .font(.title2.bold()).accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($elementEnFocus, equals: .fiches)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.fiches,
                            in: espaceEntetes
                        )
                    Toggle("Je souhaite ajouter des fiches pédagogiques", isOn: $ajouterFiches)
                        .onChange(of: ajouterFiches) { valeur in
                            if valeur && brouillon.fiches.isEmpty {
                                ajouterFiche(deplacerFocus: false)
                            }
                            if !valeur && !brouillon.fiches.isEmpty {
                                let contientDuTexte = brouillon.fiches.contains {
                                    !$0.titre.isEmpty || !$0.contenu.isEmpty
                                }
                                if contientDuTexte {
                                    ajouterFiches = true
                                    reductionDemandee = ReductionNombre(type: .fiches, nouveauNombre: 0)
                                } else {
                                    brouillon.fiches = []
                                }
                            }
                        }
                    if ajouterFiches {
                        Picker("Nombre de fiches pédagogiques", selection: nombreFiches) {
                            ForEach(1...20, id: \.self) { nombre in
                                Text("\(nombre)")
                                    .tag(nombre)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        ForEach(Array(brouillon.fiches.indices), id: \.self) { index in
                            let fiche = brouillon.fiches[index]
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fiche \(index + 1)")
                                    .font(.headline).accessibilityAddTraits(.isHeader)
                                    .accessibilityFocused($elementEnFocus, equals: .fiche(fiche.id))
                                    .accessibilityRotorEntry(
                                        id: EnteteEditeur.fiche(fiche.id),
                                        in: espaceEntetes
                                    )
                                Text("Titre de la fiche :")
                                TextField(
                                    "Saisissez le titre de la fiche",
                                    text: $brouillon.fiches[index].titre
                                )
                                .accessibilityLabel(
                                    "Saisissez le titre de la fiche \(index + 1)"
                                )
                                Text("Contenu de la fiche :")
                                champMultiligne(
                                    texte: $brouillon.fiches[index].contenu,
                                    libelle: "Contenu de la fiche \(index + 1)",
                                    hauteur: 80
                                )
                            }
                        }
                        HStack {
                            Button("Ajouter une fiche pédagogique") { ajouterFiche() }
                                .disabled(brouillon.fiches.count >= 20)
                                .accessibilityRotorEntry(
                                    id: BoutonEditeur.ajouterFiche,
                                    in: espaceBoutons
                                )
                            Button("Supprimer des fiches pédagogiques…") {
                                suppressionDemandee = ContexteSuppressionElements(type: .fiches)
                            }
                            .accessibilityRotorEntry(
                                id: BoutonEditeur.supprimerFiches,
                                in: espaceBoutons
                            )
                        }
                    }

                    Divider()
                    Text("Exercices")
                        .font(.title2.bold()).accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($elementEnFocus, equals: .exercices)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.exercices,
                            in: espaceEntetes
                        )
                    Picker("Nombre d’exercices", selection: nombreExercices) {
                        ForEach(1...20, id: \.self) { nombre in
                                Text("\(nombre)")
                                    .tag(nombre)
                            }
                    }
                    .pickerStyle(MenuPickerStyle())

                    ForEach(Array(brouillon.exercices.indices), id: \.self) { index in
                        let exercice = brouillon.exercices[index]
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exercice \(index + 1)")
                                .font(.headline).accessibilityAddTraits(.isHeader)
                                .accessibilityFocused($elementEnFocus, equals: .exercice(exercice.id))
                                .accessibilityRotorEntry(
                                    id: EnteteEditeur.exercice(exercice.id),
                                    in: espaceEntetes
                                )
                            Text("Consigne de l’exercice :")
                            champMultiligne(
                                texte: $brouillon.exercices[index].consigne,
                                libelle: "Saisissez la consigne de l’exercice \(index + 1)",
                                hauteur: 60
                            )
                            Text("Texte attendu :")
                            champMultiligne(
                                texte: $brouillon.exercices[index].texteAttendu,
                                libelle: "Saisissez le texte attendu de l’exercice \(index + 1)",
                                hauteur: 60
                            )
                        }
                    }
                    HStack {
                        Button("Ajouter un exercice") { ajouterExercice() }
                            .disabled(brouillon.exercices.count >= 20)
                            .accessibilityRotorEntry(
                                id: BoutonEditeur.ajouterExercice,
                                in: espaceBoutons
                            )
                        Button("Supprimer des exercices…") {
                            suppressionDemandee = ContexteSuppressionElements(type: .exercices)
                        }
                        .accessibilityRotorEntry(
                            id: BoutonEditeur.supprimerExercices,
                            in: espaceBoutons
                        )
                    }

                    Divider()
                    Text("Résumé de la leçon")
                        .font(.title2.bold()).accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.resume,
                            in: espaceEntetes
                        )
                    Toggle("Je souhaite ajouter un résumé final", isOn: $ajouterResume)
                        .onChange(of: ajouterResume) { valeur in
                            guard valeur else {
                                utiliserResumeAutomatique = false
                                return
                            }
                            if brouillon.resumeFinal.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty,
                               let proposition = resumePropose {
                                utiliserResumeAutomatique = true
                                brouillon.resumeFinal = proposition
                            }
                        }
                    Toggle(
                        "Utiliser le résumé proposé selon l’objectif",
                        isOn: $utiliserResumeAutomatique
                    )
                    .disabled(!ajouterResume || resumePropose == nil)
                    .onChange(of: utiliserResumeAutomatique) { valeur in
                        if valeur {
                            brouillon.resumeFinal = resumePropose ?? ""
                        } else {
                            brouillon.resumeFinal = ""
                        }
                    }
                    if ajouterResume {
                        TextEditor(text: $brouillon.resumeFinal)
                            .frame(minHeight: 80)
                            .accessibilityLabel("Contenu du résumé final")
                            .accessibilityValue(
                                resumeFinalEnFocus ? brouillon.resumeFinal : ""
                            )
                            .accessibilityFocused($resumeFinalEnFocus)
                    }

                    Divider()
                    Text("Bénéficiaires de cette leçon")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: EnteteEditeur.beneficiaires,
                            in: espaceEntetes
                        )
                    Text("Choisissez les apprenants qui pourront utiliser cette leçon.")
                    Toggle("Tous les apprenants", isOn: tousLesApprenants)
                    if progression.profilsUtilisateurs.isEmpty {
                        Text("Aucun profil apprenant n’est encore enregistré.")
                    } else {
                        ForEach(progression.profilsUtilisateurs, id: \.self) { apprenant in
                            Toggle(apprenant, isOn: selectionApprenant(apprenant))
                        }
                    }

                    if !message.isEmpty { Text(message).accessibilityLabel(message) }

                    Divider()
                    HStack(spacing: 12) {
                        Button("Annuler") { retour() }
                            .accessibilityRotorEntry(
                                id: BoutonEditeur.annuler,
                                in: espaceBoutons
                            )
                        Spacer()
                        Button("Enregistrer la leçon") { enregistrer() }
                            .keyboardShortcut(.defaultAction)
                            .disabled(!enregistrementDisponible)
                            .accessibilityRotorEntry(
                                id: BoutonEditeur.enregistrer,
                                in: espaceBoutons
                            )
                    }
                }
                .padding(32)
                .frame(maxWidth: 820, alignment: .leading)
            }

                }
            }
        }
        .frame(minWidth: 760, minHeight: 620)
        .onAppear { placerFocusTitre() }
        .onExitCommand {
            if suppressionDemandee != nil {
                fermerSelectionSuppression()
            }
        }
        .alert(item: $reductionDemandee) { demande in
            Alert(
                title: Text("Réduire le nombre d’éléments ?"),
                message: Text("Les derniers contenus seront définitivement supprimés."),
                primaryButton: .destructive(Text("Supprimer")) {
                    appliquerNombre(demande)
                },
                secondaryButton: .cancel()
            )
        }
        .accessibilityRotor("En-têtes Apprenti Clavier") {
            AccessibilityRotorEntry(
                Text(lecon == nil ? "Créer une leçon personnalisée" : "Modifier la leçon"),
                id: EnteteEditeur.titre,
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Informations générales",
                id: EnteteEditeur.informations,
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Objectif pédagogique",
                id: EnteteEditeur.objectif,
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Fiches pédagogiques",
                id: EnteteEditeur.fiches,
                in: espaceEntetes
            )
            ForEach(
                Array((ajouterFiches ? brouillon.fiches : []).enumerated()),
                id: \.element.id
            ) { index, fiche in
                AccessibilityRotorEntry(
                    "Fiche \(index + 1)",
                    id: EnteteEditeur.fiche(fiche.id),
                    in: espaceEntetes
                )
            }
            AccessibilityRotorEntry(
                "Exercices",
                id: EnteteEditeur.exercices,
                in: espaceEntetes
            )
            ForEach(
                Array(brouillon.exercices.enumerated()),
                id: \.element.id
            ) { index, exercice in
                AccessibilityRotorEntry(
                    "Exercice \(index + 1)",
                    id: EnteteEditeur.exercice(exercice.id),
                    in: espaceEntetes
                )
            }
            AccessibilityRotorEntry(
                "Résumé de la leçon",
                id: EnteteEditeur.resume,
                in: espaceEntetes
            )
            AccessibilityRotorEntry(
                "Bénéficiaires de cette leçon",
                id: EnteteEditeur.beneficiaires,
                in: espaceEntetes
            )
        }
        .accessibilityRotor("Boutons Apprenti Clavier") {
            if ajouterFiches {
                AccessibilityRotorEntry(
                    "Ajouter une fiche pédagogique",
                    id: BoutonEditeur.ajouterFiche,
                    in: espaceBoutons
                )
                AccessibilityRotorEntry(
                    "Supprimer des fiches pédagogiques",
                    id: BoutonEditeur.supprimerFiches,
                    in: espaceBoutons
                )
            }
            AccessibilityRotorEntry(
                "Ajouter un exercice",
                id: BoutonEditeur.ajouterExercice,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Supprimer des exercices",
                id: BoutonEditeur.supprimerExercices,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Annuler",
                id: BoutonEditeur.annuler,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Enregistrer la leçon",
                id: BoutonEditeur.enregistrer,
                in: espaceBoutons
            )
        }
    }

    private var enregistrementDisponible: Bool {
        !brouillon.titre.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
        && brouillon.exercices.allSatisfy {
            !$0.texteAttendu.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty
        }
    }

    private var nombreFiches: Binding<Int> {
        Binding(
            get: { max(brouillon.fiches.count, 1) },
            set: { demanderNombre($0, type: .fiches) }
        )
    }

    private func champMultiligne(
        texte: Binding<String>,
        libelle: String,
        hauteur: CGFloat
    ) -> some View {
        TextEditor(text: texte)
            .frame(minHeight: hauteur)
            .accessibilityLabel(libelle)
    }

    private var objectifSelectionne: Binding<ObjectifPedagogique?> {
        Binding(
            get: { brouillon.objectifPedagogique },
            set: { nouvelObjectif in
                brouillon.objectifPedagogique = nouvelObjectif
                if utiliserResumeAutomatique {
                    if nouvelObjectif == nil {
                        utiliserResumeAutomatique = false
                        brouillon.resumeFinal = ""
                    } else {
                        brouillon.resumeFinal = resumePropose ?? ""
                    }
                }
            }
        )
    }

    private var resumePropose: String? {
        guard let objectif = brouillon.objectifPedagogique else {
            return nil
        }

        if objectif == .revisionGenerale {
            return "Bravo. Cette leçon vous a permis de réviser et de consolider vos acquis généraux."
        }

        return "Bravo. Cette leçon vous a permis de retravailler les difficultés rencontrées dans le \(objectif.libelle)."
    }

    private var tousLesApprenants: Binding<Bool> {
        Binding(
            get: { brouillon.beneficiaires == nil },
            set: { valeur in
                brouillon.beneficiaires = valeur ? nil : []
            }
        )
    }

    private func selectionApprenant(_ apprenant: String) -> Binding<Bool> {
        Binding(
            get: {
                brouillon.beneficiaires == nil
                || (brouillon.beneficiaires ?? []).contains(apprenant)
            },
            set: { valeur in
                var selection = brouillon.beneficiaires
                    ?? progression.profilsUtilisateurs
                if valeur {
                    if !selection.contains(apprenant) { selection.append(apprenant) }
                } else {
                    selection.removeAll { $0 == apprenant }
                }

                let tousSelectionnes = progression.profilsUtilisateurs.allSatisfy {
                    selection.contains($0)
                }
                brouillon.beneficiaires = tousSelectionnes ? nil : selection
            }
        )
    }

    private var nombreExercices: Binding<Int> {
        Binding(
            get: { brouillon.exercices.count },
            set: { demanderNombre($0, type: .exercices) }
        )
    }

    private func demanderNombre(_ nombre: Int, type: ReductionNombre.TypeReduction) {
        let actuel = type == .fiches ? brouillon.fiches.count : brouillon.exercices.count
        guard nombre != actuel else { return }
        if nombre < actuel {
            let contientDuTexte: Bool
            if type == .fiches {
                contientDuTexte = brouillon.fiches.dropFirst(nombre).contains {
                    !$0.titre.isEmpty || !$0.contenu.isEmpty
                }
            } else {
                contientDuTexte = brouillon.exercices.dropFirst(nombre).contains {
                    !$0.consigne.isEmpty || !$0.texteAttendu.isEmpty
                }
            }
            if contientDuTexte {
                reductionDemandee = ReductionNombre(type: type, nouveauNombre: nombre)
                return
            }
        }
        appliquerNombre(ReductionNombre(type: type, nouveauNombre: nombre))
    }

    private func appliquerNombre(_ demande: ReductionNombre) {
        if demande.type == .fiches {
            while brouillon.fiches.count < demande.nouveauNombre { ajouterFiche(deplacerFocus: false) }
            if brouillon.fiches.count > demande.nouveauNombre {
                brouillon.fiches.removeLast(brouillon.fiches.count - demande.nouveauNombre)
            }
            if demande.nouveauNombre == 0 { ajouterFiches = false }
        } else {
            while brouillon.exercices.count < demande.nouveauNombre { ajouterExercice(deplacerFocus: false) }
            if brouillon.exercices.count > demande.nouveauNombre {
                brouillon.exercices.removeLast(brouillon.exercices.count - demande.nouveauNombre)
            }
        }
    }

    private func ajouterFiche(deplacerFocus: Bool = true) {
        guard brouillon.fiches.count < 20 else { return }
        let fiche = FichePersonnalisee(titre: "", contenu: "")
        brouillon.fiches.append(fiche)
        if deplacerFocus { deplacerFocusVers(.fiche(fiche.id)) }
    }

    private func ajouterExercice(deplacerFocus: Bool = true) {
        guard brouillon.exercices.count < 20 else { return }
        let exercice = ExercicePersonnalise(consigne: "", texteAttendu: "")
        brouillon.exercices.append(exercice)
        if deplacerFocus { deplacerFocusVers(.exercice(exercice.id)) }
    }

    private func deplacerFocusVers(_ element: ElementFocus) {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { elementEnFocus = element }
    }

    private func nomsPourSuppression(
        _ type: ContexteSuppressionElements.TypeElement
    ) -> [ElementASupprimer] {
        if type == .fiches {
            return brouillon.fiches.enumerated().map {
                let titre = $0.element.titre.trimmingCharacters(in: .whitespacesAndNewlines)
                return ElementASupprimer(
                    id: $0.element.id,
                    nom: titre.isEmpty
                        ? "Fiche \($0.offset + 1), sans titre"
                        : "Fiche \($0.offset + 1) – \(titre)"
                )
            }
        }
        return brouillon.exercices.enumerated().map {
            ElementASupprimer(id: $0.element.id, nom: "Exercice \($0.offset + 1)")
        }
    }

    private func supprimerElements(
        _ selection: Set<UUID>,
        type: ContexteSuppressionElements.TypeElement
    ) {
        if type == .fiches {
            brouillon.fiches.removeAll { selection.contains($0.id) }
            if brouillon.fiches.isEmpty { ajouterFiches = false }
        } else if brouillon.exercices.count - selection.count >= 1 {
            brouillon.exercices.removeAll { selection.contains($0.id) }
        }
    }

    private func fermerSelectionSuppression() {
        guard let type = suppressionDemandee?.type else { return }
        suppressionDemandee = nil
        deplacerFocusVers(type == .fiches ? .fiches : .exercices)
    }

    private func placerFocusTitre() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { elementEnFocus = .titre }
    }

    private func enregistrer() {
        brouillon.titre = brouillon.titre.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !brouillon.titre.isEmpty else {
            message = "Veuillez saisir le titre de la leçon."
            return
        }
        if !ajouterFiches { brouillon.fiches = [] }
        guard brouillon.exercices.allSatisfy({
            !$0.texteAttendu.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }) else {
            message = "Chaque exercice doit contenir un texte attendu."
            return
        }
        if !ajouterResume { brouillon.resumeFinal = "" }
        manager.enregistrer(brouillon)
        retour()
    }
}

private struct ConfirmationSuppressionLeconView: View {
    let confirmer: () -> Void
    let annuler: () -> Void
    @AccessibilityFocusState private var titreEnFocus: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Suppression de la leçon")
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(
                    "Suppression de la leçon. "
                    + "La leçon personnalisée sera définitivement supprimée."
                )
                .accessibilityFocused($titreEnFocus)
            Text("La leçon personnalisée sera définitivement supprimée.")
                .accessibilityHidden(true)
            HStack {
                Button("Annuler") { annuler() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Supprimer") { confirmer() }
            }
        }
        .padding(26)
        .frame(width: 480)
        .onAppear {
            DispatchQueue.main.async { titreEnFocus = true }
        }
        .onExitCommand { annuler() }
    }
}

private struct FicheGestionLeconView: View {
    let lecon: LeconPersonnalisee
    let previsualiser: () -> Void
    let modifier: () -> Void
    let supprimer: () -> Void
    let fermer: () -> Void
    @State private var confirmerSuppression = false
    @AccessibilityFocusState private var titreEnFocus: Bool
    private enum BoutonGestion: Hashable {
        case previsualiser, modifier, supprimer, retour
    }
    @Namespace private var espaceBoutons

    private var texteBeneficiaires: String {
        guard let beneficiaires = lecon.beneficiaires else {
            return "tous les apprenants"
        }

        if beneficiaires.isEmpty {
            return "aucun apprenant"
        }

        if beneficiaires.count == 1, let unique = beneficiaires.first {
            return unique
        }

        return beneficiaires.joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Gestion de la leçon")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($titreEnFocus)

            Text(lecon.titre)
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)

            if let objectif = lecon.objectifPedagogique {
                Text(objectif.descriptionPourApprenant)
            }

            Text(
                lecon.fiches.count == 1
                    ? "1 fiche pédagogique"
                    : "\(lecon.fiches.count) fiches pédagogiques"
            )
            Text(
                lecon.exercices.count == 1
                    ? "1 exercice"
                    : "\(lecon.exercices.count) exercices"
            )

            Text("Bénéficiaires : \(texteBeneficiaires)")
                .accessibilityLabel("Bénéficiaires : \(texteBeneficiaires)")

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Button("Prévisualiser la leçon") { previsualiser() }
                    .keyboardShortcut(.defaultAction)
                    .accessibilityRotorEntry(
                        id: BoutonGestion.previsualiser,
                        in: espaceBoutons
                    )
                Button("Modifier la leçon") { modifier() }
                    .accessibilityRotorEntry(
                        id: BoutonGestion.modifier,
                        in: espaceBoutons
                    )
                Button("Supprimer la leçon") { confirmerSuppression = true }
                    .accessibilityRotorEntry(
                        id: BoutonGestion.supprimer,
                        in: espaceBoutons
                    )
                Button("Retour à mes leçons") { fermer() }
                    .keyboardShortcut(.cancelAction)
                    .accessibilityRotorEntry(
                        id: BoutonGestion.retour,
                        in: espaceBoutons
                    )
            }

            Spacer()
        }
        .padding(40)
        .frame(minWidth: 720, minHeight: 560, alignment: .topLeading)
        .onAppear { placerFocusTitre() }
        .onExitCommand { fermer() }
        .accessibilityRotor("Boutons Apprenti Clavier") {
            AccessibilityRotorEntry(
                "Prévisualiser la leçon",
                id: BoutonGestion.previsualiser,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Modifier la leçon",
                id: BoutonGestion.modifier,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Supprimer la leçon",
                id: BoutonGestion.supprimer,
                in: espaceBoutons
            )
            AccessibilityRotorEntry(
                "Retour à mes leçons",
                id: BoutonGestion.retour,
                in: espaceBoutons
            )
        }
        .sheet(
            isPresented: $confirmerSuppression,
            onDismiss: { placerFocusTitre() }
        ) {
            ConfirmationSuppressionLeconView(
                confirmer: {
                    confirmerSuppression = false
                    supprimer()
                },
                annuler: { confirmerSuppression = false }
            )
        }
    }

    private func placerFocusTitre() {
        titreEnFocus = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            titreEnFocus = true
        }
    }
}

private struct GroupeLeconsBeneficiaire: Identifiable {
    let id: String
    let titre: String
    let lecons: [LeconPersonnalisee]

    var libelleAccessible: String {
        lecons.count == 1
            ? "\(titre) — 1 leçon"
            : "\(titre) — \(lecons.count) leçons"
    }
}

private struct EmplacementLeconFormateur: Hashable {
    let groupeID: String
    let leconID: UUID
}

struct GestionLeconsView: View {
    let retour: () -> Void
    @ObservedObject private var manager = FormateurManager.shared
    @State private var leconEditee: LeconPersonnalisee?
    @State private var apercu: LeconPersonnalisee?
    @State private var leconSelectionnee: LeconPersonnalisee?
    @State private var dernierEmplacement: EmplacementLeconFormateur?
    @State private var moniteurEchap: Any?

    private enum Focus: Hashable {
        case titre
        case lecon(EmplacementLeconFormateur)
    }
    private enum EnteteListe: Hashable {
        case titre
        case groupe(String)
    }
    @AccessibilityFocusState private var elementEnFocus: Focus?
    @Namespace private var espaceEntetes

    var body: some View {
        Group {
            if let leconEditee {
                EditeurLeconView(lecon: leconEditee) {
                    self.leconEditee = nil
                    restaurerFocusLecon()
                }
            } else if let apercu {
                ReusableLessonView(
                    lesson: definitionPersonnalisee(
                        apercu,
                        formateur: manager.formateurActif ?? "Formateur"
                    ),
                    retourMenuChapitres: {
                        self.apercu = nil
                        restaurerFocusLecon()
                    },
                    enregistrerProgression: false,
                    prioriserConsigneInitiale: true
                )
            } else if let leconSelectionnee {
                FicheGestionLeconView(
                    lecon: leconSelectionnee,
                    previsualiser: {
                        self.leconSelectionnee = nil
                        apercu = leconSelectionnee
                    },
                    modifier: {
                        self.leconSelectionnee = nil
                        leconEditee = leconSelectionnee
                    },
                    supprimer: {
                        manager.supprimer(leconSelectionnee)
                        self.leconSelectionnee = nil
                        dernierEmplacement = nil
                        placerFocusTitre()
                    },
                    fermer: {
                        self.leconSelectionnee = nil
                        restaurerFocusLecon()
                    }
                )
            } else {
                liste
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .replacerFocusListeLeconsFormateur)
        ) { _ in
            if leconEditee == nil && apercu == nil && leconSelectionnee == nil {
                placerFocusTitre()
            }
        }
    }

    private var liste: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Mes leçons personnalisées")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityRotorEntry(
                        id: EnteteListe.titre,
                        in: espaceEntetes
                    )
                    .accessibilityFocused($elementEnFocus, equals: .titre)

                if manager.lecons.isEmpty {
                    Text("Aucune leçon personnalisée n’a encore été créée.")
                }

                ForEach(groupesLecons) { groupe in
                    Text(groupe.libelleAccessible)
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityRotorEntry(
                            id: EnteteListe.groupe(groupe.id),
                            in: espaceEntetes
                        )

                    ForEach(groupe.lecons) { lecon in
                        let emplacement = EmplacementLeconFormateur(
                            groupeID: groupe.id,
                            leconID: lecon.id
                        )
                        Button(lecon.titre) {
                            dernierEmplacement = emplacement
                            leconSelectionnee = lecon
                        }
                        .accessibilityHint("Ouvre les actions de cette leçon.")
                        .accessibilityFocused(
                            $elementEnFocus,
                            equals: .lecon(emplacement)
                        )
                    }
                }

                Button("Retour à l’espace formateur") { retour() }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(40)
        .frame(minWidth: 720, minHeight: 560, alignment: .topLeading)
        .accessibilityRotor("En-têtes Apprenti Clavier") {
            AccessibilityRotorEntry(
                "Mes leçons personnalisées",
                id: EnteteListe.titre,
                in: espaceEntetes
            )
            ForEach(groupesLecons) { groupe in
                AccessibilityRotorEntry(
                    Text(groupe.libelleAccessible),
                    id: EnteteListe.groupe(groupe.id),
                    in: espaceEntetes
                )
            }
        }
        .onAppear {
            if dernierEmplacement == nil { placerFocusTitre() }
            installerMoniteurEchap()
        }
        .onDisappear {
            retirerMoniteurEchap()
        }
        .onExitCommand { retour() }
    }

    private func installerMoniteurEchap() {
        retirerMoniteurEchap()
        moniteurEchap = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.keyCode == 53 else { return event }
            guard leconEditee == nil, apercu == nil, leconSelectionnee == nil else {
                return event
            }
            retour()
            return nil
        }
    }

    private func retirerMoniteurEchap() {
        if let moniteurEchap {
            NSEvent.removeMonitor(moniteurEchap)
            self.moniteurEchap = nil
        }
    }

    private func placerFocusTitre() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { elementEnFocus = .titre }
    }

    private var groupesLecons: [GroupeLeconsBeneficiaire] {
        var groupes: [GroupeLeconsBeneficiaire] = []

        let sansBeneficiaire = manager.lecons.filter {
            $0.beneficiaires?.isEmpty == true
        }
        if !sansBeneficiaire.isEmpty {
            groupes.append(
                GroupeLeconsBeneficiaire(
                    id: "aucun-beneficiaire",
                    titre: "Aucun bénéficiaire",
                    lecons: sansBeneficiaire
                )
            )
        }

        let tousLesBeneficiaires = manager.lecons.filter {
            $0.beneficiaires == nil
        }
        if !tousLesBeneficiaires.isEmpty {
            groupes.append(
                GroupeLeconsBeneficiaire(
                    id: "tous-les-beneficiaires",
                    titre: "Tous les bénéficiaires",
                    lecons: tousLesBeneficiaires
                )
            )
        }

        let nomsBeneficiaires = Set(
            manager.lecons.flatMap { $0.beneficiaires ?? [] }
        ).sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }

        for nom in nomsBeneficiaires {
            let lecons = manager.lecons.filter {
                ($0.beneficiaires ?? []).contains(nom)
            }
            if !lecons.isEmpty {
                groupes.append(
                    GroupeLeconsBeneficiaire(
                        id: "beneficiaire:\(nom)",
                        titre: nom,
                        lecons: lecons
                    )
                )
            }
        }

        return groupes
    }

    private func restaurerFocusLecon() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let dernierEmplacement else {
                elementEnFocus = .titre
                return
            }

            if let groupe = groupesLecons.first(where: {
                $0.id == dernierEmplacement.groupeID
            }), groupe.lecons.contains(where: {
                $0.id == dernierEmplacement.leconID
            }) {
                elementEnFocus = .lecon(dernierEmplacement)
                return
            }

            if let nouveauGroupe = groupesLecons.first(where: { groupe in
                groupe.lecons.contains(where: {
                    $0.id == dernierEmplacement.leconID
                })
            }) {
                let nouvelEmplacement = EmplacementLeconFormateur(
                    groupeID: nouveauGroupe.id,
                    leconID: dernierEmplacement.leconID
                )
                self.dernierEmplacement = nouvelEmplacement
                elementEnFocus = .lecon(nouvelEmplacement)
            } else {
                self.dernierEmplacement = nil
                elementEnFocus = .titre
            }
        }
    }
}

private struct LeconApprenantActive: Identifiable {
    let id: String
    let nomFormateur: String
    let lecon: LeconPersonnalisee
}

struct LeconsPersonnaliseesApprenantView: View {
    let nomApprenant: String
    let retour: () -> Void
    @ObservedObject private var manager = FormateurManager.shared
    @State private var leconActive: LeconApprenantActive?
    @State private var dernierID: String?
    @State private var moniteurEchap: Any?

    private enum Focus: Hashable { case titre, lecon(String) }
    private enum EnteteLeconsApprenant: Hashable {
        case titre
        case formateur(String)
    }
    @AccessibilityFocusState private var elementEnFocus: Focus?
    @Namespace private var espaceEntetes

    var body: some View {
        Group {
            if let leconActive {
                ReusableLessonView(
                    lesson: definitionPersonnalisee(
                        leconActive.lecon,
                        formateur: leconActive.nomFormateur
                    ),
                    retourMenuChapitres: {
                        self.leconActive = nil
                        restaurerFocusLecon()
                    },
                    enregistrerProgression: false,
                    prioriserConsigneInitiale: true
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Leçons personnalisées")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityRotorEntry(
                                id: EnteteLeconsApprenant.titre,
                                in: espaceEntetes
                            )
                            .accessibilityFocused($elementEnFocus, equals: .titre)

                        if groupesFiltres.isEmpty {
                            Text("Aucune leçon personnalisée ne vous est actuellement proposée.")
                        }

                        ForEach(groupesFiltres) { groupe in
                                let nombre = groupe.lecons.count
                                Text(
                                    nombre == 1
                                        ? "\(groupe.nomFormateur) — 1 leçon"
                                        : "\(groupe.nomFormateur) — \(nombre) leçons"
                                )
                                .font(.title2.bold())
                                .accessibilityAddTraits(.isHeader)
                                .accessibilityRotorEntry(
                                    id: EnteteLeconsApprenant.formateur(groupe.nomFormateur),
                                    in: espaceEntetes
                                )

                                ForEach(groupe.lecons) { lecon in
                                    let identifiant = idLecon(
                                        formateur: groupe.nomFormateur,
                                        lecon: lecon
                                    )
                                    Button(lecon.titre) {
                                        dernierID = identifiant
                                        leconActive = LeconApprenantActive(
                                            id: identifiant,
                                            nomFormateur: groupe.nomFormateur,
                                            lecon: lecon
                                        )
                                    }
                                    .accessibilityLabel(
                                        lecon.objectifPedagogique.map {
                                            lecon.titre + ". "
                                                + $0.descriptionPourApprenant
                                        } ?? lecon.titre
                                    )
                                    .accessibilityHint(
                                        "Appuyez sur VO Espace pour commencer cette leçon."
                                    )
                                    .accessibilityFocused(
                                        $elementEnFocus,
                                        equals: .lecon(identifiant)
                                    )

                                    if let objectif = lecon.objectifPedagogique {
                                        Text(objectif.descriptionPourApprenant)
                                            .font(.callout)
                                            .accessibilityHidden(true)
                                    }
                                }
                            }

                        Button("Retour au menu principal") { retour() }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(40)
                .frame(minWidth: 700, minHeight: 560, alignment: .topLeading)
            }
        }
        .accessibilityRotor("En-têtes Apprenti Clavier") {
            AccessibilityRotorEntry(
                "Leçons personnalisées",
                id: EnteteLeconsApprenant.titre,
                in: espaceEntetes
            )
            ForEach(groupesFiltres) { groupe in
                AccessibilityRotorEntry(
                    Text(
                        groupe.lecons.count == 1
                            ? "\(groupe.nomFormateur) — 1 leçon"
                            : "\(groupe.nomFormateur) — \(groupe.lecons.count) leçons"
                    ),
                    id: EnteteLeconsApprenant.formateur(groupe.nomFormateur),
                    in: espaceEntetes
                )
            }
        }
        .onAppear {
            if dernierID == nil { placerFocusTitre() }
            installerMoniteurEchap()
        }
        .onDisappear {
            retirerMoniteurEchap()
        }
        .onExitCommand {
            if leconActive == nil { retour() }
        }
    }

    private func installerMoniteurEchap() {
        retirerMoniteurEchap()
        moniteurEchap = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.keyCode == 53 else { return event }
            guard leconActive == nil else { return event }
            retour()
            return nil
        }
    }

    private func retirerMoniteurEchap() {
        if let moniteurEchap {
            NSEvent.removeMonitor(moniteurEchap)
            self.moniteurEchap = nil
        }
    }

    private var groupesFiltres: [GroupeLeconsFormateur] {
        manager.groupesLeconsDisponibles(pour: nomApprenant)
    }

    private func idLecon(
        formateur: String,
        lecon: LeconPersonnalisee
    ) -> String {
        formateur + "|" + lecon.id.uuidString
    }

    private func placerFocusTitre() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            elementEnFocus = .titre
        }
    }

    private func restaurerFocusLecon() {
        elementEnFocus = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            if let dernierID {
                elementEnFocus = .lecon(dernierID)
            } else {
                elementEnFocus = .titre
            }
        }
    }
}
