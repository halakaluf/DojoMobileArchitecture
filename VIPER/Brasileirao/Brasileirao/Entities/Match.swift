//
//  Match.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Match: Object, Decodable  {
    
    @objc dynamic var id             = 0
    @objc dynamic var date           = Date()
    @objc dynamic var stadium:       Stadium?
    @objc dynamic var guestClubScore = 0
    @objc dynamic var homeClubScore  = 0
    @objc dynamic var teams:         Teams?
    @objc dynamic var transmission:  Transmission?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date           = "data_realizacao"
        case stadium        = "sede"
        case guestClubScore = "placar_oficial_visitante"
        case homeClubScore  = "placar_oficial_mandante"
        case teams          = "equipes"
        case transmission   = "transmissao"
    }

}

class Stadium: Object, Decodable {
    @objc dynamic var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "nome_popular"
    }
}


class Teams: Object, Decodable {
    @objc dynamic var home: Club?
    @objc dynamic var guest: Club?
    
    enum CodingKeys: String, CodingKey {
        case home   = "mandante"
        case guest  = "visitante"
    }
}

class Club: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var popularName:  String
    @objc dynamic var acronyms:     String
    @objc dynamic var clubImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularName  = "nome_popular"
        case acronyms     = "sigla"
        case clubImageUrl = "escudo"
    }
}

class Transmission: Object, Decodable {
    @objc dynamic var url: String
}

extension Match: MatchViewItemInterface {
    
    var scoreBoard: NSAttributedString? {
        return scoreBoardText()
    }
    
    var homeClubName: String? {
        return self.teams?.home?.acronyms
    }
    
    var guestClubName: String? {
        return self.teams?.guest?.acronyms
    }
    
    var guestClubImageUrl: URL? {
        return URL.init(clubName: self.teams?.guest?.acronyms ?? "")
    }
    
    var homeClubImageUrl: URL? {
        return URL.init(clubName: self.teams?.home?.acronyms ?? "")
    }
    
    var matchBidsUrl: String? {
        return self.transmission?.url
    }
    
    var title: NSAttributedString? {
        return matchTitleText()
    }
    

}

