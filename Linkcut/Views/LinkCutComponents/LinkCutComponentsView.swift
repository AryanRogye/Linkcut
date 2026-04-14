//
//  LinkCutComponentsView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData

struct LinkCutComponentsView: View {
    @Query var components: [LinkCutComponent]

    var body: some View {
        List {
            Section("New") {
                LinkCutComponentAddView()
            }

            Section("Saved") {
                if components.isEmpty {
                    LinkCutComponentsEmptyStateView()
                } else {
                    ForEach(components) { component in
                        LinkCutComponentsListRow(component: component)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    LinkCutComponentsView()
}
