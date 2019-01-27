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
   
}
