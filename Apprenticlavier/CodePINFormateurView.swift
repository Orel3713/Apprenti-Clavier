import SwiftUI
import AppKit

struct ContexteCodePIN: Identifiable {
    enum Mode: Equatable { case creation, connexion, modification }
    let id = UUID()
    let nomFormateur: String
    let mode: Mode
}

struct CodePINFormateurView: View {
    let contexte: ContexteCodePIN
    let terminer: () -> Void
    let annuler: () -> Void

    @ObservedObject private var manager = FormateurManager.shared
    @State private var chiffres = Array(repeating: "", count: 4)
    @State private var confirmation = Array(repeating: "", count: 4)
    @State private var masquerLeCode = false
    @State private var messageErreur = ""
    @State private var moniteurEffacement: Any?
    @State private var generationSaisie = 0

    private enum Champ: Hashable {
        case code(Int)
        case confirmation(Int)
    }

    @FocusState private var champClavier: Champ?
    @AccessibilityFocusState private var titreEnFocus: Bool
    @AccessibilityFocusState private var champVoiceOver: Champ?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(titre)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($titreEnFocus)

            Text(explication)

            Text("Code PIN à 4 chiffres")
                .font(.headline)
            rangeeCode(estConfirmation: false)

            if contexte.mode == .creation || contexte.mode == .modification {
                Text("Confirmez le code PIN")
                    .font(.headline)
                rangeeCode(estConfirmation: true)
            }

            Button {
                masquerLeCode.toggle()
            } label: {
                Label(
                    masquerLeCode ? "Afficher le code PIN" : "Masquer le code PIN",
                    systemImage: masquerLeCode ? "eye.slash" : "eye"
                )
            }
            .accessibilityLabel(
                masquerLeCode ? "Afficher le code PIN" : "Masquer le code PIN"
            )

            if !messageErreur.isEmpty {
                Text(messageErreur)
                    .foregroundColor(.red)
                    .accessibilityLabel(messageErreur)
            }

            HStack {
                Spacer()
                Button("Annuler") { annuler() }
            }
        }
        .padding(28)
        .frame(width: 470)
        .onAppear {
            titreEnFocus = false
            installerGestionEffacement()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                titreEnFocus = true
            }
        }
        .onDisappear { retirerGestionEffacement() }
        .onExitCommand { annuler() }
    }

    private var titre: String {
        switch contexte.mode {
        case .creation:
            return "Créer un code PIN"
        case .connexion:
            return "Connexion de \(contexte.nomFormateur)"
        case .modification:
            return "Modifier mon code PIN"
        }
    }

    private var explication: String {
        switch contexte.mode {
        case .creation:
            return "Ce code PIN vous sera demandé chaque fois que vous accéderez à votre espace formateur. La création sera automatique après la saisie du quatrième chiffre de confirmation."
        case .connexion:
            return "Saisissez le code PIN à quatre chiffres associé à votre profil formateur. La connexion sera automatique après le quatrième chiffre."
        case .modification:
            return "Saisissez votre nouveau code PIN à quatre chiffres, puis confirmez-le. La modification sera automatique après le quatrième chiffre de confirmation."
        }
    }

    private func rangeeCode(estConfirmation: Bool) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                Group {
                    if masquerLeCode {
                        SecureField("", text: liaison(index: index, confirmation: estConfirmation))
                    } else {
                        TextField("", text: liaison(index: index, confirmation: estConfirmation))
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(width: 46)
                .focused(
                    $champClavier,
                    equals: estConfirmation ? .confirmation(index) : .code(index)
                )
                .accessibilityLabel(
                    estConfirmation
                        ? "Confirmation, chiffre \(index + 1) sur 4"
                        : "Code PIN, chiffre \(index + 1) sur 4"
                )
                .accessibilityHint("Champ de saisie. Saisissez un chiffre.")
                .accessibilityFocused(
                    $champVoiceOver,
                    equals: estConfirmation ? .confirmation(index) : .code(index)
                )
            }
        }
    }

    private func liaison(index: Int, confirmation estConfirmation: Bool) -> Binding<String> {
        Binding(
            get: {
                estConfirmation ? confirmation[index] : chiffres[index]
            },
            set: { nouvelleValeur in
                distribuer(
                    nouvelleValeur.filter { $0.isNumber },
                    depuis: index,
                    confirmation: estConfirmation
                )
            }
        )
    }

    private func distribuer(_ valeur: String, depuis index: Int, confirmation estConfirmation: Bool) {
        generationSaisie += 1
        let generation = generationSaisie
        guard !valeur.isEmpty else {
            if estConfirmation { confirmation[index] = "" } else { chiffres[index] = "" }
            return
        }

        var position = index
        for caractere in valeur.prefix(4 - index) {
            if estConfirmation {
                confirmation[position] = String(caractere)
            } else {
                chiffres[position] = String(caractere)
            }
            position += 1
        }

        let annonce = valeur.prefix(4 - index).map {
            masquerLeCode ? "point" : String($0)
        }.joined(separator: ", ")
        let positionFinale = position
        VoiceOverAnnouncer.annoncerTexte(annonce)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            guard generation == generationSaisie else { return }
            if positionFinale < 4 {
                let suivant: Champ = estConfirmation
                    ? .confirmation(positionFinale)
                    : .code(positionFinale)
                champClavier = suivant
                champVoiceOver = suivant
            } else {
                champClavier = nil
                verifierRangeeTerminee(estConfirmation: estConfirmation)
            }
        }
    }

    private func verifierRangeeTerminee(estConfirmation: Bool) {
        let code = chiffres.joined()
        guard code.count == 4 else { return }

        if contexte.mode == .creation || contexte.mode == .modification {
            if !estConfirmation {
                champClavier = .confirmation(0)
                champVoiceOver = .confirmation(0)
                return
            }

            let secondCode = confirmation.joined()
            guard secondCode.count == 4 else { return }
            guard code == secondCode else {
                messageErreur = "Les deux codes PIN ne correspondent pas. Saisissez-les de nouveau."
                chiffres = Array(repeating: "", count: 4)
                confirmation = Array(repeating: "", count: 4)
                VoiceOverAnnouncer.annoncerTexte(messageErreur)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    champClavier = .code(0)
                    champVoiceOver = .code(0)
                }
                return
            }

            let reussite: Bool
            if contexte.mode == .creation {
                reussite = manager.creerFormateur(nom: contexte.nomFormateur, codePIN: code)
            } else {
                reussite = manager.modifierCodePINFormateurActif(nouveauCodePIN: code)
            }
            if reussite { terminer() }
        } else {
            if manager.verifierEtConnecter(contexte.nomFormateur, codePIN: code) {
                terminer()
            } else {
                messageErreur = "Code PIN incorrect. Saisissez-le de nouveau."
                chiffres = Array(repeating: "", count: 4)
                VoiceOverAnnouncer.annoncerTexte(messageErreur)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    champClavier = .code(0)
                    champVoiceOver = .code(0)
                }
            }
        }
    }

    private func installerGestionEffacement() {
        guard moniteurEffacement == nil else { return }
        moniteurEffacement = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { evenement in
            guard evenement.keyCode == 51,
                  evenement.modifierFlags.intersection([.command, .control, .option]).isEmpty,
                  effacerChiffrePrecedentSiNecessaire() else {
                return evenement
            }
            return nil
        }
    }

    private func retirerGestionEffacement() {
        if let moniteurEffacement {
            NSEvent.removeMonitor(moniteurEffacement)
            self.moniteurEffacement = nil
        }
    }

    private func effacerChiffrePrecedentSiNecessaire() -> Bool {
        guard let champClavier else { return false }
        generationSaisie += 1

        switch champClavier {
        case .code(let index):
            guard chiffres[index].isEmpty, index > 0 else { return false }
            chiffres[index - 1] = ""
            let precedent = Champ.code(index - 1)
            self.champClavier = precedent
            champVoiceOver = precedent

        case .confirmation(let index):
            guard confirmation[index].isEmpty, index > 0 else { return false }
            confirmation[index - 1] = ""
            let precedent = Champ.confirmation(index - 1)
            self.champClavier = precedent
            champVoiceOver = precedent
        }

        VoiceOverAnnouncer.annoncerTexte("Chiffre effacé")
        return true
    }
}
