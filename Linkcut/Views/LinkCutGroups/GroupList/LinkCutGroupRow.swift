//
//  LinkCutGroupRow.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI

struct LinkCutGroupRow: View {
    
    @Bindable var group: LinkCuts
    
    var componentCount: Int {
        group.components.count
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(group.title)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(.primary)
                Text("\(componentCount) Components")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        LinkCutGroupRow(
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
        LinkCutGroupRow(
            group: LinkCuts(
                title: "Home2",
                items: [LinkCutComponent(
                    componentName: "Spotify",
                    appearance: ComponentAppearance.color(Color.green.toHex()!),
                    url: URL(string: "spotify://")!,
                    urlType: .app
                )]
            )
        )

    }
}
