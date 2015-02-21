//
//  OrderCell.swift
//  Ordable
//
//  Created by Ray on 2/17/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit

protocol OrderCellDelegate
{
    func itemDelivered(cell:OrderCell)
}

class OrderCell: UICollectionViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTable: UILabel!
    @IBOutlet weak var lblMethod: UILabel!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var delegate: OrderCellDelegate?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 20.0
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        self.frame.size.height = screenSize.height * 0.5
        self.frame.size.width = screenSize.width * 0.3
    }
    
//    func setCellContents(name:String, quantity:Int, table:Int, method:String)
//    {
//        lblName.text = "\(name)\t x\(quantity)"
//        lblTable.text = "Table: \(table)"
//        lblMethod.text = "Paied by: \(method)"
//    }

    func setCellContents(name:String, quantity:Int, size:String, customer:String)
    {
        lblName.text = "\(name)\t x\(quantity)"
        lblTable.text = "Size: \(size)"
        lblMethod.text = "Name: \(customer)"
    }
    
    @IBAction func deliveredClicked(sender: AnyObject)
    {
        delegate?.itemDelivered(self)
    }
    

}
