//
//  AppDelegate.swift
//  Ordable
//
//  Created by Ray on 2/17/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit

protocol AddItemDelegate
{
    func addItem(item: OrderItem, peerID: MCPeerID)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PLPartyTimeDelegate
{

    var window: UIWindow?
    
    // P2P
    var addItemDelegate: AddItemDelegate?
    let advertisedName = "Ordable-Server"
    let advertiser: MCNearbyServiceAdvertiser?
    let ServerPeerID = "Ordable-Server"
    let partyTime: PLPartyTime = PLPartyTime(serviceType: "Ordable-Server")
//    var orderedItemsPeerID = [MCPeerID]()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.partyTime.delegate = self;
        partyTime.joinParty()
        return true
    }
    
    func partyTime(partyTime: PLPartyTime!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!)
    {
        
        let orderInfo = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
        println(orderInfo)
        let table = orderInfo.valueForKey("table") as String
        let name = orderInfo.valueForKey("name") as String
        let itemsInfo = orderInfo.valueForKey("itemsInfo") as String
        
        let items = itemsInfo.componentsSeparatedByString("---")
        for item in items
        {
            // to improve later
            if(item != "")
            {
                let info = item.componentsSeparatedByString(":")
                
                let item = OrderItem(name: info[0], quantity: info[1].toInt()!, size: "Regular", table:table.toInt()!, customer: name)
//                self.orderedItems.append(item)
//                self.orderedItemsPeerID.append(orderInfo.valueForKey("MCPeerID") as MCPeerID)
                self.addItemDelegate?.addItem(item, peerID:orderInfo.valueForKey("MCPeerID") as MCPeerID)

                
            }
        }
        
        //self.collectionView?.reloadData()
        
        
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


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

