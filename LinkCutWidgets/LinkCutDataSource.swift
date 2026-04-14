//
//  LinkCutDataSource.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import WidgetKit

/**
 * the data source that feeds the widget view at different moments
 * SwiftUI widget view is still what the user sees, The provider just
 * hands it snapshots of data
 */
struct LinkCutDataSource: AppIntentTimelineProvider {
    
    /**
     * fake preview data
     * Used when:
     * - widget is loading
     * - widget gallery
     * - system needs something instantly
     */
    func placeholder(
        in context: Context
    ) -> LinkCutInfo {
        LinkCutInfo(
            date: .now,
            components: nil
        )
    }
    
    /**
     * previewing widget in gallery
     * quick render situations
     */
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
    
    /**
     * the data over time + when to refresh
     */
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
    
    /**
     * Private Helper to get the link cut components based on the title of the link cut group
     */
    private func getLinkCutComponents(linkCutTitle: String?) -> [LinkCutComponent]? {
        guard let linkCutTitle else { return nil }
        let items = try? SharedModelContainer.getAllLinkCuts()
        return items?.first(where: { $0.title == linkCutTitle })?.components
    }
}
