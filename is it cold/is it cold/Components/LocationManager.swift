import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    override init() {
        super.init()
                
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 500
        manager.requestWhenInUseAuthorization()
        
        addObserver()
    }
    
    @objc func fetchLocalWeatherData() -> Void {
        print("fetchLocalWeatherData called")
        DispatchQueue.main.async {
            self.manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            NSLog("LocationManager didUpdateLocations | Could not fetch location, app exited with code 0")
            exit(0)
        }
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else {
                if let error = error {
                    NSLog("LocationManager didUpdateLocations | Failed to fetch city and county, error: \(String(describing: error))")
                }
                NotificationCenter.default.post(
                    name: Notifications.location_fetched,
                    object: nil
                )
                return
            }
                        
            DataObject.city = city
            DataObject.country = country
            DataObject.latitude = location.coordinate.latitude
            DataObject.longitude = location.coordinate.longitude
                        
            NotificationCenter.default.post(
                name: Notifications.location_fetched,
                object: nil
            )
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let nserror = error as NSError
        fatalError("LocationManager didFailWithError | \(nserror): \(nserror.localizedDescription)")
    }
    
}

extension CLLocation {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
}

extension LocationManager {
    
    func addObserver() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchLocalWeatherData),
            name: Notifications.view_did_load,
            object: nil
        )
        return
    }
    
}
