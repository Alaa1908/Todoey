//
//  Item.swift
//  Todoey
//
//  Created by mac on 8/14/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import Foundation

class Item {
    var title : String = "" 
    var done : Bool = false
    
    init(title : String) {
        self.title = title
    }
    
    func Check() {
        done = !done
    }
}
