//
//  LinkCutComponentsListView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkCutComponentsListView: View {
    
    @Environment(\.modelContext) var ctx
    @Query var components: [LinkCutComponent]
    
    @State private var error: String?
    @State private var showError = false
    
    var body: some View {
        if components.isEmpty {
            emptyState
        } else {
            listView
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(error ?? "Unkown Error")
                    )
                }
        }
    }
    
    // MARK: - ListView
    
    private var listView: some View {
        ForEach(components) { component in
            Button {
                UIApplication.shared.open(component.url)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        componentName(component)
                        componentURL(component)
                    }
                    
                    Spacer()
                    
                    componentType(component)
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
    
    // MARK: - Component Type
    
    private func componentType(_ component: LinkCutComponent) -> some View {
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
    
    // MARK: - Component URL
    
    private func componentURL(_ component: LinkCutComponent) -> some View {
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
    
    // MARK: - Component Name
    
    private func componentName(_ component: LinkCutComponent) -> some View {
        Text(component.componentName)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
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
    }
    
    // MARK: - Actions
    
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
}
