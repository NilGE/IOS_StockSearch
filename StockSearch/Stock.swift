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
    var lastPrice: Float
    var change: Float
    var time: NSDate
    var marketCap: Float
    var volume: Float
    var changeYTD: Float
    var highPrice: Float
    var lowPrice: Float
    var openingPrice: Float
    
    init?(status: String, name: String, symbol: String, lastPrice: String, change: String, changePercent: String, timeStamp: String,
          marketCap: String, volue: String, changeYTD: String, changePercentYTD: String, high: String, low: String, open: String) {
        
        return nil
    }
}
