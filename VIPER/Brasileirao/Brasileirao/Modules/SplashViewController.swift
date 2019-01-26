//
//  SplashViewController.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 24/12/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit
class SplashViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lblYear: UILabel!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performLogoAnimation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    private func performLogoAnimation() -> (Void) {
        self.lblYear.layer.transform = CATransform3DMakeTranslation(self.view.frame.width/2, 0, 0)
        self.iconImageView.layer.transform = CATransform3DMakeTranslation(0, self.view.frame.height, 0)
        UIView.animate(withDuration: 2, animations: {
            self.iconImageView.layer.transform = CATransform3DIdentity;
        }, completion: {[weak self] (finished: Bool) in
            self?.performYearAnimation()
        })
    }
    
    private func performYearAnimation() -> (Void) {
        UIView.animate(withDuration: 1.2, animations: {
            self.lblYear.layer.transform = CATransform3DIdentity;
        }, completion: {[weak self] (finished: Bool) in
            self?.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self!, selector: (#selector(SplashViewController.callMatchesList)), userInfo: nil, repeats: false)
        })
    }

    @objc private func callMatchesList () {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let initialController = BrasileiraoNavigationController()
        let wireframe = MatchListWireframe()
        initialController.setRootWireframe(wireframe)
        
        appDelegate.window?.rootViewController = initialController
    }
    
}
