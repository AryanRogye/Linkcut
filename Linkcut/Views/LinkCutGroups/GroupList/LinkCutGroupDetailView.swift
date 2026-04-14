//
//  LinkCutGroupDetailView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import WidgetKit
import SwiftData

struct LinkCutGroupDetailView: View {
    
    @Environment(\.modelContext) private var ctx
    @Query private var components: [LinkCutComponent]
    @Bindable var group: LinkCuts

    private var availableComponents: [LinkCutComponent] {
        components.filter { component in
            !group.components.contains(where: { $0.id == component.id })
        }
    }

    var body: some View {
        List {
            Section {
                currentComponentsCard
            }

            Section("Add Components") {
                availableComponentsSection
            }
        }
    }
    
    private var currentComponentsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(group.title)
                .font(.title)
                .fontWeight(.semibold)

            if group.components.isEmpty {
                Text("This group is empty right now. Add a few components below to build it back up.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(group.components) { component in
                            LinkCutComponentChip(
                                component: component,
                                isSelected: true,
                                trailingSystemImage: "minus.circle.fill",
                                trailingColor: .red,
                                trailingAction: { removeComponent(component) }
                            )
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var availableComponentsSection: some View {
        if components.isEmpty {
            Text("Create a LinkCut Component first, and it’ll show up here ready to add.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else if availableComponents.isEmpty {
            Text("All your components are already in this group.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(availableComponents) { component in
                        LinkCutComponentChip(
                            component: component,
                            trailingSystemImage: "plus.circle.fill",
                            trailingAction: { addComponent(component) }
                        )
                    }
                }
                .padding(.vertical, 2)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }

    private func addComponent(_ component: LinkCutComponent) {
        guard !group.components.contains(where: { $0.id == component.id }) else { return }
        group.add(component)
        try? ctx.save()
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func removeComponent(_ component: LinkCutComponent) {
        group.remove(component)
        try? ctx.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    LinkCutGroupDetailView(
        group: LinkCuts(
            title: "Home",
            items: [
                LinkCutComponent(
                    componentName: "Spotify",
                    appearance: ComponentAppearance.color(Color.green.toHex()!),
                    url: URL(string: "spotify://")!,
                    urlType: .app
                ),
                LinkCutComponent(
                    componentName: "Instagram",
                    appearance: ComponentAppearance.color(Color(.systemPink).toHex()!),
                    url: URL(string: "instagram://")!,
                    urlType: .app
                )
            ]
        )
    )
}
