//
//  MatchDetailViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 19/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MatchDetailViewModel {
    
    enum MatchDetailTableViewCellType {
        case matchCell(cellViewModel: MatchViewModel)
        case bidCell(cellViewModel: BidViewModel)
        case bidToBidCell
        case loadingCell(loading: String)
    }

    var bidCells: Observable<[MatchDetailTableViewCellType]> {
        return cells.asObservable()
    }
    var match : MatchViewModel
    var showMsg = PublishSubject<ShowAlertMessageConfig>()
    let hideMsg = PublishSubject<Void>()
    let apiService = APIService.shared
    var loadingTimer: Timer?

    
    lazy private var cells: BehaviorRelay<[MatchDetailTableViewCellType]> = BehaviorRelay<[MatchDetailTableViewCellType]>(value: initMatchDataSource(withLoading: true))
    
    init(matchViewModel: MatchViewModel) {
        self.match = matchViewModel
        self.match.showSeparatorView = false
        //usado para disparar o showWaitingMsg pq a api do heroku na primeira chamada demora muito para responder
        //pq a maquina pode estar off
        self.loadingTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: (#selector(self.showWaitingMsg)), userInfo: nil, repeats: true)
    }
    
   
    func detailTitle() -> (String) {
        return "\(self.match.homeClubName) x \(self.match.guestClubName)"
    }
    
    func getMatchResume() {
        self.apiService.getMatchResume(url: self.match.matchBidsUrl)
            .subscribe(
                onNext: { [weak self] bids in
                    var matchDetailTableViewDataSource = self?.initMatchDataSource(withLoading: false)
                    if let bidsArr = bids as? [Bid] {
                        for bid in bidsArr {
                            let bidViewModel = BidViewModel(bid: bid)
                            matchDetailTableViewDataSource?.append(MatchDetailTableViewCellType.bidCell(cellViewModel: bidViewModel))
                        }
                    } else if let error = bids as? Error {
                        let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
                        self?.showMsg.onNext(config)
                    } else {
                        assertionFailure("Não deveria entrar aqui, pois so deve retornar [Bid] ou Error")
                    }
                    self?.hideMsg.onNext(())
                    self?.cells.accept(matchDetailTableViewDataSource ?? [])
                    self?.loadingTimer?.invalidate()
                },
                onError:{ [weak self] error in
                    self?.loadingTimer?.invalidate()
                    let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
                    self?.showMsg.onNext(config)
                    self?.loadingTimer?.invalidate()
                }
            )
    }
    
    @objc private func showWaitingMsg() {
        let options = ["Estamos carregando ainda...", "Lembra que essa api ta no heroku!", "Só mais um pouco...", "Paciência é uma virtude!", "O tempo é um processo de espera!"]
        let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 213/255, green: 230/255, blue: 23/255, alpha: 1), message: options.randomElement()!)
        self.showMsg.onNext(config)
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
