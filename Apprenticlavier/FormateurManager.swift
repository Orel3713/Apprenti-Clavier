import Foundation
import Combine
import CryptoKit

struct FichePersonnalisee: Codable, Identifiable, Equatable {
    var id = UUID()
    var titre: String
    var contenu: String
}

struct ExercicePersonnalise: Codable, Identifiable, Equatable {
    var id = UUID()
    var consigne: String
    var texteAttendu: String
}

enum ObjectifPedagogique: String, Codable, CaseIterable, Identifiable {
    case revisionGenerale
    case module1, module2, module3, module4, module5, module6, module7
    case module8, module9, module10, module11, module12, module13, module14

    var id: String { rawValue }

    var numeroModule: Int? {
        guard rawValue.hasPrefix("module") else { return nil }
        return Int(rawValue.dropFirst("module".count))
    }

    var libelle: String {
        if self == .revisionGenerale { return "Révision générale" }
        guard let numero = numeroModule,
              let module = ModuleDefinition.tousLesModules.first(where: { $0.id == numero }) else {
            return "Module"
        }
        return module.titre.replacingOccurrences(of: " : ", with: " — ")
    }

    var descriptionPourApprenant: String {
        if self == .revisionGenerale {
            return "Objectif pédagogique : réviser et consolider les acquis."
        }
        return "Objectif pédagogique : retravailler les difficultés rencontrées dans le \(libelle)."
    }
}

struct LeconPersonnalisee: Codable, Identifiable, Equatable {
    var id = UUID()
    var titre: String
    var sousTitre: String
    var introduction: String
    var fiches: [FichePersonnalisee]
    var exercices: [ExercicePersonnalise]
    var resumeFinal: String
    /// `nil` signifie que la leçon est destinée à tous les apprenants.
    /// Un tableau, éventuellement vide, contient les profils choisis explicitement.
    var beneficiaires: [String]? = nil
    /// `nil` conserve le comportement des anciennes leçons : aucun objectif affiché.
    var objectifPedagogique: ObjectifPedagogique? = nil
    var dateModification = Date()
}

struct GroupeLeconsFormateur: Identifiable {
    var id: String { nomFormateur }
    let nomFormateur: String
    let lecons: [LeconPersonnalisee]
}

struct ResultatImportationLecons {
    let ajoutees: Int
    let misesAJour: Int
    let dejaPresentes: Int
}

@MainActor
final class FormateurManager: ObservableObject {
    enum ErreurLecons: LocalizedError {
        case fichierInvalide
        case aucuneLecon

        var errorDescription: String? {
            switch self {
            case .fichierInvalide:
                return "Le fichier choisi n’est pas un fichier de leçons Apprenti Clavier valide."
            case .aucuneLecon:
                return "Ce fichier ne contient aucune leçon personnalisée."
            }
        }
    }

    static let shared = FormateurManager()

    @Published private(set) var formateurs: [String] = []
    @Published private(set) var formateurActif: String?
    @Published private(set) var lecons: [LeconPersonnalisee] = []

    func groupesLeconsDisponibles(pour apprenant: String) -> [GroupeLeconsFormateur] {
        leconsParFormateur.compactMap { nomFormateur, collection in
            let visibles = collection.filter { lecon in
                guard let beneficiaires = lecon.beneficiaires else { return true }
                return beneficiaires.contains {
                    $0.compare(
                        apprenant,
                        options: [.caseInsensitive, .diacriticInsensitive]
                    ) == .orderedSame
                }
            }.sorted {
                $0.titre.localizedCaseInsensitiveCompare($1.titre) == .orderedAscending
            }
            guard !visibles.isEmpty else { return nil }
            return GroupeLeconsFormateur(
                nomFormateur: nomFormateur,
                lecons: visibles
            )
        }.sorted {
            $0.nomFormateur.localizedCaseInsensitiveCompare($1.nomFormateur) == .orderedAscending
        }
    }

    func contientDesLeconsDisponibles(pour apprenant: String) -> Bool {
        !groupesLeconsDisponibles(pour: apprenant).isEmpty
    }

    private let cleFormateurs = "profilsFormateursV1"
    private let cleCodes = "codesPINFormateursV1"
    private let cleLeconsParFormateur = "leconsParFormateurV2"
    private let cleAnciennesLecons = "leconsPersonnaliseesV1"

    private var codesPIN: [String: String] = [:]
    private var leconsParFormateur: [String: [LeconPersonnalisee]] = [:]

    private init() {
        formateurs = UserDefaults.standard.stringArray(forKey: cleFormateurs) ?? []
        codesPIN = UserDefaults.standard.dictionary(forKey: cleCodes) as? [String: String] ?? [:]

        if let donnees = UserDefaults.standard.data(forKey: cleLeconsParFormateur),
           let valeur = try? JSONDecoder().decode([String: [LeconPersonnalisee]].self, from: donnees) {
            leconsParFormateur = valeur
        } else if let donnees = UserDefaults.standard.data(forKey: cleAnciennesLecons),
                  let anciennes = try? JSONDecoder().decode([LeconPersonnalisee].self, from: donnees),
                  let premier = formateurs.first, !anciennes.isEmpty {
            leconsParFormateur[premier] = anciennes
            sauvegarderLecons()
        }
    }

    func possedeUnCodePIN(_ nom: String) -> Bool { codesPIN[nom] != nil }

    func nomFormateurExistant(_ nom: String) -> String? {
        let valeur = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return formateurs.first {
            $0.compare(valeur, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
    }

    @discardableResult
    func creerFormateur(nom: String, codePIN: String) -> Bool {
        let valeur = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !valeur.isEmpty, codePIN.count == 4,
              codePIN.allSatisfy({ $0.isNumber }) else { return false }

        let nomFinal: String
        if let existant = nomFormateurExistant(valeur) {
            nomFinal = existant
        } else {
            formateurs.append(valeur)
            formateurs.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
            nomFinal = valeur
        }

        codesPIN[nomFinal] = empreinte(codePIN)
        if leconsParFormateur[nomFinal] == nil { leconsParFormateur[nomFinal] = [] }
        sauvegarderProfils()
        connecterSansVerification(nomFinal)
        return true
    }

    func verifierEtConnecter(_ nom: String, codePIN: String) -> Bool {
        guard codesPIN[nom] == empreinte(codePIN) else { return false }
        connecterSansVerification(nom)
        return true
    }

    @discardableResult
    func modifierCodePINFormateurActif(nouveauCodePIN: String) -> Bool {
        guard let nom = formateurActif,
              nouveauCodePIN.count == 4,
              nouveauCodePIN.allSatisfy({ $0.isNumber }) else { return false }
        codesPIN[nom] = empreinte(nouveauCodePIN)
        sauvegarderProfils()
        return true
    }

    func deconnecter() {
        sauvegarderLeconsActives()
        formateurActif = nil
        lecons = []
    }

    @discardableResult
    func supprimerFormateurActif() -> String? {
        guard let nom = formateurActif else { return nil }
        formateurs.removeAll { $0 == nom }
        codesPIN.removeValue(forKey: nom)
        leconsParFormateur.removeValue(forKey: nom)
        formateurActif = nil
        lecons = []
        sauvegarderProfils()
        return nom
    }

    func enregistrer(_ lecon: LeconPersonnalisee) {
        guard formateurActif != nil else { return }
        var valeur = lecon
        valeur.dateModification = Date()
        if let index = lecons.firstIndex(where: { $0.id == valeur.id }) {
            lecons[index] = valeur
        } else {
            lecons.append(valeur)
        }
        trierEtSauvegarder()
    }

    func supprimer(_ lecon: LeconPersonnalisee) {
        lecons.removeAll { $0.id == lecon.id }
        trierEtSauvegarder()
    }

    func donneesPourExportation() throws -> Data {
        guard !lecons.isEmpty else { throw ErreurLecons.aucuneLecon }
        let encodeur = JSONEncoder()
        encodeur.outputFormatting = [.prettyPrinted, .sortedKeys]
        encodeur.dateEncodingStrategy = .iso8601
        return try encodeur.encode(lecons)
    }

    @discardableResult
    func importer(depuis donnees: Data) throws -> ResultatImportationLecons {
        let decodeur = JSONDecoder()
        decodeur.dateDecodingStrategy = .iso8601
        guard let importees = try? decodeur.decode([LeconPersonnalisee].self, from: donnees) else {
            throw ErreurLecons.fichierInvalide
        }
        guard !importees.isEmpty else { throw ErreurLecons.aucuneLecon }
        guard importees.allSatisfy({ lecon in
            !lecon.titre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !lecon.exercices.isEmpty
            && lecon.exercices.allSatisfy {
                !$0.texteAttendu.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        }) else {
            throw ErreurLecons.fichierInvalide
        }
        var ajoutees = 0
        var misesAJour = 0
        var dejaPresentes = 0

        for lecon in importees {
            if let index = lecons.firstIndex(where: { $0.id == lecon.id }) {
                if lecons[index] == lecon {
                    dejaPresentes += 1
                } else if lecon.dateModification > lecons[index].dateModification {
                    lecons[index] = lecon
                    misesAJour += 1
                } else {
                    // La copie locale est identique ou plus récente : elle ne
                    // doit pas être écrasée par une ancienne exportation.
                    dejaPresentes += 1
                }
            } else {
                lecons.append(lecon)
                ajoutees += 1
            }
        }
        if ajoutees > 0 || misesAJour > 0 {
            trierEtSauvegarder()
        }
        return ResultatImportationLecons(
            ajoutees: ajoutees,
            misesAJour: misesAJour,
            dejaPresentes: dejaPresentes
        )
    }

    private func connecterSansVerification(_ nom: String) {
        formateurActif = nom
        lecons = leconsParFormateur[nom] ?? []
        lecons.sort { $0.titre.localizedCaseInsensitiveCompare($1.titre) == .orderedAscending }
    }

    private func trierEtSauvegarder() {
        lecons.sort { $0.titre.localizedCaseInsensitiveCompare($1.titre) == .orderedAscending }
        sauvegarderLeconsActives()
    }

    private func sauvegarderLeconsActives() {
        guard let nom = formateurActif else { return }
        leconsParFormateur[nom] = lecons
        sauvegarderLecons()
    }

    private func sauvegarderProfils() {
        UserDefaults.standard.set(formateurs, forKey: cleFormateurs)
        UserDefaults.standard.set(codesPIN, forKey: cleCodes)
        sauvegarderLecons()
    }

    private func sauvegarderLecons() {
        if let donnees = try? JSONEncoder().encode(leconsParFormateur) {
            UserDefaults.standard.set(donnees, forKey: cleLeconsParFormateur)
        }
    }

    private func empreinte(_ codePIN: String) -> String {
        SHA256.hash(data: Data(codePIN.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
