//
//  LinkCutComponentDetailView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI

struct LinkCutComponentDetailView: View {
    
    @Bindable var component: LinkCutComponent
    @State private var showEditIcon = false
    
    var body: some View {
        List {
            iconDisplay
            
            actionButton
        }
        .navigationTitle(component.componentName)
        .sheet(isPresented: $showEditIcon) {
            EditIconView(component: component)
                .presentationDetents([.medium])
        }
    }
    
    // MARK: - Icon Display
    private var iconDisplay: some View {
        HStack {
            Spacer()
            /// The Middle Will be The Icon the User uses
            VStack {
                icon
                /// Button to change the icon
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
                .font(.system(size: 12, weight: .regular, design: .rounded))
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
            Text("Test")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
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
