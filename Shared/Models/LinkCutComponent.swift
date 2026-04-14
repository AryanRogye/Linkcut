//
//  LinkCutComponent.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import SwiftData
import SwiftUI

/**
 * This is one individual component inside a LinkCuts group.
 *
 * A component is the actual thing the user can launch.
 *
 * It stores the name, how it should look, the URL to open,
 * and what kind of URL it is.
 *
 * This is what shows up inside a section when the user opens it.
 */
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
