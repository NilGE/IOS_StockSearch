//
//  StockDetailView.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/22/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FBSDKLoginKit
import FBSDKShareKit

class StockDetailView: UIViewController , UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    
    // MARK: Properties
    
    var stock: Stock!
    var curStock:NSManagedObject!
    var newsArray = [News]()
    
    @IBOutlet weak var yahooChar: UIImageView!
    
    // MARK: Facebook
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        let alert = UIAlertController(title: "Post Success",
                                      message: "",
                                      preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction)->Void in})
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alert = UIAlertController(title: "Post Fail",
                                      message: "",
                                      preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction)->Void in})
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        let alert = UIAlertController(title: "Cancel Post",
                                      message: "",
                                      preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction)->Void in})
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction func facebookBtn(sender: UIButton) {
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://finance.yahoo.com/q?s=\(stock.symbol)")
        content.contentTitle = "Current Stock Price of \(stock.name) is \(stock.lastPrice)"
        content.contentDescription = "Stock information of \(stock.name) (\(stock.symbol))"
        content.imageURL = NSURL(string: "http://chart.finance.yahoo.com/t?s=\(stock.symbol)&lang=en-US&width=400&height=300")
        
        let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
        
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        shareDialog.show()
    }
    
    
    @IBAction func favoriteBtn(sender: UIButton) {
        //select an entity
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if curStock == nil { //if the current stock is not in the favorite list
            sender.setImage(UIImage(named: "StarFilled"), forState: .Normal)
            
            let entity = NSEntityDescription.entityForName("Stock", inManagedObjectContext: managedContext)
            curStock = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            curStock.setValue(self.stock.symbol, forKey: "symbol")
            curStock.setValue(self.stock.name, forKey: "companyName")
            curStock.setValue(self.stock.lastPrice, forKey: "stockPrice")
            curStock.setValue(self.stock.change, forKey: "change")
            curStock.setValue(self.stock.marketCap, forKey: "marketCap")
            curStock.setValue(self.stock.changePositive, forKey: "changePositive")
            
        } else { // delete the current stock from favorite list
            sender.setImage(UIImage(named: "StarEmpty"), forState: .Normal)
            managedContext.deleteObject(curStock)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHighChart" {
            let HighChartViewController = segue.destinationViewController as! HighChartView
            HighChartViewController.stock = self.stock
        } else if segue.identifier == "showNews" {
            let NewsViewController = segue.destinationViewController as! NewsView
            NewsViewController.stock = self.stock
            NewsViewController.newsArray = self.newsArray
        }
    }
    
    @IBAction func showHighChartBtn(sender: UIButton) {
        self.performSegueWithIdentifier("showHighChart", sender: nil)
    }
    
    @IBAction func showNewsBtn(sender: UIButton) {
        
        let url = "http://certain-mystery-126718.appspot.com/"
        Alamofire.request(.GET, url, parameters: ["target": stock.symbol]).responseJSON {
            response in switch response.result {
            case.Success(let JSON):
                let response = JSON as! NSDictionary
                let d = response.objectForKey("d") as! NSDictionary
                let results = d.objectForKey("results") as! NSArray
                for result in results {
                    let data = result as! NSDictionary
                    let news = News(
                        title: String(data.objectForKey("Title")!),
                        content: String(data.objectForKey("Description")!),
                        publisher: String(data.objectForKey("Source")!),
                        date: String(data.objectForKey("Date")!),
                        url: String(data.objectForKey("Url")!))
                    self.newsArray.append(news)
                }
                self.performSegueWithIdentifier("showNews", sender: nil)
            case.Failure(let error):
                print("Bing news Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: view flow
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = stock.symbol
        
//        self.navigationController?.popViewControllerAnimated(true)
        
        // Show yahoo chart
        let url = NSURL(string: "http://chart.finance.yahoo.com/t?s=\(stock.symbol)&lang=en-US&width=400&height=300")
        let data = NSData(contentsOfURL: url!)
        yahooChar.image = UIImage(data: data!)
        
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath:  indexPath) as! StockDetailHeaderTableViewCell
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            
            var selectedStocks = [NSManagedObject]()
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let manageContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Stock")
            let predicate = NSPredicate(format: "symbol = '\(self.stock.symbol)'")
            fetchRequest.predicate = predicate
            do {
                let results = try manageContext.executeFetchRequest(fetchRequest)
                selectedStocks = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            if selectedStocks.count == 0 {
                curStock = nil
            } else {
                curStock = selectedStocks.first
                cell.favorateBtn.setImage(UIImage(named: "StarFilled"), forState: .Normal)
            }
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
