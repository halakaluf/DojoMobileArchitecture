//
//  MatchListInteractorTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 22/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest

@testable import Brasileirao

class MatchListInteractorTests: XCTestCase {

    var matchListInteractor: MatchListInteractor!
    
    override func setUp() {
        super.setUp()
        matchListInteractor = MatchListInteractor()
    }
    
    class MatchListPresentationLogicSpy: MatchListPresentationLogic {
        
        var presentFetchedMatchesCalled = false
        
        func presentFetchedMatches(response: MatchList.FetchMatches.Response.Succes) {
            presentFetchedMatchesCalled = true
        }
        
        func presentErrorOnFetch(response: MatchList.FetchMatches.Response.Error) {
            
        }
        
        func presentMatchDetails(response: MatchList.Route.Response) {
            
        }
        
    }
    
    class MatchListWorkerSpy : MatchListWorker {
        
        var fetchMatchesCalled = false
        
        override func fetchMatches(round: Int, completionHandler: @escaping (Any) -> Void) {
            fetchMatchesCalled = true
            let result = [Match]()
            completionHandler(result)
        }
    }
    
    func testFetchMatchesShouldAskWorkerToFetchMatchesAndPresenterToFormatResult() {
        // Given
        let matchListPresentationLogicSpy = MatchListPresentationLogicSpy()
        matchListInteractor.presenter = matchListPresentationLogicSpy
        let matchListWorkerSpy = MatchListWorkerSpy()
        matchListInteractor.worker = matchListWorkerSpy
        
        // When
        let request = MatchList.FetchMatches.Request.FetchMatches()
        matchListInteractor.fetchMatches(request: request)
        
        // Then
        XCTAssert(matchListWorkerSpy.fetchMatchesCalled, "fetchMatches() deve pedir ao MatchListWorker para carregar as partidas")
        XCTAssert(matchListPresentationLogicSpy.presentFetchedMatchesCalled, "fetchMatches() deve pedir ao presenter para formatar o resultado")
    }

}
