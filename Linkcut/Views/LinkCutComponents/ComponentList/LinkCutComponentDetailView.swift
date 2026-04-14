//
//  LinkCutComponentDetailView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkCutComponentDetailView: View {
    
    @Environment(\.modelContext) private var ctx
    @Bindable var component: LinkCutComponent
    @State private var showEditIcon = false
    @State private var showEditURL = false
    
    @State private var selectedURLText: String = ""
    @State private var urlType: URLType = .app
    
    @State private var error: String?
    @State private var showError = false
    
    var body: some View {
        List {
            iconDisplay
            
            if showEditURL {
                editURLTypeView
            } else {
                urlTypeView
            }
            
            actionButton
        }
        .navigationTitle(component.componentName)
        .sheet(isPresented: $showEditIcon) {
            EditIconView(component: component)
                .presentationDetents([.medium])
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Add Error"),
                message: Text(error ?? "Unkown Error")
            )
        }
    }
    
    // MARK: - urlTypeView
    @ViewBuilder
    private var editURLTypeView: some View {
        VStack {
            URLPicker(
                selectedURLText: $selectedURLText,
                urlType: $urlType
            )
            
            HStack {
                /// Close Button Here
                Button {
                    withAnimation(.snappy) {
                        showEditURL = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button(action: saveAction) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    private var urlTypeView: some View {
        Button(action: {
            selectedURLText = "\(component.url)"
            urlType = component.urlType
            /// Show Selected
            withAnimation(.snappy) {
                showEditURL = true
            }
        }) {
            HStack(alignment: .center) {
                switch component.urlType {
                case .app:
                    Text("\(component.url)")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(.primary)
                    Spacer()
                    urlTypeLabel("App")
                case .appleShortcut:
                    Text(getShortcutName(from: component.url) ?? component.url.path)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(.primary)
                    Spacer()
                    urlTypeLabel("Apple Shortcut")
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func urlTypeLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .padding(.vertical, 2)
            .padding(.horizontal)
            .background {
                Capsule()
                    .fill(.secondary.opacity(0.2))
                    .overlay {
                        Capsule()
                            .fill(.clear)
                            .stroke(
                                .secondary.opacity(0.3),
                                style: .init(lineWidth: 0.5)
                            )
                    }
            }
    }
    
    // MARK: - Icon Display
    private var iconDisplay: some View {
        HStack {
            Spacer()
            /// The Middle Will be The Icon the User uses
            icon
            /// A VStack wont work here cuz it breaks the list for some reason
                .safeAreaInset(edge: .bottom) {
                    changeIcon
                }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var icon: some View {
        switch component.appearance {
        case .color(_):
            if let color = component.color {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 120, height: 120, alignment: .center)
            } else {
                backup
            }
        case .image(_):
            if let image = component.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                backup
            }
        }
    }
    
    private var backup: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.secondary)
            .frame(width: 120, height: 120, alignment: .center)
    }
    
    private var changeIcon: some View {
        Button {
            /// Show Modal To Change Here
            showEditIcon = true
        } label: {
            Text("Change Icon")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background {
                    Capsule()
                        .fill(.clear)
                        .stroke(
                            .secondary,
                            style: .init(lineWidth: 0.5, dash: [4])
                        )
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button {
            UIApplication.shared.open(component.url)
        } label: {
            Text("Test")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
        }
        .buttonStyle(.borderedProminent)
    }
    
    func getShortcutName(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "name" })?.value
    }
    
    private func saveAction() {
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
        
        component.url = selectedURL
        component.urlType = urlType
        
        selectedURLText = ""
        try? ctx.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        withAnimation(.snappy) {
            showEditURL = false
        }
    }
}

#Preview {
    LinkCutComponentDetailView(
        component: LinkCutComponent(
            componentName: "Spotify",
            appearance: ComponentAppearance.color(Color.green.toHex()!),
            url: URL(string: "spotify://")!,
            urlType: .app
        )
    )
}
