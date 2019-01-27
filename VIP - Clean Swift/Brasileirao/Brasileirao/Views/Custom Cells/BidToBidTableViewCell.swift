//
//  BidToBidTableViewCell.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import UIKit

class BidToBidTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellIdentifier() -> (String) {
        return "BidToBidTableViewCell"
    }
    
    static func heightForRow() -> (CGFloat) {
        return 80
    }
    
}
