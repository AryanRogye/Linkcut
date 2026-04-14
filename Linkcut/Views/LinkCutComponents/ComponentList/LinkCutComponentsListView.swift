//
//  LinkCutComponentsListView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkCutComponentsListRow: View {
    
    @Environment(\.modelContext) private var ctx
    @Bindable var component: LinkCutComponent
    
    @State private var error: String?
    @State private var showError = false

    var body: some View {
        NavigationLink(destination: LinkCutComponentDetailView(component: component)) {
            LinkCutComponentRow(component: component)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: { removeAction(item: component) }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(error ?? "Unkown Error")
            )
        }
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

struct LinkCutComponentsEmptyStateView: View {
    var body: some View {
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
}
