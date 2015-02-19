//
//  OrderVC.swift
//  Ordable
//
//  Created by Ray on 2/17/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit


class OrderVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, OrderCellDelegate, MultipeerConnecivityServiceDelegate
{
    let advertisedName = "Ordable-Server"
    
    let OrderCellViewIdentifier = "OrderCell"
    var orderedItems = [OrderItem]()
    // protocol
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView?.scrollEnabled = false
        self.collectionView?.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.9, alpha: 1.0)
        
        // fake item for testing
        let i1 = OrderItem(name: "English Breakfast Tea", quantity: 1, table: 1, method: "PayPal")
        let i2 = OrderItem(name: "Cappuccino", quantity: 2, table: 1, method: "PayPal")
        let i3 = OrderItem(name: "Latte", quantity: 1, table: 2, method: "PayPal")
        let i4 = OrderItem(name: "Jasmine", quantity: 1, table: 4, method: "PayPal")
        let i5 = OrderItem(name: "Chocolate Frappe", quantity: 1, table: 5, method: "PayPal")
        let i6 = OrderItem(name: "Bacon Toastie", quantity: 1, table: 6, method: "PayPal")
        let i7 = OrderItem(name: "Wild Berry", quantity: 1, table: 7, method: "PayPal")
        orderedItems.append(i1)
        orderedItems.append(i2)
        orderedItems.append(i3)
        orderedItems.append(i4)
        orderedItems.append(i5)
        orderedItems.append(i6)
        orderedItems.append(i7)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let orderCellNib = UINib(nibName: "OrderCell", bundle: nil)
        self.collectionView?.registerNib(orderCellNib, forCellWithReuseIdentifier: OrderCellViewIdentifier)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        MultipeerConnectivityService.sharedService().advertiseWithName(advertisedName)
        MultipeerConnectivityService.sharedService().delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(index:Int)
    {
        var alert = UIAlertController (title: "Confirmation:", message: "Food has been delivered to customer.", preferredStyle: .Alert)

        // buttons
        let yesAction = UIAlertAction(title: "Yes",
            style: .Default) { (action: UIAlertAction!) -> Void in

                self.updateOrderedItems(index)
        }

        let noAction = UIAlertAction(title: "No",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }

        alert.addAction(yesAction)
        alert.addAction(noAction)

        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func updateOrderedItems(index:Int)
    {
        orderedItems.removeAtIndex(index)
        self.collectionView?.reloadData()
    }
    
    // delegate
    func itemDelivered(cell:OrderCell)
    {
        let index = self.collectionView?.indexPathForCell(cell)?.row
        showAlert(index!)
    }
    
    // MultipeerConnecivityServiceDataReceptionDelegate Methods
    func didReceiveData(data: NSData!, fromPeer peerId: MCPeerID!)
    {
        let orderItemInfo = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary

        println(orderItemInfo)
    }
    
    // Collection View Methods
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (orderedItems.count > 6) ? 6 : orderedItems.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(OrderCellViewIdentifier, forIndexPath: indexPath) as OrderCell
        cell.delegate = self
        let item = orderedItems[indexPath.row] as OrderItem
        cell.setCellContents(item.name, quantity: item.quantity, table: item.table, method: item.method)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize
    {
        let cvSize = collectionView.frame.size
        
        let cellSize = CGSizeMake(cvSize.width * 0.3, cvSize.height * 0.4)
        
        
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(30, 20, 30, 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 30
    }
}
