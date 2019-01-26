//
//  MatchDetailViewController.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

class MatchDetailViewController: UIViewController {
    var matchDetailViewModel: MatchDetailViewModel?
    var alertView = AlertMessageView()
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
        self.matchDetailViewModel?.bids.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
        }

        self.matchDetailViewModel?.showMsg = { [weak self] (bgColor, msg) in
            self?.showMessage(bgColor: bgColor, msg: msg)
        }

        self.matchDetailViewModel?.hideMsg = { [weak self] in
            self?.alertView.hideAlertMessageAnim()
        }

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


extension MatchDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = self.matchDetailViewModel?.numberOfRows(section) else { return 0 }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch self.matchDetailViewModel?.bidModelAt(indexPath.row) {
            case .matchCell(let matchViewModel)?:
                let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.cellIdentifier(), for: indexPath) as! MatchTableViewCell
                cell.configure(withViewModel: matchViewModel)
                return cell
            case .bidToBidCell?:
                let cell = tableView.dequeueReusableCell(withIdentifier: BidToBidTableViewCell.cellIdentifier(), for: indexPath) as! BidToBidTableViewCell
                return cell
            case .bidCell(let bidViewModel)?:
                let cell = tableView.dequeueReusableCell(withIdentifier: BidTableViewCell.cellIdentifier(), for: indexPath) as! BidTableViewCell
                cell.configure(withViewModel: bidViewModel)
                return cell
            case .loadingCell?:
                let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellIdentifier(), for: indexPath) as! LoadingTableViewCell
                return cell
            case .none:
                return UITableViewCell()
        }

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
