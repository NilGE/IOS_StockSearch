//
//  NewsView.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/28/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class NewsView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var stock: Stock!
    var newsArray = [News]()
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStockDetail" {
            let StockDetailViewController = segue.destinationViewController as! StockDetailView
            StockDetailViewController .stock = self.stock
        } else if segue.identifier == "showHighChart" {
            let HighChartViewController = segue.destinationViewController as! HighChartView
            HighChartViewController.stock = self.stock
        }
    }
    @IBAction func showStockDetail(sender: UIButton) {
        self.performSegueWithIdentifier("showStockDetail", sender: nil)
    }
    
    @IBAction func showHIghChart(sender: UIButton) {
        self.performSegueWithIdentifier("showHighChart", sender: nil)
    }
    
    // MARK: view flow
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = stock.symbol
        print("The number of news is \(self.newsArray.count)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: news table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableCell", forIndexPath: indexPath) as! NewsTableViewCell
//        cell.title.text = "Apple (AAPL) Stock Continues to Decline After Icahn Dumped Shares, Jim Cramer's View"
//        cell.content.text = "NEW YORK (TheStreet) -- Apple (AAPL - Get Report) stock is slumping 1.33% to $93.57 in early-afternoon trading on Friday after billionaire activist investor Carl Icahn told CNBC yesterday that he sold his entire stake in the iPhone maker, citing the risk"
//        cell.publisher.text = "The Street"
//        cell.date.text = "2016-04-02T13:10:16Z"
        cell.title.text = newsArray[indexPath.row].title
        cell.content.text = newsArray[indexPath.row].content
        cell.publisher.text = newsArray[indexPath.row].publisher
        cell.date.text = newsArray[indexPath.row].date
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = newsArray[indexPath.row].url
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
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
