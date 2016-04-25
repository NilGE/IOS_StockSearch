//
//  DetailContentTableViewCell.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/22/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit

class DetailContentTableViewCell: UITableViewCell {

    // MARK: Properites
    
    @IBOutlet weak var StockDetailTitle: UILabel!
    @IBOutlet weak var StockDetailContent: UILabel!
    @IBOutlet weak var StockDetailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
