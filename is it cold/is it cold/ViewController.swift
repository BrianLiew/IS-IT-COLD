import UIKit
import SpriteKit
import GameplayKit
import CoreLocation
import AddressBookUI
import Foundation

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

class ViewController: UIViewController {
        
    // MARK: - UIViews
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = CGSize(width: screen_width, height: screen_height * 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let animation_SKView = SKView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    private let animation_UIView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    
    // MARK: - UICollectionViews
    
    private let hourly_view: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let daily_view: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    // MARK: - UILabels
    
    private let location_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperature_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let condition_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let wind_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Component Managers
    
    var animation_manager: AnimationManager? = nil
    let icons_manager = IconsManager()
    let location_manager = LocationManager()
    let networking_manager = NetworkingManager()
    
    // MARK: - ViewController
    
    override var shouldAutorotate: Bool { return false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        addObservers()
        
        NotificationCenter.default.post(name: Notifications.view_did_load, object: nil)
    }
    
    func initializeUI() -> Void {
        animation_manager = AnimationManager(SKView: animation_SKView, UIView: animation_UIView)
        
        scrollView.contentSize = CGSize(width: screen_width, height: screen_height * 2)
        scrollView.isScrollEnabled = true
        
        location_label.textAlignment = .center
        condition_label.textAlignment = .center
        temperature_label.textAlignment = .center
        wind_label.textAlignment = .center
        
        location_label.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.large)
        condition_label.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.extra_large)
        temperature_label.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.large)
        wind_label.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.large)
                        
        hourly_view.dataSource = self
        hourly_view.delegate = self
        hourly_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        daily_view.dataSource = self
        daily_view.delegate = self
        daily_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(scrollView)
        scrollView.addSubview(animation_SKView)
        scrollView.addSubview(animation_UIView)
        scrollView.addSubview(location_label)
        scrollView.addSubview(condition_label)
        scrollView.addSubview(temperature_label)
        scrollView.addSubview(wind_label)
        scrollView.addSubview(hourly_view)
        scrollView.addSubview(daily_view)
        scrollView.sendSubviewToBack(animation_UIView)
        scrollView.sendSubviewToBack(animation_SKView)

        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            animation_SKView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            animation_SKView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            animation_SKView.topAnchor.constraint(equalTo: view.topAnchor),
            animation_SKView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            animation_SKView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            animation_SKView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            animation_UIView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            animation_UIView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            animation_UIView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            animation_UIView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            animation_UIView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            animation_UIView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            location_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            location_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            location_label.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            location_label.bottomAnchor.constraint(equalTo: condition_label.topAnchor),
            location_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            location_label.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            condition_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            condition_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            condition_label.topAnchor.constraint(equalTo: location_label.bottomAnchor),
            condition_label.bottomAnchor.constraint(equalTo: wind_label.topAnchor),
            condition_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.1)),
            condition_label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(screen_width * 0.1)),

            temperature_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3),
            temperature_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            temperature_label.topAnchor.constraint(equalTo: condition_label.bottomAnchor),
            temperature_label.bottomAnchor.constraint(equalTo: hourly_view.topAnchor),
            temperature_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.1)),
            temperature_label.trailingAnchor.constraint(equalTo: wind_label.leadingAnchor),
            
            wind_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            wind_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            wind_label.topAnchor.constraint(equalTo: condition_label.bottomAnchor),
            wind_label.bottomAnchor.constraint(equalTo: hourly_view.topAnchor),
            wind_label.leadingAnchor.constraint(equalTo: temperature_label.trailingAnchor),
            wind_label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(screen_width * 0.1)),
            
            hourly_view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            hourly_view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.25),
            hourly_view.topAnchor.constraint(equalTo: temperature_label.bottomAnchor),
            hourly_view.bottomAnchor.constraint(equalTo: daily_view.topAnchor, constant: -25),
            hourly_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.1)),
            hourly_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(screen_width * 0.1)),
            
            daily_view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            daily_view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.25),
            daily_view.topAnchor.constraint(equalTo: hourly_view.bottomAnchor, constant: 25),
            daily_view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            daily_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.1)),
            daily_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(screen_width * 0.1))
        ])
        
        return
    }
    
    @objc func updateUI() -> Void {
        self.updateLocationText()
        self.updateWeatherText()
        hourly_view.reloadData()
        daily_view.reloadData()
    }
    
    private func updateLocationText() -> Void {
        if let city = DataObject.city, let country = DataObject.country {
            self.location_label.text = "\(city), \(country)"
        }
        return
    }
    
    private func updateWeatherText() -> Void {
        if let current = DataObject.hourly[0].weather,
           let temperature = DataObject.temperature,
           let wind_speed = DataObject.hourly[0].wind_speed,
           let wind_deg = DataObject.hourly[0].wind_deg
        {
            if let condition = current[0].main {
                self.condition_label.text = condition
            }
            self.temperature_label.text = String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: temperature)) + "°F"
            self.wind_label.text = "\(wind_speed)mph \(Utilities.convertDegreesToDirection(input: wind_deg))"
        }
    }
    
    @objc private func convertWhiteText() -> Void {
        self.location_label.textColor = StyleManager.Color.white.getColor()
        self.condition_label.textColor = StyleManager.Color.white.getColor()
        self.temperature_label.textColor = StyleManager.Color.white.getColor()
        self.wind_label.textColor = StyleManager.Color.white.getColor()
        return
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
                
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daily_view) { return 7 }
        else { return 24 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if (tableView == self.hourly_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = retrieveHourlyContentText(index: indexPath.row)
            content.secondaryText = retrieveHourlySecondaryText(index: indexPath.row)
            content.textProperties.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.small)
            content.secondaryTextProperties.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.small)
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            if let image = retrieveHourlyIcon(index: indexPath.row) {
                content.image = image
            }

            cell.contentConfiguration = content
        }
        else if (tableView == self.daily_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = retrieveDailyContentText(index: indexPath.row)
            content.secondaryText = retrieveDailySecondaryText(index: indexPath.row)
            content.textProperties.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.small)
            content.secondaryTextProperties.font = StyleManager.Fonts.system.getFont(size: StyleManager.Fonts.Size.small)
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            if let image = retrieveDailyIcon(index: indexPath.row) {
                content.image = image
            }
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - hourly_view utility functions
    
    private func retrieveHourlyContentText(index: Int) -> String {
        if let temperature = DataObject.hourly[index].temp {
            return String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: temperature)) + "°F"
        }
        else { return "" }
    }
    
    private func retrieveHourlySecondaryText(index: Int) -> String {
        if let time = DataObject.hourly[index].dt {
            return "\(Utilities.timeFormatter(current_time: Double(time)))"
        }
        else { return "" }
    }
    
    private func retrieveHourlyIcon(index: Int) -> UIImage? {
        if let weather = DataObject.hourly[index].weather {
            if let code = weather[0].icon {
                if let image = DataObject.icons[code] {
                    return image
                }
                else { return nil }
            }
            else { return nil }
        }
        else { return nil }
    }
    
    // MARK: - daily_view utility functions
    
    private func retrieveDailyContentText(index: Int) -> String {
        if let temperature = DataObject.daily[index].temp {
            if let min_temp = temperature.min, let max_temp = temperature.max {
                return
                    String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: min_temp)) +
                    "°F ~ " +
                    String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: max_temp)) + "°F"
            }
            else { return "" }
        }
        else { return "" }
    }
    
    private func retrieveDailySecondaryText(index: Int) -> String {
        if let time = DataObject.daily[index].dt {
            return "\(Utilities.dateFormatter(current_time: Double(time)))"
        }
        else { return "" }
    }
    
    private func retrieveDailyIcon(index: Int) -> UIImage? {
        if let weather = DataObject.daily[index].weather {
            if let code = weather[0].icon {
                if let image = DataObject.icons[code] {
                    return image
                }
                else { return nil }
            }
            else { return nil }
        }
        else { return nil }
    }
    
    // MARK: - NotificationCenter
    
    func addObservers() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUI),
            name: Notifications.data_object_updated,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(convertWhiteText),
            name: Notifications.nighttime_determined,
            object: nil)
    }
    
}
