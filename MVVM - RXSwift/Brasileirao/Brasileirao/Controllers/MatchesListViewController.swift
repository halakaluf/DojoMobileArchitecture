//
//  MatchesListViewController.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class MatchesListViewController: UIViewController {
    
    var matchesViewModel = MatchesListViewModel()
    var alertView = AlertMessageView()

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action:(#selector(self.handleRefresh(_:))), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(red: 59/255, green: 156/255, blue: 0/255, alpha: 1)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.configureTable()
        self.configCellClickAction()
        self.configureView()
//        self.matchesViewModel.getMatches(isRefresh: false)
        
        setupInputs()
        setupOutputs()
    }
    
    func setupInputs() {
        self.matchesViewModel.inputs.getMatchesAction.onNext(false)
        
        refreshControl.rx
            .controlEvent(UIControl.Event.valueChanged)
            .map {  _ in
                return self.refreshControl.isRefreshing
            }
            .map({ _ in true })
            .bind(to: matchesViewModel.inputs.reloadMatchesAction)
            .disposed(by: disposeBag)
    }
    
    func setupOutputs() {
        self.matchesViewModel.outputs.listTitle
            .asObservable()
            .subscribe(onNext: { title in
                self.setTitle(title: title)
            }).disposed(by: disposeBag)
        
        self.matchesViewModel.outputs.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        self.matchesViewModel.outputs.alertError
            .filter({ $0 != nil }).asObservable()
            .subscribe(onNext: { [weak self] alertError in
                guard let this = self else { return }
                this.showMessage(configData: alertError!)
            }).disposed(by: disposeBag)
    }
    
    func configureTable() -> (Void) {
        let nib = UINib(nibName: MatchTableViewCell.cellIdentifier(), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: MatchTableViewCell.cellIdentifier())
        self.tableView.addSubview(self.refreshControl)
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func configureView() -> (Void) {
        self.alertMessage = self.makeShowMsgView()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.alertView)
        window.bringSubviewToFront(self.alertView)
        
        let buttonPrevius = UIBarButtonItem(image: UIImage(named: "iconPreviews"), style: .plain, target: self, action: nil)
        let buttonNext = UIBarButtonItem(image: UIImage(named: "iconNext"), style: .plain, target: self, action: nil)
        
        buttonPrevius.rx.tap.asObservable()
            .bind(to: self.matchesViewModel.inputs.barButtonPreviewsAction)
            .disposed(by: disposeBag)
        
        buttonNext.rx.tap.asObservable()
            .bind(to: self.matchesViewModel.inputs.barButtonNextAction)
            .disposed(by: disposeBag)
        
        buttonNext.tintColor    = UIColor.white
        buttonPrevius.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = buttonPrevius
        self.navigationItem.rightBarButtonItem = buttonNext
//        self.setTitle(title: self.matchesViewModel.listTitle()) //<----------------VER ISSO
    }

    func bindViewModel() {

        self.matchesViewModel
            .outputs
            .matchCells
            .asObservable()
            .do(afterNext:{_ in
                self.tableView.layoutIfNeeded()
                self.tableView.setContentOffset(.zero, animated: false)
            })
            .bind(to: self.tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.cellIdentifier(), for: indexPath) as? MatchTableViewCell else {
                    return UITableViewCell()
                }
                cell.viewModel = element
                return cell
            }.disposed(by: disposeBag)

//        self.matchesViewModel
//            .showMsg
//            .map { [weak self] in self?.showMessage(configData: $0) }
//            .subscribe()
//            .disposed(by: disposeBag)
       
//        self.matchesViewModel
//            .changeTitle
//            .map { [weak self] in  self?.setTitle(title: $0) }
//            .subscribe()
//            .disposed(by: disposeBag)

//        self.matchesViewModel.showRefreshControl
//            .map { [weak self] in self?.setRefreshControlState(visible: $0) }
//            .subscribe()
//            .disposed(by: disposeBag)

    }
    
//    private func setRefreshControlState(visible: Bool) {
//        visible ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
//    }
    
    private func configCellClickAction() {
        tableView
            .rx
            .modelSelected(MatchViewModel.self)
            .subscribe(
                onNext: { [weak self] match in
                    DispatchQueue.main.async { [weak self] in
                        self?.performSegue(withIdentifier: "SegueShowMatchDetail", sender: match as MatchViewModel)
                    }
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }

//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.matchesViewModel.getMatchesAction.onNext(false)
//    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueShowMatchDetail",
            let matchDetailViewController = segue.destination as? MatchDetailViewController {
                let matchViewModel = sender as! MatchViewModel
                matchDetailViewController.matchDetailViewModel = MatchDetailViewModel(matchViewModel: matchViewModel)
        }
    }

    func setTitle(title: String) -> (Void) {
        self.title = title
    }
}

extension MatchesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MatchTableViewCell.heightForRow()
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
