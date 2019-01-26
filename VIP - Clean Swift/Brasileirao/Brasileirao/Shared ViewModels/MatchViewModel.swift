//
//  MatchViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 08/01/2019.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import Foundation

struct MatchViewModel {
    var title: NSAttributedString
    var scoreBoard: NSAttributedString
    var homeClubName: String
    var guestClubName: String
    var guestClubImageUrl: URL
    var homeClubImageUrl: URL
    var matchBidsUrl: String
    var showSeparatorView: Bool
    
    init(match: Match, showSeparatorView: Bool) {
        self.title = match.matchTitleText()
        self.scoreBoard = match.scoreBoardText()
        self.showSeparatorView = showSeparatorView

        self.homeClubName = match.teams?.home?.acronyms ?? ""
        self.guestClubName = match.teams?.guest?.acronyms ?? ""
    
        self.matchBidsUrl = match.transmission?.url ?? ""
        
        self.guestClubImageUrl = URL.init(clubName: match.teams?.guest?.acronyms ?? "")
        self.homeClubImageUrl = URL.init(clubName:  match.teams?.home?.acronyms ?? "")

    }
}
