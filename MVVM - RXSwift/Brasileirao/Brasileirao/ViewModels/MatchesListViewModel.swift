//
//  MatchListViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

class MatchesListViewModel {
    var matches = Bindable([MatchViewModel]())
    
    let apiService = APIService.shared
    let realmService = RealmService.shared
    let showRefreshControl: Bindable = Bindable(false)
    var changeTitle: ((_ title: String) -> Void)?
    var showMsg: ((_ bgColor: UIColor, _ msg: String) -> Void)?
    var currentRound = 1
    
    func numberOfRows(_ section: Int) -> Int {
        return self.matches.value.count
    }
    
    func modelAt(_ index: Int ) -> MatchViewModel {
        return self.matches.value[index]
    }
    
    func getMatches(isRefresh: Bool) {
        let matches = realmService.loadMatches()
        if matches.count > 0 && isRefresh != true {
            self.matches.value = self.convert(matches: matches)
            return
        }
        self.showRefreshControl.value = true

        self.apiService.getMatches(round: self.currentRound, completion: { [weak self] matches in
            guard let weakSelf = self else { return }
            if let convertedMatches = matches as? [Match] {
                weakSelf.realmService.saveMatches(matches: convertedMatches)
                weakSelf.matches.value = weakSelf.convert(matches: convertedMatches)
            } else if let error = matches as? Error{
                weakSelf.showMsg?(UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), error.localizedDescription)
            } else {
                assertionFailure("Não deveria entrar aqui, pois so deve retornar [Match] ou Error")
            }
            weakSelf.showRefreshControl.value = false
        })
    }
    
    
    private func convert(matches: [Match]) -> ([MatchViewModel]) {
        var viewModelArray = [MatchViewModel]()
        for match in matches {
            let matchViewModel = MatchViewModel(match: match)
            viewModelArray.append(matchViewModel)
        }
        return viewModelArray
    }
    
    func listTitle() -> (String) {
        return "Rodada \(self.currentRound)"
    }
    
    func nextRound() {
        self.currentRound += 1
        self.getMatches(isRefresh: true)
        self.changeTitle?(self.listTitle())
    }
    
    func previusRound() {
        if (self.currentRound > 1) {
            self.currentRound -= 1
            self.getMatches(isRefresh: true)
            self.changeTitle?(self.listTitle())
        }

    }
}


