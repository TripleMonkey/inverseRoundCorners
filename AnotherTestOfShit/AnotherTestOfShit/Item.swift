//
//  Item.swift
//  AnotherTestOfShit
//
//  Created by Nigel Krajewski on 9/6/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
