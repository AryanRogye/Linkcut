//
//  ImageOrColorPicker.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI
import PhotosUI

struct ImageOrColorPicker: View {
    
    @Binding var selectedColor: Color?
    @Binding var selectedImage: UIImage?

    @State private var selectedPhotoItem: PhotosPickerItem?

    private var colorSelection: Binding<Color> {
        Binding {
            selectedColor ?? .blue
        } set: { newColor in
            selectedColor = newColor
            selectedImage = nil
            selectedPhotoItem = nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                preview

                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedImage == nil ? "Using Color" : "Using Image")
                        .font(.headline)

                    Text(selectedImage == nil ? "Pick a color, or choose an image instead." : "Picking a color will replace the image.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            ColorPicker("Color", selection: colorSelection, supportsOpacity: false)
                .padding(.vertical, 4)

            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Label(selectedImage == nil ? "Choose Image" : "Choose Different Image", systemImage: "photo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .task(id: selectedPhotoItem) {
                await loadSelectedImage()
            }
        }
    }

    @ViewBuilder
    private var preview: some View {
        Group {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedColor ?? .blue)
            }
        }
        .frame(width: 54, height: 54)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.3), lineWidth: 0.5)
        )
    }

    private func loadSelectedImage() async {
        guard let selectedPhotoItem,
              let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            return
        }

        await MainActor.run {
            selectedImage = image
            selectedColor = nil
        }
    }
}
