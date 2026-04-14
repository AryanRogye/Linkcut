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

struct LinkCutInfo: TimelineEntry {
    let date: Date
    let components: [LinkCutComponent]?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LinkCutInfo {
        LinkCutInfo(
            date: .now,
            components: nil
        )
    }
    
    func snapshot(
        for configuration: LinkcutAppIntent,
        in context: Context
    ) async -> LinkCutInfo {
        if let item = getLinkCutComponents(linkCutTitle: configuration.linkCutTitle) {
            return LinkCutInfo(
                date: .now,
                components: item
            )
        } else {
            return LinkCutInfo(
                date: .now,
                components: nil
            )
        }
    }
    
    func timeline(
        for configuration: LinkcutAppIntent,
        in context: Context
    ) async -> Timeline<LinkCutInfo> {
        let entry: LinkCutInfo
        if let item = getLinkCutComponents(linkCutTitle: configuration.linkCutTitle) {
            entry = LinkCutInfo(
                date: .now,
                components: item
            )
        } else {
            entry = LinkCutInfo(
                date: .now,
                components: nil
            )
        }
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(1800)))
    }
    
    private func getLinkCutComponents(linkCutTitle: String?) -> [LinkCutComponent]? {
        guard let linkCutTitle else { return nil }
        let items = try? SharedModelContainer.getAllLinkCuts()
        return items?.first(where: { $0.title == linkCutTitle })?.components
    }
}

struct ComponentCard: View {
    var component: LinkCutComponent
    
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
        if let color = component.color {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .stroke(.white, style: .init(lineWidth: 0.5))
        } else if let image = component.image {
            image
        }
    }
}

struct LinkCutWidgetsEntryView: View {
    
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode
    
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
                            .frame(width: size, height: size)
                    }
                }
            } else {
                Text("Please Select A Link Cut")
            }
        }
    }
}

struct LinkCutWidgets: Widget {
    let kind: String = "LinkCutWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LinkcutAppIntent.self,
            provider: Provider()
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
