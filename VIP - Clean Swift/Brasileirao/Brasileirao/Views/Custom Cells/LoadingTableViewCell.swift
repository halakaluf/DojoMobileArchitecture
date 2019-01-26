//
//  LoadingTableViewCell.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> (String) {
        return "LoadingTableViewCell"
    }
    
    static func heightForRow() -> (CGFloat) {
        return 60
    }


}
