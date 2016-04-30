//
//  NewsTableViewCell.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/29/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // MARK: Properties\
    var url:String!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
