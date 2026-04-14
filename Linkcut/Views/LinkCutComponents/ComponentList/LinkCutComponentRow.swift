//
//  LinkCutComponentRow.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI

struct LinkCutComponentRow: View {
    
    @Bindable var component: LinkCutComponent
    
    var componentColor: Color {
        component.color ?? .secondary
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                componentName(component)
                componentURL(component)
            }
            
            Spacer()
            
            componentType(component)
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
            
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
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
                    .fill(componentColor.opacity(0.4))
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
    
    // MARK: - Actions
    
    func getShortcutName(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "name" })?.value
    }
}
