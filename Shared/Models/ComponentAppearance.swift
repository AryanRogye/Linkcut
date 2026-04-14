//
//  ComponentAppearance.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import Foundation

/// Nonisolated helps gets rid of the warning on the appearance in the LinkCutComponent
nonisolated public enum ComponentAppearance: Codable {
    /// String Hex
    case color(String)
    /// Image Data
    case image(Data)
}
