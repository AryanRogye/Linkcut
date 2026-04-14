//
//  LinkCutComponentsView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkCutComponentsView: View {

    @Environment(\.modelContext) var ctx
    @Query var components: [LinkCutComponent]

    @State private var componentName: String = ""
    @State private var selectedURLText: String = ""
    @State private var selectedColor: Color = .blue
    @State private var urlType: URLType = .app

    @State private var error: String?
    @State private var showError = false

    @FocusState private var focusURL: Bool

    var addDisabled: Bool {
        return componentName.trimmingCharacters(
            in: .whitespaces
        ).isEmpty || selectedURLText.trimmingCharacters(
            in: .whitespaces
        ).isEmpty
    }

    var body: some View {
        List {
            Section("New") {
                addSection
            }

            Section("Saved") {
                listView
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(error ?? "Unkown Error")
            )
        }
    }

    private var addSection: some View {
        VStack {
            /// Shortcut Name
            TextField("Component Name", text: $componentName)

            Divider().padding(.horizontal, -16)

            /// Color Picker
            ColorPicker("Color", selection: $selectedColor, supportsOpacity: false)
                .padding(.vertical, 4)

            Divider().padding(.horizontal, -16)

            /// URL Picker
            urlPicker

            Divider().padding(.horizontal, -16)

            /// Add Action
            Button(action: addAction) {
                Label("Add", systemImage: "plus")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .disabled(addDisabled)
            .padding(.top, 6)
        }
    }

    private var urlPicker: some View {
        HStack {
            TextField(urlType.placeholderName, text: $selectedURLText)
                .focused($focusURL)
                .frame(maxWidth: .infinity)
            Picker("", selection: $urlType) {
                ForEach(URLType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .fixedSize()
            .pickerStyle(.menu)
            .tint(.secondary)
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var listView: some View {
        if components.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(.secondary)

                Text("Your items will appear here once added.")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Your items will appear here once added.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding()
        } else {
            ForEach(components) { component in
                Button {
                    UIApplication.shared.open(component.url)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(component.componentName)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            
                            Group {
                                switch component.urlType {
                                case .app:
                                    Text("Open \(component.url)")
                                case .appleShortcut:
                                    Text("Run \(getShortcutName(from: component.url), default: "Unknown") Shortcut")
                                }
                            }
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        }

                        Spacer()

                        Text(component.urlType.rawValue)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(component.color.opacity(0.5))
                            )
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive, action: { removeAction(item: component) }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    func getShortcutName(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "name" })?.value
    }

    private func removeAction(item: LinkCutComponent) {
        ctx.delete(item)
        do {
            try ctx.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            self.error = error.localizedDescription
            showError = true
        }
    }

    private func addAction() {
        guard !componentName.isEmpty else {
            error = "Please enter a component name"
            showError = true
            return
        }
        guard !selectedURLText.isEmpty else {
            error = "Please enter a url"
            showError = true
            return
        }
        let urlText: String
        switch urlType {
        case .app:
            urlText = selectedURLText
        case .appleShortcut:
            urlText = "shortcuts://run-shortcut?name=\(selectedURLText)"
        }
        guard let selectedURL = URL(string: urlText) else {
            error = "Please Select a Valid URL"
            showError = true
            return
        }
        /// make sure the same name doesnt exist
        if components.contains(where: { $0.componentName == componentName }) {
            error = "A component with that name already exists"
            showError = true
            return
        }
        if let item = LinkCutComponent(
            componentName: componentName,
            color: selectedColor,
            url: selectedURL,
            urlType: urlType
        ) {
            ctx.insert(item)
            // Reset inputs
            componentName = ""
        }
    }
}

#Preview {
    LinkCutComponentsView()
}
