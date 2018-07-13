//
//  Item.swift
//  Todoey
//
//  Created by Joe Dai on 12/07/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
