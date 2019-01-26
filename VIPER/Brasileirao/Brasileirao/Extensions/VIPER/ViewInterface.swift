import UIKit

protocol ViewInterface: class {
    func displayMessage(bgColor: UIColor, msg: String)
    func showMessage(bgColor: UIColor, msg: String)
}

extension ViewInterface {
    
    func displayMessage(bgColor: UIColor, msg: String) {
        showMessage(bgColor: bgColor, msg: msg)
    }

}
