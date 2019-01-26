//
//  RealmService.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation

import RealmSwift

class RealmService {
    
    let realm = try! Realm()
    
    private init() {}
    
    public static let shared = RealmService()
    
    public func clearAllMatches() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    public func loadMatches() -> [Match] {
        return Array(realm.objects(Match.self))
    }
    
    public func saveMatches(matches: [Match]) -> (Void) {
        self.clearAllMatches()
        try! realm.write {
            realm.add(matches)
        }
    }

}
