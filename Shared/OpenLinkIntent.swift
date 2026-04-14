//
//  OpenLinkIntent.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import AppIntents
import UIKit

enum IntentError: Error {
    case notAvailable
}

struct OpenLinkIntent: AppIntent {
    static let title : LocalizedStringResource = "Open Link Intent"
    
    @Parameter(title: "Link URL")
    var url: URL
    
    init() {}
    
    init(url: URL) {
        self.url = url
    }
    
    func perform() async throws -> some IntentResult {
        let intent = OpenURLIntent(url)
        return try await intent.perform()
    }
}
