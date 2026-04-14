//
//  LinkCuts.swift
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
    public var appearance: ComponentAppearance
    public var url: URL
    public var urlType: URLType
    
    public init(componentName: String,
                appearance: ComponentAppearance,
                url: URL,
                urlType: URLType) {
        self.componentName = componentName
        self.appearance = appearance
        self.url = url
        self.urlType = urlType
    }
    
    public func changeIcon(to new: ComponentAppearance) {
        self.appearance = new
    }
}

extension LinkCutComponent {
    var color: Color? {
        if case let .color(hex) = appearance {
            return Color(hex: hex)
        }
        return nil
    }
    
    var image: UIImage? {
        if case let .image(data) = appearance {
            return UIImage(data: data)
        }
        return nil
    }
}

/// Nonisolated helps gets rid of the warning above on the appearance
nonisolated public enum ComponentAppearance: Codable {
    /// String Hex
    case color(String)
    /// Image Data
    case image(Data)
}
