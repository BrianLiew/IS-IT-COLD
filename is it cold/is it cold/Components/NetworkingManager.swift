import Foundation
import CoreLocation

class NetworkingManager {
    
    // openweather.org api access key
    private static let strKey: String = "865e25bdadd4ab58522a489eed0685de"
    private static let session = URLSession(configuration: URLSessionConfiguration.default)
    
    init() {
        addObserver()
    }

    @objc func fetchWeatherData() -> Void {
        let url = NetworkingManager.initURL()
        NetworkingManager.makeRequest(url: url)
    }
    
    private static func initURL() -> URL {
        guard let latitude = DataObject.latitude, let longitude = DataObject.longitude
        else {
            NSLog("NetworkingManager request | nil DataObject latitude and longitude values found when initializing URL, app exited with code 0")
            exit(0)
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(String(latitude))&lon=\(String(longitude))&exclude=minutely,alerts&appid=\(strKey)")
        else {
            NSLog("NetworkingManager request | URL cannot be initialized from string, app exited with code 0")
            exit(0)
        }
        return url
    }
    
    private static func makeRequest(url: URL) -> Void {
        DispatchQueue.global().async {
            let task = session.dataTask(with: url) { data, response, error in
                // checks for correct HTTPURLResponse.statusCode
                guard (response as? HTTPURLResponse)?.statusCode == 200
                else {
                    NSLog("NetworkingManager request | HTTPURLResponse.status code != 200, app exited with code 0")
                    return
                }
                if let data = data { DataObject.updateData(json: data) }
                else {
                    NSLog("NetworkingManager request | Data could not be unwrapped to be used in completion handler, app exited with code 0")
                    exit(0)
                }
            }
            task.resume()
        }
    }
    
}

extension NetworkingManager {
    
    func addObserver() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchWeatherData),
            name: Notifications.location_fetched,
            object: nil)
    }
    
}
