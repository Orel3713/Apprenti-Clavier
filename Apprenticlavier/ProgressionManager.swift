//
//  ProgressionManager.swift
//  Apprenti Clavier
//

import Foundation
import Combine

final class ProgressionManager: ObservableObject {

    struct StatistiquesVitesse: Codable {
        var caracteresValides: Int = 0
        var dureeTotale: TimeInterval = 0
        var meilleureVitesseMPM: Double = 0

        var vitesseMoyenneMPM: Double {
            guard dureeTotale > 0 else {
                return 0
            }

            let motsNormalises =
                Double(caracteresValides) / 5.0

            return motsNormalises
                / dureeTotale
                * 60.0
        }
    }

    struct ProfilExportable: Codable {
        let version: Int
        let nom: String
        let leconsTerminees: [Int]
        let statistiquesVitesse: StatistiquesVitesse?
        let dateExportation: Date
    }

    enum ErreurProfil: LocalizedError {
        case aucunUtilisateurActif
        case fichierInvalide
        case nomInvalide

        var errorDescription: String? {
            switch self {
            case .aucunUtilisateurActif:
                return "Aucun utilisateur n’est actuellement sélectionné."
            case .fichierInvalide:
                return "Le fichier choisi n’est pas un profil Apprenti Clavier valide."
            case .nomInvalide:
                return "Le profil importé ne contient pas de nom valide."
            }
        }
    }

    static let shared = ProgressionManager()

    @Published private(set) var profilsUtilisateurs: [String] = []
    @Published private(set) var utilisateurActif: String? = nil
    @Published private(set) var leconsTerminees: [Int] = []
    @Published private(set) var statistiquesVitesse =
        StatistiquesVitesse()

    private let cleProfils = "profilsUtilisateurs"
    private let cleUtilisateurActif = "utilisateurActif"
    private let cleProgressions = "progressionsParUtilisateurV2"
    private let cleStatistiquesVitesse =
        "statistiquesVitesseParUtilisateurV1"
    private let cleAncienneProgression = "chapitresTermines"
    private let cleMigrationEffectuee =
        "migrationProgressionParUtilisateurEffectuee"

    private var progressionsParUtilisateur: [String: [Int]] = [:]
    private var statistiquesVitesseParUtilisateur:
        [String: StatistiquesVitesse] = [:]

    private init() {
        chargerDonnees()
    }

    @discardableResult
    func creerEtActiverUtilisateur(_ nom: String) -> Bool {
        let nomNettoye = nettoyerNom(nom)

        guard !nomNettoye.isEmpty else {
            return false
        }

        if let profilExistant = profilCorrespondant(auNom: nomNettoye) {
            activerUtilisateur(profilExistant)
            return true
        }

        let estPremierProfil = profilsUtilisateurs.isEmpty

        profilsUtilisateurs.append(nomNettoye)
        trierProfils()

        if estPremierProfil
            && !UserDefaults.standard.bool(
                forKey: cleMigrationEffectuee
            ) {
            let ancienneProgression =
                UserDefaults.standard.array(
                    forKey: cleAncienneProgression
                ) as? [Int] ?? []

            progressionsParUtilisateur[nomNettoye] =
                ancienneProgression

            UserDefaults.standard.set(
                true,
                forKey: cleMigrationEffectuee
            )
        } else {
            progressionsParUtilisateur[nomNettoye] = []
        }

        statistiquesVitesseParUtilisateur[nomNettoye] =
            StatistiquesVitesse()

        sauvegarderDonnees()
        activerUtilisateur(nomNettoye)
        return true
    }

    func activerUtilisateur(_ nom: String) {
        guard let profil = profilCorrespondant(auNom: nom) else {
            return
        }

        utilisateurActif = profil
        leconsTerminees =
            progressionsParUtilisateur[profil] ?? []
        statistiquesVitesse =
            statistiquesVitesseParUtilisateur[profil]
            ?? StatistiquesVitesse()

        UserDefaults.standard.set(
            profil,
            forKey: cleUtilisateurActif
        )
    }

    func fermerSessionUtilisateur() {
        utilisateurActif = nil
        leconsTerminees = []
        statistiquesVitesse = StatistiquesVitesse()

        UserDefaults.standard.removeObject(
            forKey: cleUtilisateurActif
        )
    }

    @discardableResult
    func supprimerUtilisateurActif() -> String? {
        guard let utilisateur = utilisateurActif else {
            return nil
        }

        profilsUtilisateurs.removeAll {
            $0 == utilisateur
        }

        progressionsParUtilisateur.removeValue(
            forKey: utilisateur
        )
        statistiquesVitesseParUtilisateur.removeValue(
            forKey: utilisateur
        )
        StatistiquesErreursManager.shared.supprimerStatistiques(
            pour: utilisateur
        )

        utilisateurActif = nil
        leconsTerminees = []
        statistiquesVitesse = StatistiquesVitesse()

        UserDefaults.standard.removeObject(
            forKey: cleUtilisateurActif
        )

        sauvegarderDonnees()
        return utilisateur
    }

    func donneesDuProfilActif() throws -> Data {
        guard let utilisateur = utilisateurActif else {
            throw ErreurProfil.aucunUtilisateurActif
        }

        let profil = ProfilExportable(
            version: 2,
            nom: utilisateur,
            leconsTerminees:
                progressionsParUtilisateur[utilisateur] ?? [],
            statistiquesVitesse:
                statistiquesVitesseParUtilisateur[utilisateur],
            dateExportation: Date()
        )

        let encodeur = JSONEncoder()
        encodeur.outputFormatting = [
            .prettyPrinted,
            .sortedKeys
        ]
        encodeur.dateEncodingStrategy = .iso8601

        return try encodeur.encode(profil)
    }

    @discardableResult
    func importerProfil(depuis donnees: Data) throws -> String {
        let decodeur = JSONDecoder()
        decodeur.dateDecodingStrategy = .iso8601

        guard let profil = try? decodeur.decode(
            ProfilExportable.self,
            from: donnees
        ) else {
            throw ErreurProfil.fichierInvalide
        }

        let nomNettoye = nettoyerNom(profil.nom)

        guard !nomNettoye.isEmpty else {
            throw ErreurProfil.nomInvalide
        }

        let nomFinal = nomDisponible(
            aPartirDe: nomNettoye
        )

        let progressionNettoyee = Array(
            Set(
                profil.leconsTerminees.filter {
                    $0 > 0
                }
            )
        ).sorted()

        profilsUtilisateurs.append(nomFinal)
        trierProfils()

        progressionsParUtilisateur[nomFinal] =
            progressionNettoyee
        statistiquesVitesseParUtilisateur[nomFinal] =
            profil.statistiquesVitesse
            ?? StatistiquesVitesse()

        sauvegarderDonnees()

        return nomFinal
    }

    func leconEstTerminee(_ identifiant: Int) -> Bool {
        leconsTerminees.contains(identifiant)
    }

    func leconEstDisponible(_ identifiant: Int) -> Bool {
        if identifiant == 1 {
            return true
        }

        return leconsTerminees.contains(identifiant - 1)
    }

    func enregistrerVitesse(
        caracteresValides: Int,
        duree: TimeInterval
    ) {
        guard let utilisateur = utilisateurActif,
              caracteresValides > 0,
              duree > 0 else {
            return
        }

        let motsNormalises =
            Double(caracteresValides) / 5.0

        let vitesseExercice =
            motsNormalises / duree * 60.0

        statistiquesVitesse.caracteresValides +=
            caracteresValides
        statistiquesVitesse.dureeTotale += duree
        statistiquesVitesse.meilleureVitesseMPM = max(
            statistiquesVitesse.meilleureVitesseMPM,
            vitesseExercice
        )

        statistiquesVitesseParUtilisateur[utilisateur] =
            statistiquesVitesse

        sauvegarderDonnees()
    }

    func terminerLecon(_ identifiant: Int) {
        guard let utilisateur = utilisateurActif else {
            return
        }

        guard !leconsTerminees.contains(identifiant) else {
            return
        }

        leconsTerminees.append(identifiant)
        leconsTerminees.sort()

        progressionsParUtilisateur[utilisateur] =
            leconsTerminees

        sauvegarderDonnees()
    }

    func prochaineLecon(
        dans lecons: [LessonDefinition]
    ) -> LessonDefinition? {
        for lecon in lecons {
            if !leconEstTerminee(lecon.id) {
                return lecon
            }
        }

        return nil
    }

    func reinitialiserProgression() {
        guard let utilisateur = utilisateurActif else {
            return
        }

        leconsTerminees = []
        progressionsParUtilisateur[utilisateur] = []
        statistiquesVitesse = StatistiquesVitesse()
        statistiquesVitesseParUtilisateur[utilisateur] =
            statistiquesVitesse
        StatistiquesErreursManager.shared.supprimerStatistiques(
            pour: utilisateur
        )
        sauvegarderDonnees()
    }

    var nombreLeconsTerminees: Int {
        leconsTerminees.count
    }

    func nombreLeconsTerminees(pour utilisateur: String) -> Int {
        progressionsParUtilisateur[utilisateur]?.count ?? 0
    }

    func statistiquesVitesse(pour utilisateur: String) -> StatistiquesVitesse {
        statistiquesVitesseParUtilisateur[utilisateur] ?? StatistiquesVitesse()
    }

    func nombreLeconsTerminees(
        dans module: ModuleDefinition
    ) -> Int {
        module.lecons.filter {
            leconEstTerminee($0.id)
        }.count
    }

    func pourcentageProgression(
        dans module: ModuleDefinition
    ) -> Int {
        let nombreTotal = module.lecons.count

        guard nombreTotal > 0 else {
            return 0
        }

        let nombreTermine =
            nombreLeconsTerminees(dans: module)

        return Int(
            Double(nombreTermine)
            / Double(nombreTotal)
            * 100.0
        )
    }

    func pourcentageProgression(
        nombreTotalDeLecons: Int
    ) -> Int {
        guard nombreTotalDeLecons > 0 else {
            return 0
        }

        let nombreTermine = min(
            leconsTerminees.count,
            nombreTotalDeLecons
        )

        return Int(
            Double(nombreTermine)
            / Double(nombreTotalDeLecons)
            * 100.0
        )
    }

    var chapitresTermines: [Int] {
        leconsTerminees
    }

    func chapitreEstTermine(_ numero: Int) -> Bool {
        leconEstTerminee(numero)
    }

    func chapitreEstDisponible(_ numero: Int) -> Bool {
        leconEstDisponible(numero)
    }

    func terminerChapitre(_ numero: Int) {
        terminerLecon(numero)
    }

    func prochainChapitreAReprendre(
        nombreTotalDeChapitres: Int
    ) -> Int {
        guard nombreTotalDeChapitres > 0 else {
            return 1
        }

        for numero in 1...nombreTotalDeChapitres {
            if !chapitreEstTermine(numero) {
                return numero
            }
        }

        return nombreTotalDeChapitres
    }

    var nombreChapitresTermines: Int {
        nombreLeconsTerminees
    }

    func pourcentageProgression(
        nombreTotalDeChapitres: Int
    ) -> Int {
        pourcentageProgression(
            nombreTotalDeLecons: nombreTotalDeChapitres
        )
    }

    private func chargerDonnees() {
        let defaults = UserDefaults.standard

        profilsUtilisateurs =
            defaults.stringArray(forKey: cleProfils) ?? []

        if let donnees = defaults.data(
            forKey: cleProgressions
        ) {
            do {
                progressionsParUtilisateur =
                    try JSONDecoder().decode(
                        [String: [Int]].self,
                        from: donnees
                    )
            } catch {
                progressionsParUtilisateur = [:]
            }
        }

        if let donneesVitesse = defaults.data(
            forKey: cleStatistiquesVitesse
        ) {
            do {
                statistiquesVitesseParUtilisateur =
                    try JSONDecoder().decode(
                        [String: StatistiquesVitesse].self,
                        from: donneesVitesse
                    )
            } catch {
                statistiquesVitesseParUtilisateur = [:]
            }
        }

        // À chaque nouveau lancement, l’application revient
        // sur la page d’accueil afin que la personne choisisse
        // explicitement le profil qu’elle souhaite utiliser.
        // Les profils et leurs progressions restent enregistrés.
        utilisateurActif = nil
        leconsTerminees = []
        statistiquesVitesse = StatistiquesVitesse()

        defaults.removeObject(
            forKey: cleUtilisateurActif
        )
    }

    private func nettoyerNom(_ nom: String) -> String {
        nom.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private func profilCorrespondant(
        auNom nom: String
    ) -> String? {
        let nomNettoye = nettoyerNom(nom)

        return profilsUtilisateurs.first { profil in
            profil.compare(
                nomNettoye,
                options: [
                    .caseInsensitive,
                    .diacriticInsensitive
                ]
            ) == .orderedSame
        }
    }

    private func nomDisponible(
        aPartirDe nom: String
    ) -> String {
        if profilCorrespondant(auNom: nom) == nil {
            return nom
        }

        var numero = 2

        while true {
            let proposition =
                "\(nom) importé \(numero)"

            if profilCorrespondant(
                auNom: proposition
            ) == nil {
                return proposition
            }

            numero += 1
        }
    }

    private func trierProfils() {
        profilsUtilisateurs.sort {
            $0.localizedCaseInsensitiveCompare($1)
                == .orderedAscending
        }
    }

    private func sauvegarderDonnees() {
        let defaults = UserDefaults.standard

        defaults.set(
            profilsUtilisateurs,
            forKey: cleProfils
        )

        do {
            let donnees = try JSONEncoder().encode(
                progressionsParUtilisateur
            )

            defaults.set(
                donnees,
                forKey: cleProgressions
            )

            let donneesVitesse = try JSONEncoder().encode(
                statistiquesVitesseParUtilisateur
            )

            defaults.set(
                donneesVitesse,
                forKey: cleStatistiquesVitesse
            )
        } catch {
            print(
                "Erreur de sauvegarde des données : \(error)"
            )
        }
    }
}
