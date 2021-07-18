//
//  MatchListViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MatchesListViewModel {
    
    var matchCells:  Observable<[MatchViewModel]> {
        return cells.asObservable()
    }
    
    let apiService = APIService.shared
    let realmService = RealmService.shared
    let loadInProgress = BehaviorRelay(value: false)
    let barButtonNextAction = PublishSubject<Void>()
    let barButtonPreviewsAction = PublishSubject<Void>()

    var showMsg = PublishSubject<ShowAlertMessageConfig>()

    private var currentRound: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    private let cells = BehaviorRelay<[MatchViewModel]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {

        barButtonNextAction
            .withLatestFrom(currentRound)
            .subscribe(
                onNext: { [weak self] lastRound in
                    self?.currentRound.accept(lastRound + 1)
                    self?.getMatches(isRefresh: true)
                }
            )
            .disposed(by: disposeBag)
        
        barButtonPreviewsAction
            .withLatestFrom(currentRound)
            .subscribe(
                onNext: { [weak self] lastRound in
                    if (lastRound > 1) {
                        self?.currentRound.accept(lastRound - 1)
                        self?.getMatches(isRefresh: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    var showRefreshControl: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    var listTitle: Driver<String> {
        return currentRound.asObservable()
            .map { round -> String in
                return "Rodada \(round)"
            }.asDriver(onErrorJustReturn: "")
    }
    
    func getMatches(isRefresh: Bool) {
        let matches = realmService.loadMatches()
        if matches.count > 0 && isRefresh != true {
            self.cells.accept(self.convert(matches: matches))
            return
        }
        self.loadInProgress.accept(true)
       
        self.apiService
            .getMatches(round: self.currentRound.value)
            .subscribe(
                onNext: { [weak self] matches in

                    if let convertedMatches = matches as? [Match] {
                        self?.realmService.saveMatches(matches: convertedMatches)
                        self?.cells.accept(self?.convert(matches: convertedMatches) ?? [])
                    } else if let error = matches as? Error{
                        let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
                        self?.showMsg.onNext(config)
                    } else {
                        assertionFailure("Não deveria entrar aqui, pois so deve retornar [Match] ou Error")
                    }
                    self?.loadInProgress.accept(false)
                }, onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
                    self?.showMsg.onNext(config)
                })
            .disposed(by: disposeBag)
    }

    private func convert(matches: [Match]) -> ([MatchViewModel]) {
        var viewModelArray = [MatchViewModel]()
        for match in matches {
            let matchViewModel = MatchViewModel(match: match)
            viewModelArray.append(matchViewModel)
        }
        return viewModelArray
    }

}


