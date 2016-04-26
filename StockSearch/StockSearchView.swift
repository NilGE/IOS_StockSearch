//
//  ViewController.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/21/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit
import CCAutocomplete
import Alamofire
import CoreData

class StockSearchView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var autoCompleteContainerVIew: UIView!
    
    var symbol: String!
    var currStock: Stock!
    var autoCompleteViewController: AutoCompleteViewController!
    var isFirstLoad: Bool = true
    var favoriteStocks = [NSManagedObject]()
    @IBOutlet weak var favoriateTableView: UITableView!
    
    func showDetailView(symbol: String) {
        let url = "http://certain-mystery-126718.appspot.com/"
        Alamofire.request(.GET, url, parameters: ["symbol": symbol]).responseJSON {
            response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                
                if response.objectForKey("Message") != nil {
                    let alert = UIAlertController(title: "Invalid Symbol",
                        message: "",
                        preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction)->Void in})
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                //init stock
                self.currStock = Stock(
                    status: String(response.objectForKey("Status")!),
                    name: String(response.objectForKey("Name")!),
                    symbol: String(response.objectForKey("Symbol")!),
                    lastPrice: String(response.objectForKey("LastPrice")!),
                    change: String(response.objectForKey("Change")!),
                    changePercent: String(response.objectForKey("ChangePercent")!),
                    timeStamp: String(response.objectForKey("Timestamp")!),
                    marketCap: String(response.objectForKey("MarketCap")!),
                    volume: String(response.objectForKey("Volume")!),
                    changeYTD: String(response.objectForKey("ChangeYTD")!),
                    changePercentYTD: String(response.objectForKey("ChangePercentYTD")!),
                    high: String(response.objectForKey("High")!),
                    low: String(response.objectForKey("Low")!),
                    open: String(response.objectForKey("Open")!))
                
                self.performSegueWithIdentifier("showStockDetail", sender: nil)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    
    // MARK: Actions
    @IBAction func getQuote(sender: UIButton) {
        if symbolTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Please Enter a Stock Name or Symbol",
                                          message: "",
                                          preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction)->Void in})
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var symbol = symbolTextField.text!
        
        if symbol.containsString("-") {
            let symbolArray = symbol.characters.split("-").map(String.init)
            print(symbolArray[0])
            symbol = symbolArray[0]
        }
        showDetailView(symbol)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStockDetail" {
            let StockDetailViewController = segue.destinationViewController as! StockDetailView
            StockDetailViewController.stock = self.currStock
        }
    }
    
   
    
    // MARK: Favorite table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStocks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableCell", forIndexPath: indexPath) as! FavoriteTableViewCell
//        cell.symbol.text = "AAPL"
//        cell.companyName.text = "Apple Inc"
//        cell.stockPrice.text = "$ 109.99"
//        cell.changePercenttage.text = "+1.00(0.92%)"
//        cell.marketCap.text = "Market Cap: 609.85 Billion"
        
        cell.symbol.text = favoriteStocks[indexPath.row].valueForKey("symbol") as? String
        cell.companyName.text = favoriteStocks[indexPath.row].valueForKey("companyName") as? String
        cell.stockPrice.text = favoriteStocks[indexPath.row].valueForKey("stockPrice") as? String
        cell.changePercenttage.text = favoriteStocks[indexPath.row].valueForKey("change") as? String
        let green = UIColor.init(red: 49/255, green: 155/255, blue: 82/255, alpha: 1)
        let red = UIColor.init(red: 225/255, green: 51/255, blue: 60/255, alpha: 1)
        cell.changePercenttage.backgroundColor = favoriteStocks[indexPath.row].valueForKey("changePositive") as! Bool ? green : red
        cell.marketCap.text = favoriteStocks[indexPath.row].valueForKey("marketCap") as? String
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let manageContext = appDelegate.managedObjectContext
            manageContext.deleteObject(favoriteStocks[indexPath.row])
            favoriteStocks.removeAtIndex(indexPath.row)
            do {
                try manageContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let symbol = favoriteStocks[indexPath.row].valueForKey("symbol") as! String
        showDetailView(symbol)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //hide the navigation bar
        self.navigationController?.navigationBar.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Stock")
        
        do {
            let results = try manageContext.executeFetchRequest(fetchRequest)
            favoriteStocks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.favoriateTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }

}

// MARK: Autocomplete
extension StockSearchView: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.symbolTextField
    }
    
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 2
    }
    

    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompletableOption] {
        return [AutocompletableOption]()
    }
    
    func autoCompleteHeight() -> CGFloat {
        return CGRectGetHeight(self.view.frame) / 3.0
    }
    
    func didSelectItem(item: AutocompletableOption) {
        
    }
}
