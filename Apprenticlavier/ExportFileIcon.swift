import AppKit

/// Applique l’icône d’Apprenti Clavier aux fichiers créés par une exportation.
enum ExportFileIcon {
    static func appliquer(a url: URL) {
        guard let icone = NSApplication.shared.applicationIconImage else { return }
        _ = NSWorkspace.shared.setIcon(icone, forFile: url.path, options: [])
    }
}
