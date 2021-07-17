//
//  MatchDetailViewController.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MatchDetailViewController: UIViewController {
    var matchDetailViewModel: MatchDetailViewModel?
    var alertView = AlertMessageView()
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
        self.bindViewModel()
        self.matchDetailViewModel?.getMatchResume()
        self.configureView()
    }

    func configureTable() -> (Void) {
        let bidNib = UINib(nibName: BidTableViewCell.cellIdentifier(), bundle: nil)
        let LoadingNib = UINib(nibName: LoadingTableViewCell.cellIdentifier(), bundle: nil)
        let matchNib = UINib(nibName: MatchTableViewCell.cellIdentifier(), bundle: nil)
        let bidToBidNib = UINib(nibName: BidToBidTableViewCell.cellIdentifier(), bundle: nil)
        self.tableView.register(matchNib, forCellReuseIdentifier: MatchTableViewCell.cellIdentifier())
        self.tableView.register(bidNib, forCellReuseIdentifier: BidTableViewCell.cellIdentifier())
        self.tableView.register(LoadingNib, forCellReuseIdentifier: LoadingTableViewCell.cellIdentifier())
        self.tableView.register(bidToBidNib, forCellReuseIdentifier: BidToBidTableViewCell.cellIdentifier())
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = BidTableViewCell.heightForRow()
    }

    func bindViewModel() {
        
        self.matchDetailViewModel?
            .bidCells
            .bind(to: self.tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                    case .matchCell(let matchViewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.cellIdentifier(), for: indexPath) as! MatchTableViewCell
                        cell.viewModel = matchViewModel
                        return cell
                    case .bidToBidCell:
                        let cell = tableView.dequeueReusableCell(withIdentifier: BidToBidTableViewCell.cellIdentifier(), for: indexPath) as! BidToBidTableViewCell
                        return cell
                    case .bidCell(let bidViewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: BidTableViewCell.cellIdentifier(), for: indexPath) as! BidTableViewCell
                        cell.viewModel = bidViewModel
                        return cell
                    case .loadingCell:
                        let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellIdentifier(), for: indexPath) as! LoadingTableViewCell
                        return cell
                }
            }.disposed(by: disposeBag)

        self.matchDetailViewModel?
            .showMsg
            .map { [weak self] in self?.showMessage(configData: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        self.matchDetailViewModel?
            .hideMsg
            .map { [weak self] in self?.alertView.hideAlertMessageAnim() }
            .subscribe()
            .disposed(by: disposeBag)

    }
    
    func configureView() -> (Void) {
        self.navigationItem.title = self.matchDetailViewModel?.detailTitle()
        self.alertMessage = self.makeShowMsgView()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.alertView)
        window.bringSubviewToFront(self.alertView)
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }

}

extension MatchDetailViewController: AlertMessageDialogPresenter {
    var alertMessage: AlertMessageView {
        get {
            return self.alertView
        }
        set(alert) {
            self.alertView = alert
        }
    }
}
