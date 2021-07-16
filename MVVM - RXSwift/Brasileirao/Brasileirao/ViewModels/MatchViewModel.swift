//
//  MatchViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

struct MatchViewModel {
    let date: Date
    let stadiumName: String
    let guestClubScore: Int
    let homeClubScore: Int
    let guestClubName: String
    let homeClubName: String
    let guestClubImageUrl: URL
    let homeClubImageUrl: URL
    let matchBidsUrl: String
    var showSeparatorView: Bool
    
    func scoreBoardText() -> (NSMutableAttributedString) {
    
        let textAttributesBold = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Bold", size: 24)!
            ] as [NSAttributedString.Key : Any]
        
        let textAttributesRegular = [
            NSAttributedString.Key.foregroundColor : UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
            NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Regular", size: 14)!
            ] as [NSAttributedString.Key : Any]
        
        let attrString = NSMutableAttributedString.init()
        attrString.append(NSMutableAttributedString(string: "\(self.homeClubScore)", attributes: textAttributesBold))
        attrString.append(NSMutableAttributedString(string: "  x  ", attributes: textAttributesRegular))
        attrString.append(NSMutableAttributedString(string: "\(self.guestClubScore)", attributes: textAttributesBold))

        return attrString
    }
    
    func titleText() -> (NSMutableAttributedString) {
        
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
        
        let attrString = NSMutableAttributedString.init()
        attrString.append(NSMutableAttributedString(string: "\(dateFormatterPrintDate.string(from: self.date).uppercased())",
            attributes: textAttributesBold))
        attrString.append(NSMutableAttributedString(string: " \(self.stadiumName) ", attributes: textAttributesRegular))
        attrString.append(NSMutableAttributedString(string: "\(dateFormatterPrintHour.string(from: self.date))",
            attributes: textAttributesBold))
        
        return attrString        
    }
    
    init(match: Match) {
        self.date           = match.date
        self.guestClubScore = match.guestClubScore
        self.homeClubScore  = match.homeClubScore
        
        if let stadiumName = match.stadium?.name {
            self.stadiumName = stadiumName
        } else {
            self.stadiumName = ""
        }

        if let guestClubName = match.teams?.guest?.acronyms {
            self.guestClubName = guestClubName
            self.guestClubImageUrl = MatchViewModel.clubImageUrl(clubName: guestClubName)
        } else {
            self.guestClubName = ""
            self.guestClubImageUrl = MatchViewModel.clubImageUrl(clubName: "")
        }
        
        if let homeClubName = match.teams?.home?.acronyms {
            self.homeClubName     = homeClubName
            self.homeClubImageUrl = MatchViewModel.clubImageUrl(clubName: homeClubName)
        } else {
            self.homeClubName = ""
            self.homeClubImageUrl = MatchViewModel.clubImageUrl(clubName: "")
        }
        if let transmissionUrl = match.transmission?.url {
            self.matchBidsUrl = transmissionUrl
        } else {
            self.matchBidsUrl = ""
        }
        
        self.showSeparatorView = true
    }
    
   static func clubImageUrl(clubName: String) -> (URL) {
        switch clubName {
        case "CRU":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/cruzeiro_60x60.png")!
        case "GRE":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/gremio_60x60.png")!
        case "VIT":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/vitoria_60x60.png")!
        case "FLA":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/flamengo_60x60.png")!
        case "SAN":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/santos_60x60.png")!
        case "CEA":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/ceara_60x60.png")!
        case "AME":
            return URL.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/america_mg_60x60.png")!
        case "SPO":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/09/15/sport_60x60.png")!
        case "VAS":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/vasco_60x60.png")!
        case "CAM":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/atletico_mg_60x60.png")!
        case "COR":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/corinthians_60x60.png")!
        case "FLU":
            return URL.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/fluminense_60x60.png")!
        case "INT":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/internacional_60x60.png")!
        case "BAH":
            return URL.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/bahia_60x60.png")!
        case "CAP":
            return URL.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/atletico_pr_60x60.png")!
        case "CHA":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2015/05/06/chapecoense_60x60.png")!
        case "BOT":
            return URL.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/botafogo_60x60.png")!
        case "PAL":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/palmeiras_60x60.png")!
        case "SAO":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/sao_paulo_60x60.png")!
        case "PAR":
            return URL.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/13/parana_60x60.png")!
        case "JUV":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/juventude.png")!
        case "CUI":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/cuiaba.png")!
        case "FOR":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/fortaleza.png")!
        case "ACG":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/atletico-go.png")!
        case "BGT":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/bragantino.png")!
        case "SPT":
            return URL.init(string: "https://assets-es.imgfoot.com/media/cache/60x60/club/sport-recife.png")!
        default:
           return URL.init(string: "")!
        }
    }
}
