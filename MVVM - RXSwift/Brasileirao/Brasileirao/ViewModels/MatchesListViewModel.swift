//
//  MatchListViewModel.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities

protocol ViewModelInputs {
    var barButtonNextAction: PublishSubject<Void> { get }
    var barButtonPreviewsAction: PublishSubject<Void> { get }
    var getMatchesAction: PublishSubject<Bool> { get }
    var reloadMatchesAction: PublishSubject<Bool> { get }
}

protocol ViewModelOutputs {
    var listTitle: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
    var alertError: Driver<ShowAlertMessageConfig?> { get }
    var matchCells: Driver<[MatchViewModel]> { get }
}

protocol ViewModelProtocol {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}

class MatchesListViewModel: ViewModelInputs, ViewModelProtocol {
    var inputs: ViewModelInputs { return self }
    var outputs: ViewModelOutputs { return self }
    
    let barButtonNextAction = PublishSubject<Void>()
    let barButtonPreviewsAction = PublishSubject<Void>()
    let getMatchesAction = PublishSubject<Bool>()
    let reloadMatchesAction = PublishSubject<Bool>()
    
//    var matchCells:  Observable<[MatchViewModel]> {
//        return cells.asObservable()
//    }
    
//    let apiService = APIService.shared
    private let realmService = RealmService.shared
//    let loadInProgress = BehaviorRelay(value: false)
   
//    var changeTitle = PublishSubject<String>()
//    var showMsg = PublishSubject<ShowAlertMessageConfig>()

    private var showMsgAlert = BehaviorRelay<ShowAlertMessageConfig?>(value: nil)

    private var matchesObservable: Observable<Result<[Match]>>
    
//    var currentRound = 1
    private let activityIndicator: ActivityIndicator
    private var currentRoundBehavior: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    
    private let cells = BehaviorRelay<[MatchViewModel]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        
        let activityIndicator = ActivityIndicator()
        self.activityIndicator = activityIndicator
        let realm = self.realmService
        
        let actionTriggers = Observable.of(getMatchesAction, reloadMatchesAction).merge()
        let matchesTriggers = Observable
            .combineLatest(actionTriggers, currentRoundBehavior) {
                (isRefresh: $0, round: $1)
            }.share()
        
        matchesObservable = matchesTriggers
            .flatMap({ result -> Observable<Result<[Match]>> in
//                let matches = realm.loadMatches()
//                if matches.count > 0 && result.isRefresh != true {
//                    return Observable.of(Result.success(matches))
//                }
                return APIServiceRx.rx.getMatches(round: result.round)
                    .trackActivity(activityIndicator)
            }).share()
        
        matchesObservable
            .filter({ $0.value != nil })
            .map({ $0.value! })
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                realm.saveMatches(matches: value)
            }).disposed(by: disposeBag)
        
        matchesObservable
            .filter({ $0.value != nil })
            .map({ $0.value! })
            .map({ $0.map(MatchViewModel.init)})
            .bind(to: cells)
            .disposed(by: disposeBag)
            
        matchesObservable
            .filter({ $0.failure != nil })
            .map({ $0.failure! })
            .map({ error -> ShowAlertMessageConfig in
                return ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
            })
            .bind(to: showMsgAlert)
            .disposed(by: disposeBag)

        barButtonNextAction
            .withLatestFrom(currentRoundBehavior)
            .subscribe(
                onNext: { [weak self] lastRound in
                    guard let this = self else { return }
                    this.currentRoundBehavior.accept(lastRound + 1)
                    this.getMatchesAction.onNext(true)
                }
            )
            .disposed(by: disposeBag)
        
        barButtonPreviewsAction
            .withLatestFrom(currentRoundBehavior)
            .subscribe(
                onNext: { [weak self] lastRound in
                    guard let this = self else { return }
                    if (lastRound > 1) {
                        this.currentRoundBehavior.accept(lastRound - 1)
                        this.getMatchesAction.onNext(true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
//    var showRefreshControl: Observable<Bool> {
//        return loadInProgress
//            .asObservable()
//            .distinctUntilChanged()
//    }
    
//    func getMatches(isRefresh: Bool) {
//        let matches = realmService.loadMatches()
//        if matches.count > 0 && isRefresh != true {
//            self.cells.accept(self.convert(matches: matches))
//            return
//        }
//        self.loadInProgress.accept(true)
//       
//        self.apiService
//            .getMatches(round: self.currentRound)
//            .subscribe(
//                onNext: { [weak self] matches in
//
//                    if let convertedMatches = matches as? [Match] {
//                        self?.realmService.saveMatches(matches: convertedMatches)
//                        self?.cells.accept(self?.convert(matches: convertedMatches) ?? [])
//                    } else if let error = matches as? Error{
//                        let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
//                        self?.showMsg.onNext(config)
//                    } else {
//                        assertionFailure("Não deveria entrar aqui, pois so deve retornar [Match] ou Error")
//                    }
//                    self?.loadInProgress.accept(false)
//                }, onError: { [weak self] error in
//                    self?.loadInProgress.accept(false)
//                    let config = ShowAlertMessageConfig(bgColor: UIColor.init(red: 250/255, green: 80/255, blue: 80/255, alpha: 1), message: error.localizedDescription)
//                    self?.showMsg.onNext(config)
//                })
//            .disposed(by: disposeBag)
//    }
//    
    
    
//    private func convert(matches: [Match]) -> ([MatchViewModel]) {
//        var viewModelArray = [MatchViewModel]()
//        for match in matches {
//            let matchViewModel = MatchViewModel(match: match)
//            viewModelArray.append(matchViewModel)
//        }
//        return viewModelArray
//    }
    
//    func listTitle() -> (String) {
//        return "Rodada \(self.currentRound)"
//    }
    
//    @objc func nextRound() {
//        self.currentRound += 1
//        self.getMatches(isRefresh: true)
//        self.changeTitle.onNext(self.listTitle())
//    }
    
//    func previusRound() {
//        if (self.currentRound > 1) {
//            self.currentRound -= 1
//            self.getMatches(isRefresh: true)
//            self.changeTitle.onNext(self.listTitle())
//        }
//
//    }
}

extension MatchesListViewModel: ViewModelOutputs {
    var matchCells: Driver<[MatchViewModel]> {
        return cells.asObservable().asDriver(onErrorJustReturn: [])
    }
    
    var alertError: Driver<ShowAlertMessageConfig?> {
        return showMsgAlert.asObservable()
            .map({ $0 })
            .asDriver(onErrorJustReturn: nil)
    }
    
    var isLoading: Driver<Bool> {
        return activityIndicator
            .distinctUntilChanged()
            .map({ $0 })
            .asDriver(onErrorJustReturn: false)
    }
    
    var listTitle: Driver<String> {
        return currentRoundBehavior.asObservable()
            .map { round -> String in
                return "Rodada \(round)"
            }.asDriver(onErrorJustReturn: "")
    }
}
