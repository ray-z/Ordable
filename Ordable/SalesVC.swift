//
//  SalesVC.swift
//  Ordable
//
//  Created by Ray on 3/22/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit
import CoreData

class SalesVC: UITableViewController
{
    var sales = [NSManagedObject]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sales.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let sale = self.sales[indexPath.row]
        var date = sale.valueForKey("date") as! String
        var amount = sale.valueForKey("amount") as! Double
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = String(format:"£ %.2f", amount)
        
        return cell

    }
}

