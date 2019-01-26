//
//  MatchTableViewCell.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var homeClubName: UILabel!
    @IBOutlet weak var guestClubName: UILabel!
    @IBOutlet weak var scoreBoard: UILabel!
    @IBOutlet weak var guestClubImage: UIImageView!
    @IBOutlet weak var homeClubImage: UIImageView!
    @IBOutlet weak var separatorView: UIView!


    func configure(with viewModel: MatchViewItemInterface, hasSeparatorView: Bool) -> (Void) {
        self.titleCell.attributedText   = viewModel.title
        self.scoreBoard.attributedText  = viewModel.scoreBoard
        self.homeClubName.text          = viewModel.homeClubName
        self.guestClubName.text         = viewModel.guestClubName
        
        if let guestImageUrl = viewModel.guestClubImageUrl {
            self.loadImage(url: guestImageUrl, imageView: self.guestClubImage)
        }
        
        if let homeImageUrl = viewModel.homeClubImageUrl {
            self.loadImage(url: homeImageUrl, imageView: self.homeClubImage)
        }
        
        self.separatorView.isHidden = !hasSeparatorView
    }
    
    
    private func loadImage(url: URL, imageView: UIImageView) -> (Void) {
        
        imageView.sd_setImage(with: url, completed: { [weak imageView] (image, error, cacheType, imageURL) in
            if error == nil && cacheType == SDImageCacheType.none {
                imageView?.alpha = 0
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                    imageView?.alpha = 1
                    imageView?.image = image
                }, completion: nil)
            }
        })
        
    }
    
    static func cellIdentifier() -> (String) {
        return "MatchTableViewCell"
    }
    
    static func heightForRow() -> (CGFloat) {
        return 100
    }

}

