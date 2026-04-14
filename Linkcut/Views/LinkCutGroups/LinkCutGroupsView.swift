//
//  LinkCutGroupsView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI

struct LinkCutGroupsView: View {
    var body: some View {
        List {
            Section("New") {
                LinkCutGroupAddView()
            }
            Section("Saved") {
                LinkCutGroupsListView()
            }
        }
    }
}
