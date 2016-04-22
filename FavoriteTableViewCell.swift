//
//  FavoriteTableViewCell.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/21/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var changePercenttage: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
