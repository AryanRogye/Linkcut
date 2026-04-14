//
//  LinkCutComponentChip.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI

struct LinkCutComponentChip: View {

    @Bindable var component: LinkCutComponent
    var isSelected: Bool = false
    var trailingSystemImage: String?
    var trailingColor: Color?
    var trailingAction: () -> Void = {}

    var body: some View {
        let accentColor = component.color ?? .secondary

        HStack(spacing: 8) {
            Circle()
                .fill(accentColor)
                .frame(width: 10, height: 10)

            Text(component.componentName)
                .font(.subheadline)

            if let trailingSystemImage {
                Button(action: trailingAction) {
                    Image(systemName: trailingSystemImage)
                        .foregroundStyle(trailingColor ?? accentColor)
                }
                .buttonStyle(.plain)
            } else if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(accentColor)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isSelected ? accentColor.opacity(0.18) : Color.secondary.opacity(0.08))
        )
        .overlay(
            Capsule()
                .stroke(isSelected ? accentColor : Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        LinkCutComponentChip(
            component: LinkCutComponent(
                componentName: "Spotify",
                appearance: ComponentAppearance.color(Color.green.toHex()!),
                url: URL(string: "spotify://")!,
                urlType: .app
            )
        )

        LinkCutComponentChip(
            component: LinkCutComponent(
                componentName: "Spotify",
                appearance: ComponentAppearance.color(Color.green.toHex()!),
                url: URL(string: "spotify://")!,
                urlType: .app
            ),
            isSelected: true
        )
    }
    .padding()
}
