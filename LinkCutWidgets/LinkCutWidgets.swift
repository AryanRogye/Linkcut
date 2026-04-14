//
//  LinkCutWidgets.swift
//  LinkCutWidgets
//
//  Created by Aryan Rogye on 4/13/26.
//

import WidgetKit
import SwiftUI
import Foundation
import AppIntents

/**
 * Main Widget
 */
struct LinkCutWidgets: Widget {
    let kind: String = "LinkCutWidgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LinkcutAppIntent.self,
            provider: LinkCutDataSource()
        ) { entry in
            LinkCutWidgetsEntryView(entry: entry)
                .contentMargins(.zero)
                .containerBackground(for: .widget) {
                    Color.black
                }
                .background(.clear)
        }
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            //            .accessoryInline,
            //            .accessoryCircular,
            //            .accessoryRectangular,
        ])
    }
}

struct LinkCutWidgetsEntryView: View {
    
    var entry: LinkCutDataSource.Entry
    @Environment(\.widgetFamily) var family
    
    let size : CGFloat = 50
    
    let columns = [
        GridItem(.adaptive(minimum: 50), spacing: 12)
    ]
    
    var body: some View {
        HStack {
            if let components = entry.components {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(components) { component in
                        ComponentCard(component: component)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            } else {
                Text("Please Select A Link Cut")
            }
        }
    }
}

struct ComponentCard: View {
    var component: LinkCutComponent
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode
    
    var body: some View {
        Group {
            switch component.urlType {
            case .app:
                Link(destination: URL(string: "linkcut://open?itemID=\(component.id.uuidString)")!) {
                    label(component)
                }
            case .appleShortcut:
                Button(intent: OpenLinkIntent(url: component.url)) {
                    label(component)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func label(_ component: LinkCutComponent) -> some View {
        switch component.appearance {
        case .color(_):
            if let color = component.color {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.25), lineWidth: 0.5)
                    )
            } else {
                backup
            }
        case .image(_):
            if let image = component.image {
                Image(uiImage: image)
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                backup
            }
        }
    }
    
    private var backup: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.secondary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.25), lineWidth: 0.5)
            )
    }
}
