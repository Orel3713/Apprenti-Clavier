import Foundation

enum AppInfo {
    static let name = "Apprenti Clavier"
    static var version: String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "1.0"
    }
    static var build: String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? "1"
    }
    static let developer = "Aurélien Reffay"
    static let initialAccessibilityAnnouncement =
        "\(name). Version \(version). Développé par \(developer)."
    static let iconAccessibilityLabel =
        "Logo d’Apprenti Clavier : deux mains au-dessus d’un clavier, avec un œil vert."
    static let summary = "Application d’apprentissage du clavier, accessible aux personnes voyantes et déficientes visuelles."
    static let accessibilityStatement = "Conçu pour être pleinement accessible avec VoiceOver."
    static let copyright = "© 2026 Aurélien Reffay. Tous droits réservés."
}

