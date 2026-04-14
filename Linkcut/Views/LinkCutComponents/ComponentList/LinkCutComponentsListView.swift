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
    
    @State private var selectedComponent: LinkCutComponent?
    
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
                .navigationDestination(item: $selectedComponent) { component in
                    LinkCutComponentDetailView(component: component)
                }
        }
    }
    
    // MARK: - ListView
    
    private var listView: some View {
        ForEach(components) { component in
            Button {
                selectedComponent = component
            } label: {
                LinkCutComponentRow(component: component)
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive, action: { removeAction(item: component) }) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
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
