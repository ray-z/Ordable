//
//  Item.swift
//  Ordo
//
//  Created by Ray on 12/26/14.
//  Copyright (c) 2014 LeiZeng. All rights reserved.
//

import Foundation

class OrderItem: NSObject
{
    var name: String = ""
    var quantity: Int = 0
    var table: Int = 0
    var method: String = ""
    var size: String = ""
    var customer: String = ""
    
//    init(name:String, quantity:Int, table:Int, method:String)
//    {
//        super.init()
//        self.name = name
//        self.quantity = quantity
//        self.table = table
//        self.method = method
//    }

    init(name:String, quantity:Int, size:String, customer:String)
    {
        super.init()
        self.name = name
        self.quantity = quantity
        self.size = size
        self.customer = customer
    }
    
}
