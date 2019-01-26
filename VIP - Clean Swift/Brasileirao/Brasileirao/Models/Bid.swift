//
//  Bid.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation

struct Bid: Decodable {
    let time: String
    let period: String
    let title: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case time = "tempo"
        case period = "periodo"
        case title = "titulo"
        case text = "text"
    }
    
    func textTime() -> (String) {
        if self.time.isEmpty == false {
            let timeMinSecArr = self.time.components(separatedBy: ":")
            return "\(timeMinSecArr[0])'"
        }
        return ""
    }
}
