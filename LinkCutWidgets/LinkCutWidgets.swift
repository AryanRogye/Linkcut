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
    let linkCutItem: LinkCutComponent?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LinkCutInfo {
        LinkCutInfo(
            date: .now,
            linkCutItem: nil
        )
    }
    
    func snapshot(
        for configuration: LinkcutAppIntent,
        in context: Context
    ) async -> LinkCutInfo {
        if let item = getLinkCutItem(componentName: configuration.componentName) {
            return LinkCutInfo(
                date: .now,
                linkCutItem: item
            )
        } else {
            return LinkCutInfo(
                date: .now,
                linkCutItem: nil
            )
        }
    }
    
    func timeline(
        for configuration: LinkcutAppIntent,
        in context: Context
    ) async -> Timeline<LinkCutInfo> {
        let entry: LinkCutInfo
        if let item = getLinkCutItem(componentName: configuration.componentName) {
            entry = LinkCutInfo(
                date: .now,
                linkCutItem: item
            )
        } else {
            entry = LinkCutInfo(
                date: .now,
                linkCutItem: nil
            )
        }
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(1800)))
    }
    
    private func getLinkCutItem(componentName: String?) -> LinkCutComponent? {
        guard let componentName else { return nil }
        let items = try? SharedModelContainer.getAllShortcutItems()
        return items?.first(where: { $0.componentName == componentName })
    }
}

struct LinkCutWidgetsEntryView: View {
    
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode
    
    var body: some View {
        HStack {
            if let component = entry.linkCutItem {
                VStack {
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

                    Text("\(component.componentName)")
                }
            } else {
                Text("Please Select A Link Cut")
            }
        }
    }
    
    private func label(_ component: LinkCutComponent) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.clear)
            .stroke(.white, style: .init(lineWidth: 0.5))
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
                    if let color = entry.linkCutItem?.color {
                        return color
                    }
                    return .black
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
