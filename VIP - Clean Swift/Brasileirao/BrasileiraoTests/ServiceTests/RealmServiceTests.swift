//
//  RealmServiceTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 08/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest

@testable import Brasileirao

class RealmServiceTests: XCTestCase {

    var realmService: RealmService!
    var match: Match!
    
    override func setUp() {
        self.realmService = RealmService.shared
        self.realmService.clearAllMatches()
        
        let json = """
        {
            "id": 221169, "data_realizacao": "2018-04-14T16:00", "hora_realizacao": "16:00", "placar_oficial_visitante": 1, "placar_oficial_mandante": 0, "placar_penaltis_visitante": null, "placar_penaltis_mandante": null, "equipes": {"mandante": {"id": 283, "nome_popular": "Cruzeiro", "sigla": "CRU", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/cruzeiro.svg"}, "visitante": {"id": 284, "nome_popular": "Grémio", "sigla": "GRE", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/gremio.svg"}}, "sede": {"nome_popular": "Mineirão"}, "transmissao": {"label": "veja como foi", "url": "https://globoesporte.globo.com/mg/futebol/brasileirao-serie-a/jogo/14-04-2018/cruzeiro-gremio.ghtml"}}
        """.data(using: .utf8)! 
        
        self.match = try!  Match.decode(data: json)
    }
    
    func testDecodingMatch() {
        
        XCTAssertEqual(self.match.id, 221169)
    }
    
    func testMatchSave() {
        var matches = [Match]()
        matches.append(self.match)
        realmService.saveMatches(matches: matches)
        let loadedMatches = realmService.loadMatches()
        
        XCTAssertEqual(loadedMatches.count, 1)
        XCTAssertEqual(loadedMatches.first?.id, 221169)
    }
    
    override func tearDown() {
        self.realmService.clearAllMatches()
    }

}
