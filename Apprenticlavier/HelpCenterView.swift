//
//  HelpCenterView.swift
//

import SwiftUI
import AppKit

struct HelpCenterView: View {

    @AccessibilityFocusState
    private var titreALeFocus: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            Text("Centre d’aide")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($titreALeFocus)

            Text("Choisissez le document que vous souhaitez consulter.")

            GroupBox("Documentation") {
                VStack(alignment: .leading, spacing: 12) {

                    Button("Guide utilisateur – Apprenti Clavier") {
                        ouvrirDocument(
                            nom: "Guide_utilisateur_Apprenti_Clavier",
                            extensionFichier: "html"
                        )
                    }

                    Button("Notes de version") {
                        ouvrirDocument(
                            nom: "Notes_de_version_Apprenti_Clavier",
                            extensionFichier: "pdf"
                        )
                    }

                    Button("Remerciements") {
                        ouvrirDocument(
                            nom: "Remerciements_Apprenti_Clavier",
                            extensionFichier: "pdf"
                        )
                    }
                }
                .padding(.vertical, 6)
            }

            GroupBox("Licence") {
                VStack(alignment: .leading, spacing: 12) {

                    Button("GNU GPL version 2 (texte officiel)") {
                        ouvrirDocument(
                            nom: "gpl",
                            extensionFichier: "txt"
                        )
                    }

                    Button("GNU GPL version 2 (traduction française)") {
                        ouvrirDocument(
                            nom: "gpl-fr",
                            extensionFichier: "txt"
                        )
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .padding(28)
        .frame(minWidth: 520, minHeight: 420)
        .onAppear {
            titreALeFocus = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                titreALeFocus = true
            }
        }
        .onExitCommand {
            NSApp.keyWindow?.close()
        }
    }

    private func ouvrirDocument(nom: String, extensionFichier: String) {
        guard let url = Bundle.main.url(forResource: nom, withExtension: extensionFichier) else {
            let alerte = NSAlert()
            alerte.messageText = "Document introuvable"
            alerte.informativeText = "Le document demandé n’est pas présent dans les ressources de l’application."
            alerte.runModal()
            return
        }
        NSWorkspace.shared.open(url)
    }
}

