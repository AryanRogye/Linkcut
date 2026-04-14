//
//  URLPicker.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftUI

struct URLPicker: View {
    
    @Binding var selectedURLText: String
    @Binding var urlType : URLType
    
    var body: some View {
        HStack {
            TextField(urlType.placeholderName, text: $selectedURLText)
                .frame(maxWidth: .infinity)
            Picker("", selection: $urlType) {
                ForEach(URLType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .fixedSize()
            .pickerStyle(.menu)
            .tint(.secondary)
        }
        .padding(.vertical, 4)
    }
}
