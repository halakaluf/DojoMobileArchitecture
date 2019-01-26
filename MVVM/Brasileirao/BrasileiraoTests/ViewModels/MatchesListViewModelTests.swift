//
//  MatchesListViewModelTests.swift
//  BrasileiraoTests
//
//  Created by Fabio Martinez on 25/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import XCTest
@testable import Brasileirao

class MatchesListViewModelTests: XCTestCase {

    func testTitle() {
        let matchesViewModel = MatchesListViewModel()
        matchesViewModel.getMatches(isRefresh: false)
        XCTAssertEqual(matchesViewModel.listTitle(), "Rodada 1")
        matchesViewModel.nextRound()
        XCTAssertEqual(matchesViewModel.listTitle(), "Rodada 2")
        matchesViewModel.previusRound()
        matchesViewModel.previusRound()
        matchesViewModel.previusRound()
        XCTAssertEqual(matchesViewModel.listTitle(), "Rodada 1")
    }


}
