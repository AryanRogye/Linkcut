//
//  LinkCutGroupAddView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//


import SwiftUI
import SwiftData

struct LinkCutGroupAddView: View {
    
    @Environment(\.modelContext) var ctx
    @Query var components: [LinkCutComponent]
    @Query var groups: [LinkCuts]
    
    @State private var groupTitle: String = ""
    @State private var selectedComponentIDs: Set<UUID> = []
    
    private var addDisabled: Bool {
        groupTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedComponentIDs.isEmpty
    }
    
    private var selectedComponents: [LinkCutComponent] {
        components.filter { selectedComponentIDs.contains($0.id) }
    }

    var body: some View {
        VStack {
            TextField("Group Title", text: $groupTitle)
            
            Divider().padding(.horizontal, -16)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Components")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if components.isEmpty {
                    componentsEmptyState
                } else {
                    componentsList
                }
            }
            .padding(.vertical, 10)
            
            Divider().padding(.horizontal, -16)
            
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
    
    // MARK: - Components List
    
    private var componentsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(components) { component in
                    let isSelected = selectedComponentIDs.contains(component.id)
                    
                    Button {
                        toggleSelection(component)
                    } label: {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(component.color)
                                .frame(width: 10, height: 10)
                            
                            Text(component.componentName)
                                .font(.subheadline)
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(component.color)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? component.color.opacity(0.18) : Color.secondary.opacity(0.08))
                        )
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? component.color : Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    // MARK: - Components Empty State
    
    private var componentsEmptyState: some View {
        HStack(spacing: 10) {
            Image(systemName: "square.stack.3d.up")
                .foregroundStyle(.secondary)
            
            Text("Create your first LinkCut Component, and it’ll show up here ready to join a group.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
    
    // MARK: - Actions
    
    private func toggleSelection(_ component: LinkCutComponent) {
        if selectedComponentIDs.contains(component.id) {
            selectedComponentIDs.remove(component.id)
        } else {
            selectedComponentIDs.insert(component.id)
        }
    }
    
    private func addAction() {
        let group = LinkCuts(title: groupTitle.trimmingCharacters(in: .whitespacesAndNewlines), items: selectedComponents)
        ctx.insert(group)
        try? ctx.save()
        
        groupTitle = ""
        selectedComponentIDs.removeAll()
    }
}
