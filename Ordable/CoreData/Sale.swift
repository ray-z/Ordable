//
//  Sale.swift
//  Ordable
//
//  Created by Ray on 3/22/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import Foundation
import CoreData

@objc(Sale)
class Sale: NSManagedObject {

    @NSManaged var amount: Double
    @NSManaged var date: String

}
