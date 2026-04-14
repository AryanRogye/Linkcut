//
//  LinkCutComponentAddView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

struct LinkCutComponentAddView: View {
    
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
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Add Error"),
                message: Text(error ?? "Unkown Error")
            )
        }
    }
    
    // MARK: - URL Picker
    
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
    
    // MARK: - Actions
    
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
