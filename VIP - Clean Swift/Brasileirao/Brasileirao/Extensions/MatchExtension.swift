//
//  MatchExtension.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 08/01/2019.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

extension Match {
    
    func scoreBoardText() -> (NSAttributedString) {
        
        let textAttributesBold = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Bold", size: 24)!
            ] as [NSAttributedString.Key : Any]
        
        let textAttributesRegular = [
            NSAttributedString.Key.foregroundColor : UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Regular", size: 14)!
            ] as [NSAttributedString.Key : Any]
        
        let attrString = NSMutableAttributedString.init()
        attrString.append(NSMutableAttributedString(string: "\(homeClubScore)", attributes: textAttributesBold))
        attrString.append(NSMutableAttributedString(string: "  x  ", attributes: textAttributesRegular))
        attrString.append(NSMutableAttributedString(string: "\(guestClubScore)", attributes: textAttributesBold))
        
        return attrString
    }
    
    func matchTitleText() -> (NSAttributedString) {
        let textAttributesBold = [
            NSAttributedString.Key.foregroundColor : UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Bold", size: 18)!
            ] as [NSAttributedString.Key : Any]

        let textAttributesRegular = [
            NSAttributedString.Key.foregroundColor : UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Regular", size: 18)!
            ] as [NSAttributedString.Key : Any]

        let dateFormatterPrintDate = DateFormatter()
        dateFormatterPrintDate.locale = Locale.init(identifier: "pt_BR")
        dateFormatterPrintDate.dateFormat = "EEE dd/MM/yyyy"
        dateFormatterPrintDate.timeZone = TimeZone(identifier: "UTC")

        let dateFormatterPrintHour = DateFormatter()
        dateFormatterPrintHour.dateFormat = "HH:mm"
        dateFormatterPrintHour.timeZone = TimeZone(identifier: "UTC")

        var stadiumName = ""
        if let stadium = stadium {
            stadiumName = stadium.name
        }

        let attrString = NSMutableAttributedString.init()
        attrString.append(NSMutableAttributedString(string: "\(dateFormatterPrintDate.string(from: date).uppercased())",
            attributes: textAttributesBold))
        attrString.append(NSMutableAttributedString(string: " \(stadiumName) ",
            attributes: textAttributesRegular))
        attrString.append(NSMutableAttributedString(string: "\(dateFormatterPrintHour.string(from: date))",
            attributes: textAttributesBold))

        return attrString
    }
    
    
    
}
