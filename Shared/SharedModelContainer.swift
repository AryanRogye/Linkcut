//
//  SharedModelContainer.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftData
import Foundation

enum SharedModelContainer {
    static let groupID = "group.com.aryan.linkcut"
    
    static var shared: ModelContainer = {
        let schema = Schema([LinkCutComponent.self])
        
        let configuration = ModelConfiguration(
            schema: schema,
            groupContainer: .identifier(groupID)
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create shared ModelContainer: \(error)")
        }
    }()
    
    public static func getAllShortcutItems() throws -> [LinkCutComponent] {
        let ctx = ModelContext(Self.shared)
        let descriptor = FetchDescriptor<LinkCutComponent>()
        return try ctx.fetch(descriptor)
    }
}

enum DevStoreReset {
    static func resetStoreFiles() throws {
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: SharedModelContainer.groupID
        ) else {
            throw NSError(domain: "Reset", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Could not locate app group container."
            ])
        }
        
        let files = try FileManager.default.contentsOfDirectory(
            at: groupURL,
            includingPropertiesForKeys: nil
        )
        
        for file in files {
            let name = file.lastPathComponent
            if name.hasPrefix("default.store") || name.contains(".store") || name.contains("sqlite") {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }
}
