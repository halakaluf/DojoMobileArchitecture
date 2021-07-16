//
//  MatchViewModelTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 25/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import XCTest
@testable import Brasileirao

class MatchViewModelTests: XCTestCase {
    
    var match: Match!
    var matchViewModel: MatchViewModel!
    
    override func setUp() {
        let json = """
        {
            "id": 221169, "data_realizacao": "2018-04-14T16:00", "hora_realizacao": "16:00", "placar_oficial_visitante": 1, "placar_oficial_mandante": 0, "placar_penaltis_visitante": null, "placar_penaltis_mandante": null, "equipes": {"mandante": {"id": 283, "nome_popular": "Cruzeiro", "sigla": "CRU", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/cruzeiro.svg"}, "visitante": {"id": 284, "nome_popular": "Grémio", "sigla": "GRE", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/gremio.svg"}}, "sede": {"nome_popular": "Mineirão"}, "transmissao": {"label": "veja como foi", "url": "https://globoesporte.globo.com/mg/futebol/brasileirao-serie-a/jogo/14-04-2018/cruzeiro-gremio.ghtml"}}
        """.data(using: .utf8)!
        
        self.match = try!  Match.decode(data: json)
        self.matchViewModel = MatchViewModel(match: self.match)
    }
    
    func testMatchTitle() {
        let strTitle = self.matchViewModel.titleText().string
        XCTAssertEqual(strTitle, "SÁB 14/04/2018 Mineirão 16:00")
    }
    
    func testMatchScoreBoardText() {
        let strScoreBoard = matchViewModel.scoreBoardText().string
        XCTAssertEqual(strScoreBoard, "0  x  1")
    }
}
