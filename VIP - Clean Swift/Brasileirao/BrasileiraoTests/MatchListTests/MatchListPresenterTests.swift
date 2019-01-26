//
//  MatchListPresenterTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 22/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest

@testable import Brasileirao

class MatchListPresenterTests: XCTestCase {

     var matchListPresenter: MatchListPresenter!
    
    override func setUp() {
        super.setUp()
        matchListPresenter = MatchListPresenter()
    }

    class MatchListDisplayLogicSpy: MatchListDisplayLogic {
        
        var displayFetchedMatchesCalled = false
        var showMatchDetailsCalled = false
        var displayMessageCalled = false
        
        func displayFetchedMatches(viewModel: MatchList.FetchMatches.ViewModel) {
            displayFetchedMatchesCalled = true
        }
        
        func showMatchDetails(viewModel: MatchList.Route.ViewModel) {
            
        }
        
        func displayMessage(viewModel: MatchList.FetchMatches.ViewModel.MessageViewModel) {
            
        }
        
        func displayRefreshControl(viewModel: MatchList.FetchMatches.ViewModel.RefreshViewModel) {
            
        }

    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders() {
        // Given
        let matchListDisplayLogicSpy = MatchListDisplayLogicSpy()
        matchListPresenter.viewController = matchListDisplayLogicSpy
        
        //When
        let json = """
        {
            "id": 221169, "data_realizacao": "2018-04-14T16:00", "hora_realizacao": "16:00", "placar_oficial_visitante": 1, "placar_oficial_mandante": 0, "placar_penaltis_visitante": null, "placar_penaltis_mandante": null, "equipes": {"mandante": {"id": 283, "nome_popular": "Cruzeiro", "sigla": "CRU", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/cruzeiro.svg"}, "visitante": {"id": 284, "nome_popular": "Grémio", "sigla": "GRE", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/gremio.svg"}}, "sede": {"nome_popular": "Mineirão"}, "transmissao": {"label": "veja como foi", "url": "https://globoesporte.globo.com/mg/futebol/brasileirao-serie-a/jogo/14-04-2018/cruzeiro-gremio.ghtml"}}
        """.data(using: .utf8)!
        
        let match = try!  Match.decode(data: json)
        let response = MatchList.FetchMatches.Response.Succes.init(matches: [match], round: 1)
        matchListPresenter.presentFetchedMatches(response: response)
        
        // Then
        XCTAssert(matchListDisplayLogicSpy.displayFetchedMatchesCalled, "Presenting fetched matches should ask view controller to display them")
    }

}
