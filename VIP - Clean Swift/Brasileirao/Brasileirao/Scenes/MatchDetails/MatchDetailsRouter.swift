//
//  MatchDetailsRouter.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 08/01/2019.
//  Copyright (c) 2018 Fabio Martinez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MatchDetailsRoutingLogic
{

}

protocol MatchDetailsDataPassing
{
  var dataStore: MatchDetailsDataStore? { get }
}

class MatchDetailsRouter: NSObject, MatchDetailsRoutingLogic, MatchDetailsDataPassing
{
  weak var viewController: MatchDetailsViewController?
  var dataStore: MatchDetailsDataStore?
  
}
