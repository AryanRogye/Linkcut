//
//  LinkCuts.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

/**
 * This is basically the main thing of the app.
 *
 * A LinkCuts is just a group of components.
 *
 * You can make as many components as you want (apps, shortcuts, links),
 * then group them into sections.
 *
 * Each section shows up on the home screen, and when you open it,
 * you see all the components inside and can launch them individually.
 */
@Model
public final class LinkCuts {
    public var title: String
    public var components: [LinkCutComponent]
    
    init(title: String) {
        self.title = title
        self.components = []
    }
    init(title: String, items: [LinkCutComponent]) {
        self.title = title
        self.components = items
    }
    
    public func add(_ item: LinkCutComponent) {
        components.append(item)
    }
    public func remove(_ item: LinkCutComponent) {
        components.removeAll(where: { $0.id == item.id })
    }
}
