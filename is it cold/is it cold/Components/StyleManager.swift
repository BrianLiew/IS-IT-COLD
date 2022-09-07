import Foundation
import UIKit

struct StyleManager {
    
    enum Color: String {
        case black = "#000000"
        case white = "#FFFFFF"
        
        func getColor() -> UIColor {
            let color = self.rawValue
            return UIColor(hex: color)
        }
    }
    
    enum Fonts: String {
        case system = "Helvetica Neue"
        
        enum Size: CGFloat {
            case small = 16
            case medium = 20
            case large = 24
            case extra_large = 48
        }
        
        func getFont(size: Size) -> UIFont {
            let name = self.rawValue
            let size = size.rawValue
            return UIFont(name: name, size: size)!
        }
        
    }
    
}

extension UIColor {
    
    convenience init(hex: String) {
        var str: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if str.hasPrefix("#") {
            str.remove(at: str.startIndex)
        }
        
        let scanner = Scanner(string: str)
        var rgb_val: UInt64 = 0
        
        scanner.scanHexInt64(&rgb_val)
        let red = (rgb_val & 0xff0000) >> 16
        let green = (rgb_val & 0xff00) >> 8
        let blue = rgb_val & 0xff
        
        self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: 1)
    }
    
}
