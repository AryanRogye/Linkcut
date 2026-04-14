//
//  LinkcutApp.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

@main
struct LinkcutApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .onOpenURL { url in
                    guard url.scheme == "linkcut",
                          url.host == "open",
                          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let itemIDString = components.queryItems?.first(where: { $0.name == "itemID" })?.value,
                          let itemID = UUID(uuidString: itemIDString)
                    else {
                        return
                    }
                    
                    guard let items = try? SharedModelContainer.getAllShortcutItems() else { return }
                    
                    if let item = items.first(where: { $0.id == itemID }) {
                        UIApplication.shared.open(item.url)
                    }
                }
        }
        .modelContainer(SharedModelContainer.shared)
    }
}
