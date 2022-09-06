import Foundation
import UIKit

/*
class IconsManager {
    
    static func cacheIcons(data: WeatherData) -> Void {
        for index in 0...23 {
            if (DataObject.icon_cache_status[data.hourly[index].weather[0].icon] == false) {
                DataObject.icons[data.hourly[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.hourly[index].weather[0].icon)@2x.png")!))!
                DataObject.icon_cache_status[data.hourly[index].weather[0].icon] = true
            }
            DataObject.hourly_images[index] = DataObject.icons[String(data.hourly[index].weather[0].icon)]!
        }
        for index in 0...6 {
            if (DataObject.icon_cache_status[data.daily[index].weather[0].icon] == false) {
                DataObject.icons[data.daily[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.daily[index].weather[0].icon)@2x.png")!))!
                DataObject.icon_cache_status[data.daily[index].weather[0].icon] = true
            }
            DataObject.daily_images[index] = DataObject.icons[String(data.daily[index].weather[0].icon)]!
        }
    }
    
}
*/

class IconsManager {
    
    static let file_manager = FileManager.default
    static let cache_path: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    init() {
        addObserver()
    }
    
    @objc private func fetchImages() -> Void {
        for (code, icon) in DataObject.icons {
            if (icon != nil) { continue }
            else {
                if let image = IconsManager.loadImage(name: code, cache_path: IconsManager.cache_path) {
                    DataObject.icons[code] = image
                    continue
                }
                else {
                    guard let url = URL(string: "http://openweathermap.org/img/wn/\(code)@2x.png")
                    else {
                        NSLog("IconsManager fetchImages() | Image not fetched, could not initialize url to fetch image")
                        continue
                    }
                    if let image = IconsManager.fetchImage(url: url) {
                        DataObject.icons[code] = image
                        IconsManager.saveImage(name: code, image: image, cache_path: IconsManager.cache_path)
                        continue
                    }
                    else {
                        NSLog("IconsManager fetchImages() | Image not fetched, could not fetch image from url")
                        continue
                    }
                }
            }
        }
    }
    
    private static func saveImage(name: String, image: UIImage, cache_path: URL?) -> Void {
        guard let cache_path = cache_path
        else {
            NSLog("IconsManager saveImage(:String, :UIImage) | Image not saved, could not initialize caches directory path")
            return
        }

        if let data = image.pngData() {
            let file_path = cache_path.appendingPathComponent(name)
            do {
                try data.write(to: file_path)
            }
            catch {
                NSLog("IconsManager saveImage(:String, :UIImage) | Image not saved, could not write to cache")
                return
            }
        }
        else {
            NSLog("IconsManager saveImage(:String, :UIImage) | Image not saved, could not be converted from UIImage to Data")
        }
    }
    
    private static func loadImage(name: String, cache_path: URL?) -> UIImage? {
        guard let cache_path = cache_path
        else {
            NSLog("IconsManager saveImage(:String, :UIImage) | Image not loaded, could not initialize caches directory path")
            return nil
        }
        
        let file_path: URL = cache_path.appendingPathComponent(name)
        
        guard file_manager.fileExists(atPath: file_path.path)
        else {
            return nil
        }
        
        if let image = UIImage(contentsOfFile: file_path.path) { return image }
        else {
            NSLog("IconsManager saveImage(:String, :URL?) | Image not loaded, could not retrieve image from cache directory")
            return nil
        }
    }
    
    private static func fetchImage(url: URL?) -> UIImage? {
        guard let url = url
        else {
            NSLog("IconsManager fetchImage(:URL?) | Image not fetched, could not initialize url path")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) { return image }
            else {
                NSLog("IconsManager fetchImage(:URL?) | Image not fetched, could not initialize UIImage from Data")
                return nil
            }
        }
        catch {
            NSLog("IconsManager fetchImage(:URL?) | Image not fetched, could not retrieved data from url")
            return nil
        }
    }
    
}

extension IconsManager {
    
    private func addObserver() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchImages),
            name: Notifications.data_object_updated,
            object: nil)
    }
    
}
