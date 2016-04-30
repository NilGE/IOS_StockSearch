//
//  HighChartView.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/28/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit
import Alamofire

class HighChartView: UIViewController {
    
    // MARK: Properties
    
    var stock: Stock!
    @IBOutlet weak var highChartWebView: UIWebView!
    var newsArray = [News]()
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStockDetail" {
            let StockDetailViewController = segue.destinationViewController as! StockDetailView
            StockDetailViewController .stock = self.stock
        } else if segue.identifier == "showNews" {
            let NewsViewController = segue.destinationViewController as! NewsView
            NewsViewController.stock = self.stock
            NewsViewController.newsArray = self.newsArray
        }
    }
    
    @IBAction func showStockDetailBtn(sender: UIButton) {
        self.performSegueWithIdentifier("showStockDetail", sender: nil)
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
        let url = NSURL(string: "http://www-scf.usc.edu/~gexiangy/HW9/highchart.php?symbol=\(stock.symbol)")
        let requestObj = NSURLRequest(URL: url!)
        highChartWebView.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
