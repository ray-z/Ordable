//
//  OrderVC.swift
//  Ordable
//
//  Created by Ray on 2/17/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation
import CoreData

class OrderVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, OrderCellDelegate, PLPartyTimeDelegate, MainDelegate
{
    
    
    let OrderCellViewIdentifier = "OrderCell"
    var orderedItems = [OrderItem]()
    var orderedItemsPeerID = [MCPeerID]()

    var totalAmount = 0.00
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // P2P
    let advertisedName = "Ordable-Server"
    let advertiser: MCNearbyServiceAdvertiser?
    let ServerPeerID = "Ordable-Server"
    let partyTime: PLPartyTime = PLPartyTime(serviceType: "Ordable-Server")
    
    
    // notification sound
    var audioPlayer = AVAudioPlayer()
    
    // UI
    @IBOutlet weak var btnTotalAmount: UIBarButtonItem!
    
    // core data
    var managedContext: NSManagedObjectContext?
    var fetchRequest: NSFetchRequest?
    var error: NSError?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView?.scrollEnabled = false
        self.collectionView?.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.9, alpha: 1.0)
        
        
        
        // audio
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("notification", ofType: "mp3")!)
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        
        // total amount button
        btnTotalAmount.tintColor = UIColor.blackColor()
        //btnTotalAmount.enabled = false
        
//        // fake item for testing
//        let i1 = OrderItem(name: "English Breakfast Tea", quantity: 1, size: "Small", customer: "Ray")
//        let i2 = OrderItem(name: "Cappuccino", quantity: 2, size: "Medium", customer: "Tom")
//        let i3 = OrderItem(name: "Latte", quantity: 1, size: "Medium", customer: "Alex")
//        let i4 = OrderItem(name: "Jasmine Tea", quantity: 1, size: "Small", customer: "Nick")
//        let i5 = OrderItem(name: "Chocolate Frappe", quantity: 1, size: "Large", customer: "Alice")
//        let i6 = OrderItem(name: "Latte", quantity: 1, size: "Small", customer: "Bob")
//        let i7 = OrderItem(name: "Green Tea", quantity: 1, size: "Small", customer: "Ray")
//        orderedItems.append(i1)
//        orderedItems.append(i2)
//        orderedItems.append(i3)
//        orderedItems.append(i4)
//        orderedItems.append(i5)
//        orderedItems.append(i6)
//        orderedItems.append(i7)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let orderCellNib = UINib(nibName: "OrderCell", bundle: nil)
        self.collectionView?.registerNib(orderCellNib, forCellWithReuseIdentifier: OrderCellViewIdentifier)
        
        // init core data
        managedContext = self.appDelegate.managedObjectContext
        fetchRequest = NSFetchRequest(entityName:"Sale")
        fetchRequest?.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        fetchData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.appDelegate.orderVCDelegate = self
        readTotalAmount()
        
        
        // p2p
        self.partyTime.delegate = self;
        partyTime.joinParty()
        
        
        
        //var sendFailedError: NSError?
        //let serverPeerID = NSKeyedArchiver.archivedDataWithRootObject(partyTime.peerID)
        //partyTime.sendData(serverPeerID, withMode: MCSessionSendDataMode.Reliable, error: &sendFailedError)
        //self.advertiser.startAdvertisingPeer()
//        MultipeerConnectivityService.sharedService().advertiseWithName(advertisedName)
//        MultipeerConnectivityService.sharedService().delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // show message
    func showMsg(title: String, msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg,
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refreshAmount(oldAmount:Double, date:String)
    {
        saveAmount(oldAmount, date: date)
        readTotalAmount()
        
        showMsg("Reset Sales", msg: "Total amount for \(date): \n£\(oldAmount)")
    }
    
    
    func readTotalAmount()
    {
        // read total amount
        self.totalAmount = NSUserDefaults.standardUserDefaults().valueForKey(KeyTotalAmount) as Double
        updateBtnTotalAmount()
    }
    
    func updateBtnTotalAmount()
    {
        btnTotalAmount.title = NSString(format:"Total: £ %.2f", self.totalAmount)
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
//        var Error: NSError?
//        let data = NSKeyedArchiver.archivedDataWithRootObject("Your food is ready.")
//        self.partyTime.sendData(data, toPeers: [self.orderedItemsPeerID[index]], withMode: MCSessionSendDataMode.Reliable, error: &Error)
//        println("Sending msg to: \(self.orderedItemsPeerID[index])")
        
        self.orderedItems.removeAtIndex(index)
        self.orderedItemsPeerID.removeAtIndex(index)
        self.collectionView?.reloadData()
    }
    
    // validate price
    func validatePrice(price: Double) -> Double
    {
        var newPriceStr = NSString(format:"%.2f", price)
        return newPriceStr.doubleValue
    }
    
    // Core data
    func saveAmount(amount:Double, date:String)
    {
        let entity =  NSEntityDescription.entityForName("Sale", inManagedObjectContext: self.managedContext!)
        
        let newSale = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext) as Sale
        newSale.amount = amount
        newSale.date = date
        
        if !managedContext!.save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        
    }
    
    func fetchData() -> [NSManagedObject]
    {
//        var sales = [NSManagedObject]()
        
        let fetchedResults = managedContext!.executeFetchRequest(fetchRequest!, error: &error) as [NSManagedObject]?
        
        
        if var results = fetchedResults
        {
            return results
            
        }
        else
        {
            println("Could not fetch \(error), \(error!.userInfo)")
            
            return []
        }
        
    }
    
    // Calculate commission
    func deductCommision(amount: Double) -> Double
    {
        var newAmount = validatePrice(amount * (1 - CommissionRate)) - CommissionFix
        
        return validatePrice(newAmount)
    }
    
    // delegate
    func itemDelivered(cell:OrderCell)
    {
        let index = self.collectionView?.indexPathForCell(cell)?.row
        showAlert(index!)
    }
    
    func sendNotification(cell:OrderCell)
    {
        let index = self.collectionView?.indexPathForCell(cell)?.row
        var Error: NSError?
        let data = NSKeyedArchiver.archivedDataWithRootObject(BusyMsg)
        self.partyTime.sendData(data, toPeers: [self.orderedItemsPeerID[index!]], withMode: MCSessionSendDataMode.Reliable, error: &Error)
        
        showMsg("Message has been sent", msg:"")
        println("Sending msg to: \(self.orderedItemsPeerID[index!])")
    }
    
    // PLPartyTimeDelegate
    func partyTime(partyTime: PLPartyTime!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!)
    {
        println("Getting data from \(peerID)")
        
        let orderInfo = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
        
        let table = orderInfo.valueForKey("table") as String
        let name = orderInfo.valueForKey("name") as String
        let itemsInfo = orderInfo.valueForKey("itemsInfo") as String
        let amount = (orderInfo.valueForKey("amount") as NSString).doubleValue
        
        let items = itemsInfo.componentsSeparatedByString("---")
        for item in items
        {
            // to improve later
            if(item != "")
            {
                let info = item.componentsSeparatedByString(":")

//                let item = OrderItem(name: info[0], quantity: info[1].toInt()!, size: "Regular", table:table.toInt()!, customer: name)
                
                let item = OrderItem(name: info[0], table: table.toInt()!, customer: name, info: info[1])
                self.orderedItems.append(item)
                self.orderedItemsPeerID.append(orderInfo.valueForKey("MCPeerID") as MCPeerID)
            }
        }
        
        self.collectionView?.reloadData()
        audioPlayer.play()
        self.totalAmount += deductCommision(amount)
        
        // save amount
        NSUserDefaults.standardUserDefaults().setDouble(self.totalAmount, forKey: KeyTotalAmount)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        updateBtnTotalAmount()
//        println(orderInfo.valueForKey("amount") as String)
        
    }
    
    func partyTime(partyTime: PLPartyTime!, peer: MCPeerID!, changedState state: MCSessionState, currentPeers: [AnyObject]!)
    {
        if(state == MCSessionState.Connected)
        {
            println("\(peer) is connected.")
        }
    }

    func partyTime(partyTime: PLPartyTime!, failedToJoinParty error: NSError!)
    {
        
    }
//    func didReceiveData(data: NSData!, fromPeer peerId: MCPeerID!)
//    {
//        let orderItemInfo = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
//
//        println(orderItemInfo)
//    }
    
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
//        cell.setCellContents(item.name, quantity: item.quantity, table: item.table, method: item.method)
//        cell.setCellContents(item.name, quantity: item.quantity, size: item.size, table: item.table, customer: item.customer)
        cell.setCellContents(item.name, table: item.table, customer: item.customer, info: item.info)
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
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "SalesVCSegue")
        {
            let salesVC = segue.destinationViewController as SalesVC
            salesVC.sales = fetchData()
        }
        
    }
}
