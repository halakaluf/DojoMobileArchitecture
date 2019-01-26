//
//  MatchListWireframe.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 22/01/19.
//  Copyright (c) 2019 Fabio Martinez. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class MatchListWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = _storyboard.instantiateViewController(ofType: MatchListViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = MatchListInteractor()
        let presenter = MatchListPresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }

    private func openDetails(with match: Match) {
        navigationController?.pushWireframe(MatchDetailsWireframe(match: match))
    }

}

// MARK: - Extensions -

extension MatchListWireframe: MatchListWireframeInterface {

    func navigate(to option: MatchListNavigationOption) {
        switch option {
        case .matchDetails(let match):
            openDetails(with: match)
        }
    }
    
    

}
