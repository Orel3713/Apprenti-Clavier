import AppKit
import SwiftUI

// Les listes AppKit sont séparées des constructeurs SwiftUI pour que macOS 12
// ne construise jamais AccessibilityRotorEntry / WithinAccessibilityRotor.
// Les identifiants sont les mêmes que sur les éléments de l'interface.
struct ACMontereyRotorEntry: Equatable {
    let label: String
    let identifier: String

    init<ID: Hashable>(_ label: String, id: ID, in namespace: Namespace.ID) {
        self.label = label
        self.identifier = acMontereyRotorIdentifier(id, in: namespace)
    }
}

private func acMontereyRotorIdentifier<ID: Hashable>(
    _ id: ID, in namespace: Namespace.ID
) -> String {
    // Préfixer la longueur évite les collisions si un nom de profil contient
    // lui-même un séparateur. Le namespace distingue les fenêtres et les rotors.
    let parts = [String(reflecting: namespace), String(reflecting: ID.self), String(reflecting: id)]
    return "ac.monterey.rotor." + parts.map { "\($0.utf8.count):\($0)" }.joined()
}

@resultBuilder
struct ACMontereyRotorBuilder {
    static func buildExpression(_ entry: ACMontereyRotorEntry) -> [ACMontereyRotorEntry] { [entry] }
    static func buildExpression(_ entries: [ACMontereyRotorEntry]) -> [ACMontereyRotorEntry] { entries }
    static func buildBlock(_ entries: [ACMontereyRotorEntry]...) -> [ACMontereyRotorEntry] { entries.flatMap { $0 } }
    static func buildOptional(_ entries: [ACMontereyRotorEntry]?) -> [ACMontereyRotorEntry] { entries ?? [] }
    static func buildEither(first: [ACMontereyRotorEntry]) -> [ACMontereyRotorEntry] { first }
    static func buildEither(second: [ACMontereyRotorEntry]) -> [ACMontereyRotorEntry] { second }
}

func acMontereyRotorItems<Data: RandomAccessCollection>(
    _ data: Data,
    @ACMontereyRotorBuilder content: (Data.Element) -> [ACMontereyRotorEntry]
) -> [ACMontereyRotorEntry] {
    data.flatMap(content)
}

func acMontereyRotorItems<Data: RandomAccessCollection, ID: Hashable>(
    _ data: Data, id: KeyPath<Data.Element, ID>,
    @ACMontereyRotorBuilder content: (Data.Element) -> [ACMontereyRotorEntry]
) -> [ACMontereyRotorEntry] {
    // L'identité de chaque destination est portée par ACMontereyRotorEntry.
    data.flatMap(content)
}

extension View {
    @ViewBuilder
    func acAccessibilityRotor<Content: AccessibilityRotorContent>(
        _ label: String,
        @ACMontereyRotorBuilder montereyEntries: () -> [ACMontereyRotorEntry],
        @AccessibilityRotorContentBuilder entries: @escaping () -> Content
    ) -> some View {
        if #available(macOS 13.0, *) {
            // Garder le constructeur SwiftUI validé sur les macOS récents.
            self.accessibilityRotor(LocalizedStringKey(label), entries: entries)
        } else {
            self.background(
                ACMontereyRotorBridge(label: label, entries: montereyEntries())
                    .accessibilityHidden(true)
            )
        }
    }

    @ViewBuilder
    func acAccessibilityRotorEntry<ID: Hashable>(
        id: ID, in namespace: Namespace.ID
    ) -> some View {
        if #available(macOS 13.0, *) {
            self.accessibilityRotorEntry(id: id, in: namespace)
        } else {
            // Un identifiant AX standard ne crée aucune relation de rotor SwiftUI.
            self.accessibilityIdentifier(acMontereyRotorIdentifier(id, in: namespace))
        }
    }
}

// La vue technique n'est ni un élément VoiceOver ni un destinataire de clic.
// Le rotor appartient à la fenêtre réelle, ancêtre des éléments SwiftUI.
struct ACMontereyRotorBridge: NSViewRepresentable {
    let label: String
    let entries: [ACMontereyRotorEntry]

    func makeNSView(context: Context) -> ACMontereyRotorInstaller {
        let view = ACMontereyRotorInstaller()
        view.configure(label: label, entries: entries)
        return view
    }

    func updateNSView(_ view: ACMontereyRotorInstaller, context: Context) {
        view.configure(label: label, entries: entries)
    }

    static func dismantleNSView(_ view: ACMontereyRotorInstaller, coordinator: ()) {
        view.detach()
    }
}

final class ACMontereyRotorInstaller: NSView, NSAccessibilityCustomRotorItemSearchDelegate {
    private(set) var entries: [ACMontereyRotorEntry] = []
    private(set) var customRotor: NSAccessibilityCustomRotor?
    private weak var installedWindow: NSWindow?
    private var notificationPending = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setAccessibilityElement(false)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    func configure(label: String, entries: [ACMontereyRotorEntry]) {
        let changed = self.entries != entries || customRotor?.label != label
        self.entries = entries
        if let customRotor {
            customRotor.label = label
        } else {
            customRotor = NSAccessibilityCustomRotor(label: label, itemSearchDelegate: self)
        }
        attach()
        if changed { notifyAfterUpdate() }
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if installedWindow !== newWindow { detach() }
        super.viewWillMove(toWindow: newWindow)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        attach()
    }

    private func attach() {
        guard let window, let customRotor else { return }
        if installedWindow !== window { detach() }
        let existing = window.accessibilityCustomRotors()
        if !existing.contains(where: { $0 === customRotor }) {
            window.setAccessibilityCustomRotors(existing + [customRotor])
            installedWindow = window
            notifyAfterUpdate()
        }
    }

    func detach() {
        if let window = installedWindow, let customRotor {
            window.setAccessibilityCustomRotors(
                window.accessibilityCustomRotors().filter { $0 !== customRotor }
            )
            NSAccessibility.post(element: window, notification: .layoutChanged)
        }
        installedWindow = nil
    }

    private func notifyAfterUpdate() {
        guard !notificationPending else { return }
        notificationPending = true
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.notificationPending = false
            if let window = self.installedWindow {
                NSAccessibility.post(element: window, notification: .layoutChanged)
            }
        }
    }

    func rotor(
        _ rotor: NSAccessibilityCustomRotor,
        resultFor parameters: NSAccessibilityCustomRotor.SearchParameters
    ) -> NSAccessibilityCustomRotor.ItemResult? {
        guard rotor === customRotor, let window = installedWindow,
              window.attachedSheet == nil, !isHiddenOrHasHiddenAncestor else { return nil }
        let targets = Self.accessibleTargets(in: window, identifiers: Set(entries.map(\.identifier)))
        return Self.search(entries: entries, targets: targets, parameters: parameters)
    }

    // Résoudre l'arbre actuel à chaque recherche : aucun pointeur vers un élément
    // SwiftUI supprimé n'est conservé entre deux mises à jour de la vue.
    static func accessibleTargets(
        in root: AnyObject, identifiers: Set<String>
    ) -> [String: NSAccessibilityElementProtocol] {
        var targets: [String: NSAccessibilityElementProtocol] = [:]
        var visited = Set<ObjectIdentifier>()
        var stack: [AnyObject] = [root]
        while let object = stack.popLast() {
            guard visited.insert(ObjectIdentifier(object)).inserted else { continue }
            let accessible = object as? NSAccessibilityProtocol
            guard !(accessible?.isAccessibilityHidden() ?? false) else { continue }
            if let identifier = (object as? NSAccessibilityElementProtocol)?.accessibilityIdentifier?(),
               identifiers.contains(identifier), targets[identifier] == nil,
               let target = NSAccessibility.unignoredDescendant(of: object) as? NSAccessibilityElementProtocol {
                targets[identifier] = target
            }
            // Ne pas limiter aux enfants visibles : les titres hors de la zone
            // défilée doivent aussi être proposés. Les vues utilisent des VStack.
            let children: [Any]
            if let accessible {
                children = accessible.accessibilityChildren() ?? []
            } else if let node = object as? NSObject,
                      node.responds(to: #selector(NSAccessibilityProtocol.accessibilityChildren)) {
                // Les nœuds SwiftUI implémentent ce sélecteur public sans déclarer
                // leur conformité au protocole NSAccessibility complet.
                children = node.perform(#selector(NSAccessibilityProtocol.accessibilityChildren))?
                    .takeUnretainedValue() as? [Any] ?? []
            } else {
                children = []
            }
            stack.append(contentsOf: children.reversed().map { $0 as AnyObject })
            // AppKit peut exposer la cellule d’un bouton dans AXChildren, mais
            // porter son identifiant sur le NSButton ignoré. Inspecter aussi
            // les vues permet de résoudre ce cas vers sa cellule accessible.
            if let view = object as? NSView {
                stack.append(contentsOf: view.subviews.reversed())
            }
        }
        return targets
    }

    static func search(
        entries: [ACMontereyRotorEntry],
        targets: [String: NSAccessibilityElementProtocol],
        parameters: NSAccessibilityCustomRotor.SearchParameters
    ) -> NSAccessibilityCustomRotor.ItemResult? {
        let currentIdentifier = parameters.currentItem?.targetElement?.accessibilityIdentifier?()
        let currentTarget = parameters.currentItem?.targetElement
        let currentIndex = entries.firstIndex { entry in
            entry.identifier == currentIdentifier || (currentTarget != nil &&
                targets[entry.identifier] === currentTarget)
        }
        let forward = parameters.searchDirection == .next
        let indices = forward ? Array(entries.indices) : Array(entries.indices.reversed())
        for index in indices {
            if let currentIndex, forward ? index <= currentIndex : index >= currentIndex { continue }
            let entry = entries[index]
            guard parameters.filterString.isEmpty || entry.label.range(
                of: parameters.filterString, options: [.caseInsensitive, .diacriticInsensitive],
                locale: .current
            ) != nil, let target = targets[entry.identifier] else { continue }
            let result = NSAccessibilityCustomRotor.ItemResult(targetElement: target)
            result.customLabel = entry.label
            return result
        }
        return nil
    }
}
