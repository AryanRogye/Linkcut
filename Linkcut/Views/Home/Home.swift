//
//  Home.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/13/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: LinkCutGroupsView()) {
                    Text("LinkCut Groups")
                }
                NavigationLink(destination: LinkCutComponentsView()) {
                    Text("LinkCut Components")
                }
            }
        }
    }
}
