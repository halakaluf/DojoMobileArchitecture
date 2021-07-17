//
//  AlertMessageView.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import UIKit

struct ShowAlertMessageConfig {
    let bgColor: UIColor
    let message: String
}

class AlertMessageView: UIView {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    var timerHideAlert: Timer?

    func btnCloseAction() -> (Void) {
        if timerHideAlert != nil {
            timerHideAlert?.invalidate()
            timerHideAlert = nil
            self.hideAlertMessageAnim()
        }
        
    }
    
    @objc func hideAlertMessageAnim() -> (Void) {
        UIView.animate(withDuration: 0.8, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            var frame: CGRect
            frame = self.frame
            frame.origin.y = -frame.size.height
            self.frame = frame;
            self.alpha = 0
        }, completion: {(finished: Bool) in
            self.timerHideAlert?.invalidate()
            self.timerHideAlert = nil
            self.isHidden = true
        })
    }
    

    func showAlertMessage(configData: ShowAlertMessageConfig) -> (Void) {
        if self.timerHideAlert != nil {
            return
        }
        self.isHidden = false
        self.backgroundColor = configData.bgColor
        self.lblMessage.text = configData.message
        
        UIView.animate(withDuration: 0.8, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var frame: CGRect
            frame = self.frame
            var topPadding = CGFloat(0)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                topPadding = window?.safeAreaInsets.top ?? CGFloat(0)
            }
            frame.origin.y = topPadding
            self.frame = frame
            self.alpha = 1
        }, completion: {[weak self] (finished: Bool) in
            self?.timerHideAlert = Timer.scheduledTimer(timeInterval: 1.8, target: self!, selector: (#selector(self?.hideAlertMessageAnim)), userInfo: nil, repeats: false)
        })
    }
    

}
