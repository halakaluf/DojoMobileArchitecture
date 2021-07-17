//
//  BidTableViewCell.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import UIKit

let matchTimeHeight: Double = 37
let titleCellHeight: Double = 18.5

class BidTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var matchPeriod: UILabel!
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var titleCellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchTimeHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: BidViewModel? {
        didSet {
            configure()
        }
    }
    
    func configure() -> (Void) {
        if let viewModel = viewModel {
            if viewModel.title.isEmpty {
                self.titleCellHeightConstraint.constant = 0
            } else {
                self.titleCellHeightConstraint.constant = CGFloat(titleCellHeight)
            }
            self.titleCell.text = viewModel.title
            self.descriptionCell.text = viewModel.text

            self.matchPeriod.text = viewModel.period
            if viewModel.textTime().isEmpty {
                self.matchTimeHeightConstraint.constant = 0
            } else {
                self.matchTimeHeightConstraint.constant = CGFloat(matchTimeHeight)
            }
            self.matchTime.text = viewModel.textTime()
            self.layoutIfNeeded()
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> (String) {
        return "BidTableViewCell"
    }
    
    static func heightForRow() -> (CGFloat) {
        return 100
    }
    
}
