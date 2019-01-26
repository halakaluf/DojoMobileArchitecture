//
//  MatchListPresenter.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 22/01/19.
//  Copyright (c) 2019 Fabio Martinez. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class MatchListPresenter {

    // MARK: - Private properties -

    private unowned let _view: MatchListViewInterface
    private let _wireframe: MatchListWireframeInterface
    private let _interactor: MatchListInteractorInterface

    var matches = [Match]()
    private var currentRound = 1
    
    // MARK: - Lifecycle -
  
    init(wireframe: MatchListWireframeInterface, view: MatchListViewInterface, interactor: MatchListInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
    
    private func fetchMatches(round: Int) {
        _interactor.fetchMatches(round: round, completionHandler: { [weak self] result in
            guard let weakSelf = self else { return }
            if let matches = result as? [Match] {
                weakSelf.matches = matches
            } else if let error = result as? Error {
                let realmMatches = weakSelf._interactor.loadMatches()
                weakSelf.matches = realmMatches
                let bgColorRed = UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1)
                weakSelf._view.displayMessage(bgColor: bgColorRed, msg: error.localizedDescription)
            }
            weakSelf._view.displayFetchedMatches(screentitle: weakSelf.screenTitle(round: weakSelf.currentRound))
        })
    }
    
    private func screenTitle(round: Int) -> (String) {
        return "Rodada \(round)"
    }
    
}

// MARK: - Extensions -

extension MatchListPresenter: MatchListPresenterInterface {
    
    func viewDidLoad() {
        self._view.setLoadingVisible(true)
        fetchMatches(round: currentRound)
    }
    
    func numberOfItems() -> Int {
        return matches.count
    }
    
    func item(at indexPath: IndexPath) -> MatchViewItemInterface {
        return matches[indexPath.row]
    }
    
    func fetchMatches() {
        fetchMatches(round: currentRound)
    }
    
    func fetchNextMatches() {
        currentRound += 1
        fetchMatches(round: currentRound)
    }
    
    func fetchPreviusMatches() {
        if (currentRound > 1) {
            currentRound -= 1
            fetchMatches(round: currentRound)
        }
    }
    
    func handleMatchSelection(at indexPath: IndexPath) {
        let selectedMatch = matches[indexPath.row]
        _wireframe.navigate(to: .matchDetails(selectedMatch))
    }
    
}
