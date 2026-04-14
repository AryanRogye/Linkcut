//
//  LinkCutGroupsView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

struct LinkCutGroupsView: View {
    
    @Environment(\.modelContext) var ctx
    @Query var components: [LinkCutComponent]
    @Query var groups: [LinkCuts]
    
    var body: some View {
        List {
            Section("New") {
                LinkCutGroupAddView()
            }
            Section("Saved") {
                savedSection
            }
        }
    }
    
    @ViewBuilder
    private var savedSection: some View {
        ForEach(groups) { group in
            Text(group.title)
        }
    }
}
