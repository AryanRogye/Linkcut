//
//  AppIntent.swift
//  LinkCutWidgets
//
//  Created by Aryan Rogye on 4/13/26.
//

import WidgetKit
import AppIntents
import SwiftData

struct LinkcutAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "LinkCut Widget Configuration"
    static let description: IntentDescription? = "Make Changes to your LinkCut Widget"
    
    @Parameter(title: "Shortcut", optionsProvider: ShortcutOptionsProvider())
    var linkCutTitle: String?
}

struct ShortcutOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let ctx = ModelContext(SharedModelContainer.shared)
        let items = try ctx.fetch(FetchDescriptor<LinkCuts>())
        return items.map(\.title)
    }
}
