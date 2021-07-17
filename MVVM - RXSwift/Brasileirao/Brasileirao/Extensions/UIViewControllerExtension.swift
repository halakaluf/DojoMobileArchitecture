//
//  JSONEncoderExtension.swift
//  Brasileirao
//
//  Created by Fabio Leonardo Barros Martinez on 18/17/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import UIKit

protocol AlertMessageDialogPresenter {
    var alertMessage: AlertMessageView { get set }
    func showMessage(configData: ShowAlertMessageConfig)
    func makeShowMsgView() -> (AlertMessageView)
}

extension AlertMessageDialogPresenter where Self: UIViewController {
    func showMessage(configData: ShowAlertMessageConfig) {
        self.alertMessage.showAlertMessage(configData: configData)
    }
    
    func makeShowMsgView() -> (AlertMessageView) {
        var alertView: AlertMessageView
        alertView = Bundle.main.loadNibNamed("AlertMessageView", owner: self, options: nil)?[0] as! AlertMessageView
        let width = UIScreen.main.bounds.size.width
        var frame = alertView.frame
        frame.size.width = width
        frame.origin.x = 0
        frame.origin.y = -120 //dobro da altura da view
        alertView.lblMessage.adjustsFontSizeToFitWidth = true
        alertView.lblMessage.minimumScaleFactor = 0.5
        alertView.isHidden = true
        alertView.frame = frame
        
        alertView.btnClose.addTarget(alertView, action: (#selector(AlertMessageView.hideAlertMessageAnim)), for: .touchUpInside)
        return alertView
    }
}
