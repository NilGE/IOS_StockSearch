//
//  Stock.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/21/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class Stock {
    var name: String
    var symbol: String
    var lastPrice: String
    var change: String
    var changePositive: Bool
    var time: String
    var marketCap: String
    var volume: String
    var changeYTD: String
    var changeYTDPositive: Bool
    var highPrice: String
    var lowPrice: String
    var openingPrice: String
    
    
    
    init?(status: String,
         name: String,
         symbol: String,
         lastPrice: String,
         change: String,
         changePercent: String,
         timeStamp: String,
         marketCap: String,
         volume: String,
         changeYTD: String,
         changePercentYTD: String,
         high: String,
         low: String,
         open: String) {
        
        if status == "FAIL" {
            return nil
        }
        
        func getRound(num: String) -> Double {
            return round(Double(lastPrice)!*100)/100
        }
        self.name = name
        self.symbol = symbol
        self.lastPrice = "$ \(getRound(lastPrice))"
        self.change = "\(getRound(change))(\(getRound(changePercent))%)"
        self.changePositive = Double(changePercent) >= 0 ? true:false
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "UTC")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let date = formatter.dateFromString(timeStamp)!
        formatter.dateFormat = "MMM d yyyy hh:mm"
        self.time = formatter.stringFromDate(date)
        self.time = timeStamp
        let dMarketCap = Double(marketCap)!
        if dMarketCap > 1000000000 {
            self.marketCap = "\(round(dMarketCap/10000000)/100) Billion"
        } else if dMarketCap > 1000000 {
            self.marketCap = "\(round(dMarketCap/10000)/100) Million"
        } else {
            self.marketCap = marketCap
        }
        self.volume = volume
        self.changeYTD = "\(getRound(changeYTD))(\(getRound(changePercentYTD))%)"
        self.changeYTDPositive = Double(changePercentYTD) >= 0 ? true:false
        self.highPrice = "$ \(getRound(high))"
        self.lowPrice = "$ \(getRound(low))"
        self.openingPrice = "$ \(getRound(open))"
    }
    
    
    
    
}
