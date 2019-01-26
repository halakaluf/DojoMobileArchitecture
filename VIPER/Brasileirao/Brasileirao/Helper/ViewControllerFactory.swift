//
//  ViewControllerFactory.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 24/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerFactory {
    
    public static func splashViewController () -> (UIViewController) {
        let launchScreenStoryboard:SplashViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() as! SplashViewController
        return launchScreenStoryboard
    }

//    public static func matchesListViewController () -> (UIViewController) {
//        let matchesListViewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//        return matchesListViewController
//    }

//    public static func matchDetailViewController () -> (MatchDetailViewController) {
//        let matchDetailViewController:MatchDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchDetailViewController") as! MatchDetailViewController
//        return matchDetailViewController
//    }
   
}
