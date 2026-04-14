//
//  AppIntent.swift
//  LinkCutWidgets
//
//  Created by Aryan Rogye on 4/13/26.
//

import WidgetKit
import AppIntents
import SwiftData

/**
 * LinkcutAppIntent is a Configuration, when the user holds on the widget
 * this is the list of options that they will see
 */
struct LinkcutAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "LinkCut Widget Configuration"
    static let description: IntentDescription? = "Make Changes to your LinkCut Widget"
    
    /**
     * This is a dynamic provider as this can differ based on what the user chooses
     * in the main iOS target
     */
    @Parameter(title: "Group", optionsProvider: ShortcutOptionsProvider())
    var linkCutTitle: String?
}

/**
 * Our main iOS Target has a groups array of [LinkCuts]
 * so we search it and return just the titles
 */
struct ShortcutOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let ctx = ModelContext(SharedModelContainer.shared)
        let items = try ctx.fetch(FetchDescriptor<LinkCuts>())
        return items.map(\.title)
    }
}
