//
//  MatchDetailViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

class MatchDetailViewModel {
    
    enum MatchDetailTableViewCellType {
        case matchCell(cellViewModel: MatchViewModel)
        case bidCell(cellViewModel: BidViewModel)
        case bidToBidCell
        case loadingCell(loading: String)
    }
    
    var bids = Bindable([Any]())
    var matchDetailTableViewDataSource = [MatchDetailTableViewCellType]()
    var match : MatchViewModel
    var showMsg: ((_ bgColor: UIColor, _ msg: String) -> Void)?
    var hideMsg: (() -> Void)?
    let apiService = APIService.shared
    var loadingTimer: Timer?

    
    init(matchViewModel: MatchViewModel) {
        self.bids  = Bindable([MatchDetailTableViewCellType]())
        self.match = matchViewModel
        self.match.showSeparatorView = false
        //usado para disparar o showWaitingMsg pq a api do heroku na primeira chamada demora muito para responder
        //pq a maquina pode estar off
        self.loadingTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: (#selector(self.showWaitingMsg)), userInfo: nil, repeats: true)
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.bids.value.count
    }
    
    func bidModelAt(_ index: Int ) -> MatchDetailTableViewCellType {
        return self.bids.value[index] as! MatchDetailViewModel.MatchDetailTableViewCellType
    }
    
    func detailTitle() -> (String) {
        return "\(self.match.homeClubName) x \(self.match.guestClubName)"
    }
    
    func getMatchResume() {
        self.bids.value = self.initMatchDataSource(withLoading: true)
        
        self.apiService.getMatchResume(url: self.match.matchBidsUrl, completion: { [weak self] bids in
            guard let weakSelf = self else { return }
            weakSelf.loadingTimer?.invalidate()
            if let bidsArr = bids as? [Bid] {
                weakSelf.matchDetailTableViewDataSource = weakSelf.initMatchDataSource(withLoading: false)
                for bid in bidsArr {
                    let bidViewModel = BidViewModel(bid: bid)
                    weakSelf.matchDetailTableViewDataSource.append(MatchDetailTableViewCellType.bidCell(cellViewModel: bidViewModel))
                }
                weakSelf.bids.value = (self?.matchDetailTableViewDataSource)!
                weakSelf.hideMsg?()
            } else if let error = bids as? Error {
                weakSelf.showMsg?(UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), error.localizedDescription)
                weakSelf.bids.value = weakSelf.initMatchDataSource(withLoading: false)
            } else {
                assertionFailure("Não deveria entrar aqui, pois so deve retornar [Bid] ou Error")
            }
        })
    }
    
    @objc private func showWaitingMsg() {
        let options = ["Estamos carregando ainda...", "Lembra que essa api ta no heroku!", "Só mais um pouco...", "Paciência é uma virtude!", "O tempo é um processo de espera!"]
        self.showMsg?(UIColor.init(red: 213/255, green: 230/255, blue: 23/255, alpha: 1), options.randomElement()!)
    }
    
    private func initMatchDataSource(withLoading: Bool) -> ([MatchDetailTableViewCellType]) {
        var dataSource = [MatchDetailTableViewCellType]()
        dataSource.append(MatchDetailTableViewCellType.matchCell(cellViewModel: self.match))
        dataSource.append(MatchDetailTableViewCellType.bidToBidCell)
        if withLoading == true {
            dataSource.append(MatchDetailTableViewCellType.loadingCell(loading: ""))
        }
        return dataSource
    }
    
}
