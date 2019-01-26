//
//  APIServiceTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 08/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import XCTest


@testable import Brasileirao

class APIServiceTests: XCTestCase {

    var apiService: APIService!
    
    override func setUp() {
        self.apiService = APIService.shared
    }

    func testGetMatches() {
        var response: Any?
        
        let expectation = self.expectation(description: "Deve ser feito a carga das partidas")
        
        self.apiService.getMatches(round: 1, completion: { result in
            response = result
            expectation.fulfill()
        })
        waitForExpectations(timeout: 30, handler: nil)
        if !(response is [Match]) {
            XCTFail("Deveria ser um array de Match")
        }
        
    }
    
    func testGetBids() {
        var response: Any?
        let expectation = self.expectation(description: "Deve ser feito a carga do resumo da partida")
        
        let url = "https://globoesporte.globo.com/sp/santos-e-regiao/futebol/brasileirao-serie-a/jogo/14-04-2018/santos-ceara.ghtml"
        self.apiService.getMatchResume(url: url, completion: { result in
            response = result
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 30, handler: nil)
        if !(response is [Bid]) {
            XCTFail("Deveria ser um array de Bid")
        }

    }
}
