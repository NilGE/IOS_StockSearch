//
//  StockDetailView.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/22/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit
import CoreData

class StockDetailView: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    // MARK: Properties
    
    var stock: Stock!
    
    // MARK : Action
    @IBAction func favoriteBtn(sender: UIButton) {
        
//        let filledStar = UIImage(named: "")
        sender.setImage(UIImage(named: "StarFilled"), forState: .Normal)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Stock", inManagedObjectContext: managedContext)
        let curStock = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        curStock.setValue(self.stock.symbol, forKey: "symbol")
        curStock.setValue(self.stock.name, forKey: "companyName")
        curStock.setValue(self.stock.lastPrice, forKey: "stockPrice")
        curStock.setValue(self.stock.change, forKey: "change")
        curStock.setValue(self.stock.marketCap, forKey: "marketCap")
        curStock.setValue(self.stock.changePositive, forKey: "changePositive")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        //delete
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = stock.symbol
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Stock Detail table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 11
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:UITableViewCell!
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath:  indexPath) as! StockDetailHeaderTableViewCell
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("stockDetailCell", forIndexPath: indexPath) as! DetailContentTableViewCell
            cell.StockDetailTitle.text = stock.titles[indexPath.row]
            cell.StockDetailContent.text = stock.contents[indexPath.row]
            if indexPath.row == 3 {
                if stock.changePositive {
                    cell.StockDetailImage.image = UIImage(named: "Up")
                } else {
                    cell.StockDetailImage.image = UIImage(named: "Down")
                }
            }
            
            if indexPath.row == 7 {
                if stock.changeYTDPositive {
                    cell.StockDetailImage.image = UIImage(named: "Up")
                } else {
                    cell.StockDetailImage.image = UIImage(named: "Down")
                }
            }
            return cell
        }
//        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
