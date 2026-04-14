//
//  LinkCutItem.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

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

@Model
public final class LinkCutComponent {
    public var id: UUID = UUID()
    public var componentName: String
    public var colorHex: String
    public var url: URL
    public var urlType: URLType
    
    public var color: Color {
        .init(hex: colorHex)!
    }
    
    public init?(componentName: String, color: Color, url: URL, urlType: URLType) {
        guard let hex = color.toHex() else { return nil }
        self.url = url
        self.componentName = componentName
        self.colorHex = hex
        self.urlType = urlType
    }
}
