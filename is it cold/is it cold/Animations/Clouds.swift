import Foundation
import UIKit

class Clouds {
 
    static func playClouds(view: UIView) -> Void {
        NotificationCenter.default.post(
            name: Notifications.nighttime_determined,
            object: nil
        )
        
        let background = CAGradientLayer()
        background.frame = view.bounds
        background.colors = [
            UIColor(displayP3Red: 0, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(displayP3Red: 0, green: 0.77, blue: 1, alpha: 1.0).cgColor
        ]
        view.layer.addSublayer(background)
    }
    
}
