//
//  EditIconView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI
import WidgetKit
import SwiftData

struct EditIconView: View {
    @Environment(\.modelContext) var ctx
    @Bindable var component: LinkCutComponent
    
    @State private var selectedImage: UIImage?
    @State private var selectedColor: Color?
    
    var body: some View {
        VStack {
            Text("Pick an Icon for \(component.componentName)")
            ImageOrColorPicker(
                selectedColor: $selectedColor,
                selectedImage: $selectedImage
            )
            Button {
                let newAppearance: ComponentAppearance
                /// Craft a Color
                if let color = selectedColor {
                    if let hex = color.toHex() {
                        newAppearance = .color(hex)
                    } else {
                        return
                    }
                }
                /// Craft a Image
                else if let image = selectedImage, let data = image.pngData() {
                    newAppearance = .image(data)
                }
                /// Return
                else {
                    return
                }
                component.changeIcon(to: newAppearance)
                try? ctx.save()
                WidgetCenter.shared.reloadAllTimelines()
                
            } label: {
                Text("Change Icon")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .task {
            if let image = component.image {
                selectedImage = image
            } else if let color = component.color {
                selectedColor  = color
            }
        }
    }
}
