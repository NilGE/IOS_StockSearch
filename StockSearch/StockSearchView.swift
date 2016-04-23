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

class StockSearchView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var autoCompleteContainerVIew: UIView!
    
    var symbol: String!
    var currStock: Stock!
    var autoCompleteViewController: AutoCompleteViewController!
    var isFirstLoad: Bool = true
    
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
                    
                    

                case .Failure(let error):
                     print("Request failed with error: \(error)")
                }
        }
        
    }
    
   
    
    // MARK: Favorite table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        cell.symbol.text = "AAPL"
        cell.companyName.text = "Apple Inc"
        cell.stockPrice.text = "$ 109.99"
        cell.changePercenttage.text = "+1.00(0.92%)"
        cell.marketCap.text = "Market Cap: 609.85 Billion"
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
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
