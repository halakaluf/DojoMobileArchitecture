//
//  BidViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation

struct BidViewModel {
    let period: String
    let time: String
    let title: String
    let text: String
    
    
    init(bid: Bid) {
        self.period = bid.period
        self.time   = bid.time
        self.title  = bid.title
        self.text   = bid.text
    }
    
    func textTime() -> (String) {
        if self.time.isEmpty == false {
            let timeMinSecArr = self.time.components(separatedBy: ":")
            return "\(timeMinSecArr[0])'"
        }
        return ""
    }
}
