import Foundation
import UIKit

struct DataObject {
    
    private static var decoder = JSONDecoder()
            
    // For use in LocationManager
    static var latitude: Double? = nil
    static var longitude: Double? = nil
    
    // For use in ViewController
    static var city: String? = nil
    static var country: String? = nil
    static var condition: String? = nil
    static var temperature: Double? = nil
    
    static var hourly: [Hourly] = Array(repeating:
                                                Hourly(
                                                    dt: nil,
                                                    temp: nil,
                                                    wind_speed: nil,
                                                    wind_deg: nil,
                                                    weather: [
                                                        Weather(
                                                            main: "",
                                                            description: "",
                                                            icon: ""
                                                        )]),
                                             count: 24)
    
    static var daily: [Daily] = Array(repeating: Daily(
                                                        dt: nil,
                                                        sunrise: nil,
                                                        sunset: nil,
                                                        moonrise: nil,
                                                        moonset: nil,
                                                        temp: Temp(
                                                            min: nil,
                                                            max: nil),
                                                        weather: [
                                                            Weather(
                                                                main: "",
                                                                description: "",
                                                                icon: ""
                                                            )]),
                                            count: 7)
    
    static var icons: [String: UIImage?] = [
        "01d": nil,
        "02d": nil,
        "03d": nil,
        "04d": nil,
        "09d": nil,
        "10d": nil,
        "11d": nil,
        "13d": nil,
        "50d": nil,
        "01n": nil,
        "02n": nil,
        "03n": nil,
        "04n": nil,
        "09n": nil,
        "10n": nil,
        "11n": nil,
        "13n": nil,
        "50n": nil
    ]
    
    static func updateData(json: Data?) -> Void {
        if let json = json {
            DispatchQueue.main.async {
                let data = try? DataObject.decoder.decode(WeatherData.self, from: json)
                if let data = data,
                   let current = data.current,
                   let hourly = data.hourly,
                   let daily = data.daily,
                   let weather = current.weather,
                   let temperature = current.temp,
                   let main = weather[0].main {
                        DataObject.condition = main
                        DataObject.temperature = temperature
                    DataObject.hourly = hourly
                    DataObject.daily = daily
                    /*
                     Notifies:
                        * ViewController to update UI
                        * AnimationManager to begin animation
                        * IconsManager to begin caching icons
                    */
                    NotificationCenter.default.post(
                        name: Notifications.data_object_updated,
                        object: nil
                    )
                }
            }
        }
        else {
            NSLog("DataObject updateData | nil json value found when updating data, app exited with code 0")
            exit(0)
        }
    }
    
    // DEBUG
    static func setCondition(condition: String) -> Void {
        DataObject.hourly[0].weather![0].main = condition
    }
    
}
