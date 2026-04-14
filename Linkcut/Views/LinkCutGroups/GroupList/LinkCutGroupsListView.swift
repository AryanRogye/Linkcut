//
//  LinkCutGroupsListView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//


import SwiftUI
import SwiftData

struct LinkCutGroupsListView: View {
    
    @Environment(\.modelContext) var ctx
    @Query var components: [LinkCutComponent]
    @Query var groups: [LinkCuts]
    
    @State private var selectedGroup: LinkCuts?
    
    var body: some View {
        ForEach(groups) { group in
            Button(action: { selectedGroup = group }) {
                LinkCutGroupRow(group: group)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)
        }
        .navigationDestination(item: $selectedGroup) { group in
            LinkCutGroupDetailView(group: group)
        }
    }
}
