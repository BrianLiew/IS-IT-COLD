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
    
    static func timeFormatter(current_time: Double) -> String {
        let time = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "hh:mm a"
        let time_string = format.string(from: time)
        
        return time_string
    }

    static func dateFormatter(current_time: Double) -> String {
        let date = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "E MMM dd"
        let date_string = format.string(from: date)
        
        return date_string
    }

    static func getCurrentTime() -> String {
        let date = Date()
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "hh:mm:ss a"
        let time_string = format.string(from: date)
     
        return time_string
    }
    
}
