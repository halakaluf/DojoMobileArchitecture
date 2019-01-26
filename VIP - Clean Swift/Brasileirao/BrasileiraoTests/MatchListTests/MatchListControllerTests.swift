//
//  MatchListControllerTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 16/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest

@testable import Brasileirao

class MatchListControllerTests: XCTestCase {
    
    var matchListController: MatchListViewController!
    var window: UIWindow!
    
    
    class MatchListBusinessLogicSpy: MatchListBusinessLogic {
        var matches: [Match]?
        
        var fetchMatchesCalled = false
        var fetchNextMatchesCalled = false
        var fetchPreviusMatchesCalled = false
        
        func fetchMatches(request: MatchList.FetchMatches.Request.FetchMatches) {
            fetchMatchesCalled = true
        }
        
        func fetchNextMatches(request: MatchList.FetchMatches.Request.FetchNextMatches) {
            fetchNextMatchesCalled = true
        }
        
        func fetchPreviusMatches(request: MatchList.FetchMatches.Request.FetchPreviusMatches) {
            fetchPreviusMatchesCalled = true
        }
        
        func handleMatchSelection(request: MatchList.Route.Request) {
            
        }
    }
    
    class TableViewSpy: UITableView {
        
        var reloadDataCalled = false
        
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    
    func loadView() {
        window.addSubview(matchListController.view)
        RunLoop.current.run(until: Date())
    }
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        matchListController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchListViewController") as! MatchListViewController)
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func testShouldFetchMatchesWhenViewDidAppear() {
        
        // Given
        let matchListBusinessLogicSpy = MatchListBusinessLogicSpy()
        matchListController.interactor = matchListBusinessLogicSpy
        loadView()
        
        // When
        matchListController.viewDidAppear(true)
        
        // Then
        XCTAssert(matchListBusinessLogicSpy.fetchMatchesCalled, "Deveria chamar fetchMatches quando a view aparecer!")
    }
    
    func testShouldFetchNextMatchesWhenNextButtomClicked() {
        
        // Given
        let matchListBusinessLogicSpy = MatchListBusinessLogicSpy()
        matchListController.interactor = matchListBusinessLogicSpy
        loadView()
        
        // When
        matchListController.barButtonNextAction()
        
        // Then
        XCTAssert(matchListBusinessLogicSpy.fetchMatchesCalled, "Deveria chamar fetchNextMatches quando botão next é clicado!")
    }
    
    func testShouldFetchPreviewsMatchesWhenPreviewsButtomClicked() {
        
        // Given
        let matchListBusinessLogicSpy = MatchListBusinessLogicSpy()
        matchListController.interactor = matchListBusinessLogicSpy
        loadView()
        
        // When
        matchListController.barButtonPreviewsAction()
        
        // Then
        XCTAssert(matchListBusinessLogicSpy.fetchPreviusMatchesCalled, "Deveria chamar fetchNextMatches quando botão next é clicado!")
    }
    
    func testShouldDisplayFetchedMatches() {
        
        // Given
        let tableViewSpy = TableViewSpy()
        matchListController.tableView = tableViewSpy
        
        //When
        let json = """
        {
            "id": 221169, "data_realizacao": "2018-04-14T16:00", "hora_realizacao": "16:00", "placar_oficial_visitante": 1, "placar_oficial_mandante": 0, "placar_penaltis_visitante": null, "placar_penaltis_mandante": null, "equipes": {"mandante": {"id": 283, "nome_popular": "Cruzeiro", "sigla": "CRU", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/cruzeiro.svg"}, "visitante": {"id": 284, "nome_popular": "Grémio", "sigla": "GRE", "escudo": "https://s.glbimg.com/es/sde/f/equipes/2018/03/11/gremio.svg"}}, "sede": {"nome_popular": "Mineirão"}, "transmissao": {"label": "veja como foi", "url": "https://globoesporte.globo.com/mg/futebol/brasileirao-serie-a/jogo/14-04-2018/cruzeiro-gremio.ghtml"}}
        """.data(using: .utf8)!
        
        let match = try!  Match.decode(data: json)
        var displayedMatches: [MatchViewModel] = []
        displayedMatches.append(MatchViewModel.init(match: match, showSeparatorView: true))
        let viewModel = MatchList.FetchMatches.ViewModel(matches: displayedMatches, screentitle: "Rodada 1")
        matchListController.displayFetchedMatches(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Deveria chamar reloadData para carregar as partidas na TableView!")
        
        if let screenTitle = matchListController?.title {
            XCTAssertEqual(screenTitle, "Rodada 1", "O titulo tem que ser 'Rodada 1'")
        }
        
    }
}
