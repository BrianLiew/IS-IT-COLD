import Foundation

struct Notifications {
    
    static let location_fetched = Notification.Name(rawValue: "location_fetched")
    static let data_object_updated = Notification.Name(rawValue: "data_object_updated")
    static let view_did_load = Notification.Name(rawValue: "view_did_load")
    static let nighttime_determined = Notification.Name(rawValue: "nighttime_determined")
}
