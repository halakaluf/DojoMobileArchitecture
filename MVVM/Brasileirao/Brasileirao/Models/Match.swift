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
    
    override init() {
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let stadium =  try values.decodeIfPresent(Stadium.self, forKey: .stadium) {
            self.stadium = stadium
        }else {
            self.stadium = nil
        }
        
        if let teams =  try values.decodeIfPresent(Teams.self, forKey: .teams) {
            self.teams = teams
        }else {
            self.teams = nil
        }
        
        if let transmission =  try values.decodeIfPresent(Transmission.self, forKey: .transmission) {
            self.transmission = transmission
        }else {
            self.transmission = nil
        }
        
        if let guestClubScore =  try values.decodeIfPresent(Int.self, forKey: .guestClubScore) {
            self.guestClubScore = guestClubScore
        }else {
            self.guestClubScore = 0
        }
        
        if let homeClubScore =  try values.decodeIfPresent(Int.self, forKey: .homeClubScore) {
            self.homeClubScore = homeClubScore
        }else {
            self.homeClubScore = 0
        }
        
        
        
        if let date =  try values.decodeIfPresent(Date.self, forKey: .date) {
            self.date = date
        }else {
            self.date = Date()
        }
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
    @objc dynamic var popularName: String
    @objc dynamic var acronyms: String
    @objc dynamic var clubImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularName    = "nome_popular"
        case acronyms       = "sigla"
        case clubImageUrl   = "escudo"
    }
}

class Transmission: Object, Decodable {
    @objc dynamic var url: String
}
