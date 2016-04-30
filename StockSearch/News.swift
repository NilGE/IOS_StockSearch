//
//  News.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/29/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class News {
    var title: String!
    var content: String!
    var publisher: String!
    var date: String!
    var url: String!
    
    init(title: String, content: String, publisher: String, date: String, url: String) {
        self.title = title
        self.content = content
        self.publisher = publisher
        self.date = date
        self.url = url
    }
}
