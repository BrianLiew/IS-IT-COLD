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
                                                    dt: 0,
                                                    temp: 0,
                                                    wind_speed: 0,
                                                    wind_deg: 0,
                                                    weather: [
                                                        Weather(
                                                            main: "",
                                                            description: "",
                                                            icon: ""
                                                        )]),
                                             count: 24)
    
    static var daily: [Daily] = Array(repeating: Daily(
                                                        dt: 0,
                                                        sunrise: 0,
                                                        sunset: 0,
                                                        moonrise: 0,
                                                        moonset: 0,
                                                        temp: Temp(
                                                            min: 0,
                                                            max: 0),
                                                        weather: [
                                                            Weather(
                                                                main: "",
                                                                description: "",
                                                                icon: ""
                                                            )]),
                                            count: 7)
    
    static var hourly_images: [UIImage] = Array(repeating: UIImage(), count: 24)
    static var daily_images: [UIImage] = Array(repeating: UIImage(), count: 7)
    
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
    static var icon_cache_status: [String: Bool] = [
        "01d": false,
        "02d": false,
        "03d": false,
        "04d": false,
        "09d": false,
        "10d": false,
        "11d": false,
        "13d": false,
        "50d": false,
        "01n": false,
        "02n": false,
        "03n": false,
        "04n": false,
        "09n": false,
        "10n": false,
        "11n": false,
        "13n": false,
        "50n": false
    ]
    
    static func updateData(json: Data?) -> Void {
        if let json = json {
            DispatchQueue.main.async {
                let data = try? DataObject.decoder.decode(WeatherData.self, from: json)
                if let data = data {
                    DataObject.condition = data.current.weather[0].main
                    DataObject.temperature = data.current.temp
                    DataObject.hourly = data.hourly
                    DataObject.daily = data.daily
                }
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
        } else {
            NSLog("DataObject updateData | nil json value found when updating data, app exited with code 0")
            exit(0)
        }
    }
    
}
