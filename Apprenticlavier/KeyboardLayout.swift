//
//  KeyboardLayout.swift
//  Apprenti Clavier
//
//  Gestion des dispositions de clavier utilisées dans l’application.
//

import Foundation

enum KeyboardLayout: String, CaseIterable, Codable, Identifiable {

    case azerty
    case qwerty

    var id: String {
        rawValue
    }

    /// Nom affiché dans l’interface.
    var name: String {
        switch self {
        case .azerty:
            return "AZERTY"
        case .qwerty:
            return "QWERTY"
        }
    }

    /// Description utilisée notamment par VoiceOver.
    var accessibilityDescription: String {
        switch self {
        case .azerty:
            return "Clavier français, disposition AZERTY"
        case .qwerty:
            return "Clavier anglais, disposition QWERTY"
        }
    }

    /// Première rangée de lettres.
    var topRowKeys: [String] {
        switch self {
        case .azerty:
            return ["A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P"]
        case .qwerty:
            return ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        }
    }

    /// Rangée de repos.
    var homeRowKeys: [String] {
        switch self {
        case .azerty:
            return ["Q", "S", "D", "F", "G", "H", "J", "K", "L", "M"]
        case .qwerty:
            return ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        }
    }

    /// Rangée inférieure.
    var bottomRowKeys: [String] {
        switch self {
        case .azerty:
            return ["W", "X", "C", "V", "B", "N"]
        case .qwerty:
            return ["Z", "X", "C", "V", "B", "N", "M"]
        }
    }

    /// Touches de repère.
    var leftIndexHomeKey: String {
        "F"
    }

    var rightIndexHomeKey: String {
        "J"
    }
}

