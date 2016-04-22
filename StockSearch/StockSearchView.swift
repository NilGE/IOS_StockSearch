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
    
    
    
    // MARK: Actions
    @IBAction func getQuote(sender: UIButton) {
        let symbol = symbolTextField.text!
        let url = "http://certain-mystery-126718.appspot.com/"
        Alamofire.request(.GET, url, parameters: ["symbol": symbol]).responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    let response = JSON as! NSDictionary
                    let symbol = response.objectForKey("Symbol")
                    print(symbol)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

