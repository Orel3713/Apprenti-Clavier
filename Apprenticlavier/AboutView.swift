import SwiftUI
import AppKit

struct AboutView: View {

    private enum CibleFocus: Hashable {
        case titre
    }

    @AccessibilityFocusState
    private var cibleFocus: CibleFocus?

    private let urlGitHub = URL(
        string: "https://github.com/Orel3713/Apprenti-Clavier"
    )!

    private let urlVersions = URL(
        string: "https://github.com/Orel3713/Apprenti-Clavier/releases"
    )!

    private let urlParc = URL(
        string: "https://github.com/Orel3713/Apprenti-Clavier-Le-Parc-d-attractions"
    )!

    private let urlVersionsParc = URL(
        string: "https://github.com/Orel3713/Apprenti-Clavier-Le-Parc-d-attractions/releases"
    )!

    var body: some View {
        VStack(spacing: 14) {

            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 112)
                .accessibilityLabel(
                    AppInfo.iconAccessibilityLabel
                )

            Text(AppInfo.name)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused(
                    $cibleFocus,
                    equals: .titre
                )

            Text(
                "Version \(AppInfo.version), build \(AppInfo.build)"
            )
            .font(.headline)
            .accessibilityLabel(
                "Version \(AppInfo.version), build \(AppInfo.build)"
            )

            Text(
                "Développé par \(AppInfo.developer)"
            )

            Text(AppInfo.summary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 390)

            Text(AppInfo.accessibilityStatement)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text(
                "Nouvelle implémentation macOS inspirée du projet libre "
                + "ApprentiClavier."
            )
            .font(.footnote)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)

            Text("© 2026 Aurélien Reffay")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel(
                    "Copyright 2026 Aurélien Reffay"
                )

            Text(
                "Publié sous licence GNU GPL version 2."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)

            Text(
                "Contact : contactdevapcb@gmail.com"
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            .accessibilityLabel(
                "Contact, contact dev a p c b, arobase gmail point com"
            )

            Link(
                destination: urlGitHub
            ) {
                Text("Page GitHub d’Apprenti Clavier")
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                "Lien vers la page GitHub d’Apprenti Clavier"
            )
            .accessibilityHint(
                "Ouvre la page d’accueil du dépôt Apprenti Clavier dans votre navigateur"
            )
            .accessibilityAddTraits(.isLink)

            Link(
                "Télécharger les versions d’Apprenti Clavier",
                destination: urlVersions
            )
            .accessibilityLabel(
                "Lien pour télécharger les versions d’Apprenti Clavier"
            )
            .accessibilityHint(
                "Ouvre la page des versions d’Apprenti Clavier dans votre navigateur"
            )
            .accessibilityAddTraits(.isLink)

            Link(
                "Découvrir Apprenti Clavier - Le Parc d’attractions",
                destination: urlParc
            )
            .accessibilityLabel(
                "Lien pour découvrir Apprenti Clavier, Le Parc d’attractions"
            )
            .accessibilityHint(
                "Ouvre la page GitHub d’Apprenti Clavier, Le Parc d’attractions, dans votre navigateur"
            )
            .accessibilityAddTraits(.isLink)

            Link(
                "Télécharger les versions du Parc d’attractions",
                destination: urlVersionsParc
            )
            .accessibilityLabel(
                "Lien pour télécharger les versions d’Apprenti Clavier, Le Parc d’attractions"
            )
            .accessibilityHint(
                "Ouvre la page des versions du Parc d’attractions dans votre navigateur"
            )
            .accessibilityAddTraits(.isLink)

            Button("Fermer") {
                NSApp.keyWindow?.close()
            }
            .keyboardShortcut(.cancelAction)
        }
        .padding(28)
        .frame(width: 480)
        .fixedSize(
            horizontal: false,
            vertical: true
        )
        .onAppear {
            cibleFocus = nil

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.6
            ) {
                cibleFocus = .titre
            }
        }
        .onExitCommand {
            NSApp.keyWindow?.close()
        }
    }
}


