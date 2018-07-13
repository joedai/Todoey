//
//  Category.swift
//  Todoey
//
//  Created by Joe Dai on 12/07/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
