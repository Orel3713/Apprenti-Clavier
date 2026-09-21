import Foundation
import Combine

enum TypeErreurSaisie: String, Codable, CaseIterable {
    case accent = "Accent"
    case ponctuation = "Ponctuation"
    case casse = "Majuscule ou minuscule"
    case caractereManquant = "Caractère manquant"
    case caractereSuperflu = "Caractère en trop"
    case caractereIncorrect = "Caractère incorrect"
}

struct DetailErreurSaisie: Codable, Identifiable {
    var id = UUID()
    var type: TypeErreurSaisie
    var texteAttendu: String
    var texteSaisi: String
    var date: Date
}

struct StatistiqueExercice: Codable, Identifiable {
    var id: String
    var apprenant: String
    var moduleNumero: Int?
    var moduleTitre: String?
    var leconTitre: String
    var leconPersonnaliseeID: UUID?
    var formateur: String?
    var objectifPedagogique: ObjectifPedagogique?
    var exerciceNumero: Int
    var tentatives: Int
    var reussites: Int
    var erreurs: Int
    var erreursParType: [String: Int]
    /// Optionnel afin de relire sans erreur les statistiques créées
    /// par la version précédente de l’application.
    var detailsErreurs: [DetailErreurSaisie]? = nil
    var derniereActivite: Date
}

final class StatistiquesErreursManager: ObservableObject {
    static let shared = StatistiquesErreursManager()

    @Published private(set) var statistiques: [StatistiqueExercice] = []
    private let cle = "statistiquesErreursApprenantsV1"

    private init() {
        guard let donnees = UserDefaults.standard.data(forKey: cle),
              let valeur = try? JSONDecoder().decode([StatistiqueExercice].self, from: donnees) else {
            return
        }
        statistiques = valeur
    }

    func enregistrerTentative(
        apprenant: String,
        lesson: LessonDefinition,
        exerciceNumero: Int,
        saisie: String,
        attendu: String,
        reussie: Bool
    ) {
        let module = ModuleDefinition.tousLesModules.first {
            $0.lecons.contains(where: { $0.id == lesson.id })
        }
        let cleLecon = lesson.identifiantLeconPersonnalisee?.uuidString
            ?? "module-\(module?.id ?? 0)-lecon-\(lesson.id)"
        let id = apprenant.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            + "|" + cleLecon + "|\(exerciceNumero)"

        var valeur = statistiques.first(where: { $0.id == id })
            ?? StatistiqueExercice(
                id: id,
                apprenant: apprenant,
                moduleNumero: module?.id,
                moduleTitre: module?.titre,
                leconTitre: lesson.titre + (lesson.sousTitre.isEmpty ? "" : " — " + lesson.sousTitre),
                leconPersonnaliseeID: lesson.identifiantLeconPersonnalisee,
                formateur: lesson.nomFormateurSource,
                objectifPedagogique: lesson.objectifPedagogique,
                exerciceNumero: exerciceNumero,
                tentatives: 0,
                reussites: 0,
                erreurs: 0,
                erreursParType: [:],
                detailsErreurs: [],
                derniereActivite: Date()
            )

        valeur.tentatives += 1
        valeur.derniereActivite = Date()
        if reussie {
            valeur.reussites += 1
        } else {
            valeur.erreurs += 1
            let type = typeErreur(saisie: saisie, attendu: attendu)
            valeur.erreursParType[type.rawValue, default: 0] += 1
            var details = valeur.detailsErreurs ?? []
            details.append(
                DetailErreurSaisie(
                    type: type,
                    texteAttendu: attendu,
                    texteSaisi: saisie,
                    date: Date()
                )
            )
            valeur.detailsErreurs = details
        }

        if let index = statistiques.firstIndex(where: { $0.id == id }) {
            statistiques[index] = valeur
        } else {
            statistiques.append(valeur)
        }
        sauvegarder()
    }

    func statistiques(pour apprenant: String) -> [StatistiqueExercice] {
        statistiques.filter {
            $0.apprenant.compare(apprenant, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }.sorted {
            if $0.erreurs != $1.erreurs { return $0.erreurs > $1.erreurs }
            return $0.derniereActivite > $1.derniereActivite
        }
    }

    func supprimerStatistiques(pour apprenant: String) {
        statistiques.removeAll {
            $0.apprenant.compare(apprenant, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
        sauvegarder()
    }

    private func typeErreur(saisie: String, attendu: String) -> TypeErreurSaisie {
        if saisie.lowercased() == attendu.lowercased(), saisie != attendu { return .casse }
        let sansAccentsSaisie = saisie.folding(options: .diacriticInsensitive, locale: .current)
        let sansAccentsAttendu = attendu.folding(options: .diacriticInsensitive, locale: .current)
        if sansAccentsSaisie.lowercased() == sansAccentsAttendu.lowercased() { return .accent }

        let lettresEtEspaces = CharacterSet.alphanumerics.union(.whitespaces)
        let saisieSansPonctuation = saisie.unicodeScalars
            .filter { lettresEtEspaces.contains($0) }
            .map(String.init)
            .joined()
        let attenduSansPonctuation = attendu.unicodeScalars
            .filter { lettresEtEspaces.contains($0) }
            .map(String.init)
            .joined()
        if saisieSansPonctuation == attenduSansPonctuation { return .ponctuation }
        if saisie.count < attendu.count { return .caractereManquant }
        if saisie.count > attendu.count { return .caractereSuperflu }
        return .caractereIncorrect
    }

    private func sauvegarder() {
        if let donnees = try? JSONEncoder().encode(statistiques) {
            UserDefaults.standard.set(donnees, forKey: cle)
        }
    }
}
