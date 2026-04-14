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
    public var appearance: ComponentAppearance
    public var url: URL
    public var urlType: URLType
    
    var color: Color? {
        if case let .color(hex) = appearance {
            return Color(hex: hex)
        }
        return nil
    }
    
    var image: Image? {
        if case let .image(data) = appearance,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    public init(componentName: String,
                appearance: ComponentAppearance,
                url: URL,
                urlType: URLType) {
        self.componentName = componentName
        self.appearance = appearance
        self.url = url
        self.urlType = urlType
    }
}

public enum ComponentAppearance: Codable {
    /// String Hex
    case color(String)
    /// Image Data
    case image(Data)
}
