//
//  LinkCutComponentsView.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkCutComponentsView: View {
    var body: some View {
        List {
            Section("New") {
                LinkCutComponentAddView()
            }

            Section("Saved") {
                LinkCutComponentsListView()
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    LinkCutComponentsView()
}
