//
//  Theme.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 26/01/19.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//


import UIKit

class Theme {
   static func performInitialization() {
        let bgGreenNavBar = UIColor.init(red: 59/255, green: 156/255, blue: 0/255, alpha: 1)
        UINavigationBar.appearance(whenContainedInInstancesOf: [BrasileiraoNavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [BrasileiraoNavigationController.self]).barTintColor = bgGreenNavBar
        UINavigationBar.appearance(whenContainedInInstancesOf: [BrasileiraoNavigationController.self]).titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().prefersLargeTitles = false
    }
}
