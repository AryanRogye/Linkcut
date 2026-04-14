//
//  LinkCutInfo.swift
//  Linkcut
//
//  Created by Aryan Rogye on 4/14/26.
//

import Foundation
import WidgetKit

/**
 * This Model is what the widget gets/sees
 * this lets us determine what to show
 */
struct LinkCutInfo: TimelineEntry {
    let date: Date
    /**
     * This represents a "selected group" a value of nil would mean
     * that no group is selected so we dont show anything
     */
    let components: [LinkCutComponent]?
}
