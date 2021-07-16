//
//  MatchesListViewController.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

class MatchesListViewController: UIViewController {
    
    var matchesViewModel = MatchesListViewModel()
    var alertView = AlertMessageView()
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:(#selector(self.handleRefresh(_:))), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(red: 59/255, green: 156/255, blue: 0/255, alpha: 1)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
        self.bindViewModel()
        self.matchesViewModel.getMatches(isRefresh: false)
    }
    
    override func viewDidLayoutSubviews() {
        self.configureView()
    }
    
    func configureTable() -> (Void) {
        let nib = UINib(nibName: MatchTableViewCell.cellIdentifier(), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: MatchTableViewCell.cellIdentifier())
        self.tableView.addSubview(self.refreshControl)
    }
    
    func configureView() -> (Void) {
        self.alertMessage = self.makeShowMsgView()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.alertView)
        window.bringSubviewToFront(self.alertView)
        
        let buttonPrevius = UIBarButtonItem(image: UIImage(named: "iconPreviews"), style: .plain, target: self, action: (#selector(MatchesListViewController.barButtonPreviewsAction)))
        let buttonNext = UIBarButtonItem(image: UIImage(named: "iconNext"), style: .plain, target: self, action: (#selector(MatchesListViewController.barButtonNextAction)))
        buttonNext.tintColor    = UIColor.white
        buttonPrevius.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = buttonPrevius
        self.navigationItem.rightBarButtonItem = buttonNext
        self.setTitle(title: self.matchesViewModel.listTitle())
    }

    func bindViewModel() {
        self.matchesViewModel.matches.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
            self?.tableView?.layoutIfNeeded()
            self?.tableView?.setContentOffset(.zero, animated: false)
        }

        self.matchesViewModel.showMsg = { [weak self] (bgColor, msg) in
            self?.showMessage(bgColor: bgColor, msg: msg)
        }

        self.matchesViewModel.changeTitle = { [weak self] (title) in
            self?.setTitle(title: title)
        }

        self.matchesViewModel.showRefreshControl.bind() { [weak self] visible in
            if let `self` = self {
                visible ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
            }
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.matchesViewModel.getMatches(isRefresh: true)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueShowMatchDetail",
            let matchDetailViewController = segue.destination as? MatchDetailViewController {
                let matchViewModel = sender as! MatchViewModel
                matchDetailViewController.matchDetailViewModel = MatchDetailViewModel(matchViewModel: matchViewModel)
        }
    }

   @objc func barButtonPreviewsAction() {
        self.matchesViewModel.previusRound()
    }

    @objc func barButtonNextAction() {
        self.matchesViewModel.nextRound()
    }

    func setTitle(title: String) -> (Void) {
        self.title = title
    }
}

extension MatchesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchesViewModel.numberOfRows(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.cellIdentifier(), for: indexPath) as! MatchTableViewCell
        
        cell.configure(withViewModel: self.matchesViewModel.modelAt(indexPath.row))
        return cell
    }

}

extension MatchesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MatchTableViewCell.heightForRow()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "SegueShowMatchDetail", sender: self?.matchesViewModel.modelAt(indexPath.row))
        }
    }

}

extension MatchesListViewController: AlertMessageDialogPresenter {
    var alertMessage: AlertMessageView {
        get {
            return self.alertView
        }
        set(alert) {
            self.alertView = alert
        }
    }

}
