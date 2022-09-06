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
    
    private let condition_imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let animation_SKView = SKView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    private let animation_UIView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    
    // MARK: - UICollectionViews
    
    private let hourly_view: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "hourly")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let daily_view: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "daily")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.showsHorizontalScrollIndicator = false
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
        
        self.location_manager.fetchLocalWeatherData()
    }
    
    func initializeUI() -> Void {
        animation_manager = AnimationManager(SKView: animation_SKView, UIView: animation_UIView)
        
        scrollView.contentSize = CGSize(width: screen_width, height: screen_height * 2)
        scrollView.isScrollEnabled = true
        
        location_label.textAlignment = .center
        condition_label.textAlignment = .center
        temperature_label.textAlignment = .center
        wind_label.textAlignment = .center
        
        location_label.font = Fonts.header_font
        condition_label.font = Fonts.title_font
        temperature_label.font = Fonts.body_font
        wind_label.font = Fonts.body_font
                        
        hourly_view.dataSource = self
        hourly_view.delegate = self
        hourly_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        daily_view.dataSource = self
        daily_view.delegate = self
        daily_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(scrollView)
        scrollView.addSubview(animation_SKView)
        scrollView.addSubview(animation_UIView)
        scrollView.addSubview(condition_imageView)
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
            
            condition_imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            condition_imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.2),
            condition_imageView.topAnchor.constraint(equalTo: location_label.bottomAnchor),
            condition_imageView.bottomAnchor.constraint(equalTo: wind_label.topAnchor),
            condition_imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            condition_imageView.trailingAnchor.constraint(equalTo: condition_label.leadingAnchor),

            condition_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            condition_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.2),
            condition_label.topAnchor.constraint(equalTo: location_label.bottomAnchor),
            condition_label.bottomAnchor.constraint(equalTo: wind_label.topAnchor),
            condition_label.leadingAnchor.constraint(equalTo: condition_imageView.trailingAnchor),
            condition_label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            temperature_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            temperature_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            temperature_label.topAnchor.constraint(equalTo: condition_imageView.bottomAnchor),
            temperature_label.bottomAnchor.constraint(equalTo: hourly_view.topAnchor),
            temperature_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            temperature_label.trailingAnchor.constraint(equalTo: wind_label.leadingAnchor),
            
            wind_label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            wind_label.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),
            wind_label.topAnchor.constraint(equalTo: condition_label.bottomAnchor),
            wind_label.bottomAnchor.constraint(equalTo: hourly_view.topAnchor),
            wind_label.leadingAnchor.constraint(equalTo: temperature_label.trailingAnchor),
            wind_label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            hourly_view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            hourly_view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3),
            hourly_view.topAnchor.constraint(equalTo: temperature_label.bottomAnchor),
            hourly_view.bottomAnchor.constraint(equalTo: daily_view.topAnchor, constant: -25),
            hourly_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.075)),
            hourly_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            daily_view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            daily_view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3),
            daily_view.topAnchor.constraint(equalTo: hourly_view.bottomAnchor, constant: 25),
            daily_view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            daily_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(screen_width * 0.075)),
            daily_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        return
    }
    
    @objc func updateUI() -> Void {
        if let city = DataObject.city, let country = DataObject.country {
            self.location_label.text = "\(city), \(country)"
        }
        if let image = DataObject.icons[DataObject.hourly[0].weather[0].icon] {
            self.condition_imageView.image = image
        }
        self.condition_label.text = DataObject.hourly[0].weather[0].main
        if let temperature = DataObject.temperature {
            self.temperature_label.text = String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: temperature)) + "°F"
        }
        self.wind_label.text = "\(DataObject.hourly[0].wind_speed) \(Utilities.convertDegreesToDirection(input: DataObject.hourly[0].wind_deg))"
        
        hourly_view.reloadData()
        daily_view.reloadData()
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
            
            content.image = DataObject.hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.text = String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: DataObject.hourly[indexPath.row].temp)) + "°F"
            content.secondaryText = "\(Time.timeFormatter(current_time: Double(DataObject.hourly[indexPath.row].dt)))"

            content.textProperties.font = Fonts.cell_font
            content.secondaryTextProperties.font = Fonts.secondary_cell_font

            cell.contentConfiguration = content
        }
        else if (tableView == self.daily_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: DataObject.daily[indexPath.row].temp.min)) +  "°F ~ " + String(format: "%.1f", Utilities.convertKelvinToFahrenheit(input: DataObject.daily[indexPath.row].temp.max)) + "°F"
            content.secondaryText = "\(Time.dateFormatter(current_time: Double(DataObject.daily[indexPath.row].dt)))"
            content.textProperties.font = Fonts.cell_font
            content.secondaryTextProperties.font = Fonts.secondary_cell_font
            content.image = DataObject.daily_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - NotificationCenter
    
    func addObservers() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUI),
            name: Notifications.data_object_updated,
            object: nil
        )
    }
    
}
