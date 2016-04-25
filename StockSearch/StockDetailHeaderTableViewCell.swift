//
//  StockDetailHeaderTableViewCell.swift
//  StockSearch
//
//  Created by Xiangyu Ge on 4/22/16.
//  Copyright © 2016 Xiangyu Ge. All rights reserved.
//

import UIKit


class StockDetailHeaderTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var StockDetailLabel: UILabel!
    
    // MARK: Action
    
    @IBAction func FacebookBtn(sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
