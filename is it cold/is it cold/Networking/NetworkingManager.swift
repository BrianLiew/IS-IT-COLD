import Foundation
import CoreLocation

struct NetworkingManager {
    
    // openweather.org api access key
    private static let strKey: String = "865e25bdadd4ab58522a489eed0685de"
    private static let session = URLSession(configuration: URLSessionConfiguration.default)
    
    static func makeRequest(latitude: Double, longitude: Double, completion_handler: @escaping (Data?) -> Void) {
        // initialize URL
        let strLatitude: String = String(latitude)
        let strLongitude: String = String(longitude)
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(strLatitude)&lon=\(strLongitude)&exclude=minutely,alerts&appid=\(strKey)")
        else {
            NSLog("NetworkingManager request | URL cannot be initialized from string, app exited with code 0")
            exit(0)
        }
        // make network call
        DispatchQueue.global().async {
            let task = session.dataTask(with: url) { data, response, error in
                // checks for correct HTTPURLResponse.statusCode
                guard (response as? HTTPURLResponse)?.statusCode == 200
                else {
                    NSLog("NetworkingManager request(:Double, :Double, (Data?)->Void) | HTTPURLResponse.status code != 200, app exited with code 0")
                    exit(0)
                }
                
                if let data = data { completion_handler(data) }
                else {
                    NSLog("NetworkingManager request(:Double, :Double, (Data?)->Void) | Data could not be unwrapped to be used in completion handler, app exited with code 0")
                    exit(0)
                }
            }
            task.resume()
        }
    }
    
}
