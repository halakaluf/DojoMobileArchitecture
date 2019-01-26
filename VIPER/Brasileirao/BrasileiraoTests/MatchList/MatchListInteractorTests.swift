//
//  MatchListInteractorTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Leonardo Barros Martinez on 1/24/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest
@testable import Brasileirao

class MatchListInteractorTests: XCTestCase {

    var matchListInteractor: MatchListInteractor!
    var realmService: RealmService!
    
    override func setUp() {
        super.setUp()
        matchListInteractor = MatchListInteractor()
        realmService = RealmService.shared
        realmService.clearAllMatches()
    }

    override func tearDown() {
        realmService.clearAllMatches()
    }

    func testFetchMatchesSaveInRealm() {
        
        var response: [Match]?
        
        let expectation = self.expectation(description: "Deve ser feito a carga das partidas")

        matchListInteractor.fetchMatches(round: 1, completionHandler: { result in

            expectation.fulfill()
            if let matches = result as? [Match] {
                response = matches
            } else if let error = result as? Error {
                XCTFail(error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 30, handler: nil)
        
        let realmLoadedMatches = matchListInteractor.loadMatches()
        XCTAssertEqual(response?.first?.id, realmLoadedMatches.first?.id)
        

    }

}
