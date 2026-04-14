//
//  LinkCutComponentDetailView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI

struct LinkCutComponentDetailView: View {
    
    @Bindable var component: LinkCutComponent
    
    var body: some View {
        List {
            iconDisplay
            
            actionButton
        }
        .navigationTitle(component.componentName)
    }
    
    // MARK: - Icon Display
    private var iconDisplay: some View {
        HStack {
            Spacer()
            /// The Middle Will be The Icon the User uses
            VStack {
                if let color = component.color {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(width: 120, height: 120, alignment: .center)
                } else if let image = component.image {
                    image
                        .frame(width: 120, height: 120, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.secondary)
                        .frame(width: 120, height: 120, alignment: .center)
                }
                /// Button to change the icon
                changeIcon
            }
            Spacer()
        }
    }
    
    private var changeIcon: some View {
        Button {
            /// Show Modal To Change Here
        } label: {
            Text("Change Icon")
                .foregroundStyle(.secondary)
                .padding(4)
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
            Text("Test Component")
        }
        .buttonStyle(.borderedProminent)
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
