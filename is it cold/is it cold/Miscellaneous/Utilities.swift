import Foundation

struct Utilities {
    
    static func convertKelvinToFahrenheit(input: Double) -> Double { return ((input - 273.15) * 1.8 + 32) }

    static func convertDegreesToDirection(input: Int) -> String {
        switch input {
        case 0...89:
            return (String(format: "%d", input) + "°N")
        case 90...179:
            return (String(format: "%d", input - 90) + "°E")
        case 180...269:
            return (String(format: "%d", input - 180) + "°S")
        case 270...359:
            return (String(format: "%d", input - 270) + "°W")
        default:
            return String(format: "%d", input)
        }
    }

    static func random(from: Double, to: Double) -> Double { return Double.random(in: (from...to))}
    
}
