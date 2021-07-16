//
//  MatchDetailViewModelTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 21/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import XCTest
@testable import Brasileirao

class MatchDetailViewModelTests: XCTestCase {

    var match: Match!
    
    override func setUp() {
        
        let json = """
        {
            "id": 221169, "data_realizacao": "2018-04-14T16:00", "hora_realizacao": "16:00", "placar_oficial_visitante": 1, "placar_oficial_mandante": 0, "placar_penaltis_visitante": null, "placar_penaltis_mandante": null, "equipes": {"mandante": {"id": 283, "nome_popular": "Cruzeiro", "sigla": "CRU", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/cruzeiro.svg"}, "visitante": {"id": 284, "nome_popular": "Grémio", "sigla": "GRE", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/gremio.svg"}}, "sede": {"nome_popular": "Mineirão"}, "transmissao": {"label": "veja como foi", "url": "https://globoesporte.globo.com/mg/futebol/brasileirao-serie-a/jogo/14-04-2018/cruzeiro-gremio.ghtml"}}
        """.data(using: .utf8)!
        
        self.match = try!  Match.decode(data: json)
    }
    
    func testDetailViewModelTitle() {
        let matchViewModel  = MatchViewModel(match: self.match)
        let detailViewModel = MatchDetailViewModel(matchViewModel: matchViewModel)
        XCTAssertEqual(detailViewModel.detailTitle(), "CRU x GRE")
    }

}
