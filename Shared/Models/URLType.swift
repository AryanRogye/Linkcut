//
//  URLType.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

/**
 * The type of url we are adding
 */
public enum URLType: String, CaseIterable, Codable {
    case app
    case appleShortcut
    
    var placeholderName: String {
        switch self {
        case .app:              return "spotify://"
        case .appleShortcut:    return "Shortcut Name"
        }
    }
}
