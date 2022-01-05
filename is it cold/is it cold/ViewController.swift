//
//  GameViewController.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import UIKit
import SpriteKit
import GameplayKit

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

let title_font = UIFont(name: "Chalkduster", size: 36)
let big_font = UIFont(name: "Chalkduster", size: 24)
let small_font = UIFont(name: "Chalkduster", size: 16)

let off_white = UIColor(red: 1, green: 1, blue: 0.92, alpha: 1)

class ViewController: UIViewController {
    
    // MARK: UI element declarations
    
    // UIScrollView
    let scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    // UIView
    let background = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    let temperature_background = UIView(frame: CGRect(x: 0, y: screen_height / 2, width: screen_width, height: 175))
    let wind_background = UIView(frame: CGRect(x: 0, y: screen_height / 2 + 175, width: screen_width, height: 175))
    // UILabels
    let city_label = UILabel(frame: CGRect(x: 0, y: screen_height / 4 - 150, width: screen_width, height: 100))
    let weather_description_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 4 - 25, width: 300, height: 50))
    let temp_title = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2, width: 300, height: 50))
    let temp_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 50, width: 200, height: 100))
    let temp_max_label = UILabel(frame: CGRect(x: screen_width / 2 + 50, y: screen_height / 2 + 50, width: 100, height: 50))
    let temp_min_label = UILabel(frame: CGRect(x: screen_width / 2 + 50, y: screen_height / 2 + 100, width: 100, height: 50))
    let wind_title = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 175, width: 300, height: 50))
    let wind_deg_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 225, width: 150, height: 100))
    let wind_speed_label = UILabel(frame: CGRect(x: screen_width / 2, y: screen_height / 2 + 225, width: 150, height: 100))
    let forecast_time_label = UILabel(frame: CGRect(x: 0, y: screen_height / 4 - 200, width: screen_width, height: 50))
    // let attribution = UILabel(frame: CGRect(x: 0, y: 0, width: screen_width, height: 10))
    
    // MARK: JSONDecoder declaration
    
    let decoder = JSONDecoder()
    
    // MARK: ViewController functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_UI()
        
        // self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        let network_instance = Networking()
        network_instance.make_request(completion_handler: request_completion_handler)
    }
    
    // initiation of data-displaying elements. Called in viewDidLoad.
    func init_UI() {
        temp_label.layer.cornerRadius = 0.5
        temp_label.layer.masksToBounds = true
        
        city_label.text = "-"
        weather_description_label.text = "-"
        temp_title.text = "Temperature"
        temp_label.text = "0.00 °F"
        temp_max_label.text = "0.00 °F"
        temp_min_label.text = "0.00 °F"
        wind_title.text = "Wind"
        
        city_label.textAlignment = .center
        weather_description_label.textAlignment = .center
        temp_label.textAlignment = .center
        temp_title.textAlignment = .center
        temp_max_label.textAlignment = .center
        temp_min_label.textAlignment = .center
        wind_title.textAlignment = .center
        wind_deg_label.textAlignment = .center
        wind_speed_label.textAlignment = .center
        
        city_label.font = big_font
        weather_description_label.font = title_font
        temp_label.font = big_font
        temp_title.font = big_font
        temp_max_label.font = small_font
        temp_min_label.font = small_font
        wind_title.font = big_font
        wind_deg_label.font = big_font
        wind_speed_label.font = big_font
                
        view.addSubview(scroll_view)
        view.sendSubviewToBack(scroll_view)
        scroll_view.addSubview(background)
        scroll_view.addSubview(temperature_background)
        scroll_view.addSubview(wind_background)
        scroll_view.addSubview(city_label)
        scroll_view.addSubview(weather_description_label)
        scroll_view.addSubview(temp_label)
        scroll_view.addSubview(temp_title)
        scroll_view.addSubview(temp_max_label)
        scroll_view.addSubview(temp_min_label)
        scroll_view.addSubview(wind_title)
        scroll_view.addSubview(wind_deg_label)
        scroll_view.addSubview(wind_speed_label)
    }
    
    // updates data-displaying elements and background animations. Called in request_completion_handler.
    func update_UI(
        city_name: String,
        weather_description_string: String,
        country_name: String,
        temp_double: Double,
        temp_max_double: Double,
        temp_min_double: Double,
        wind_deg_int: Int,
        wind_speed_double: Double,
        background_view: UIView
    ) -> Void {
        // update data
        self.city_label.text = city_name + ", " + country_name
        self.weather_description_label.text = weather_description_string
        self.temp_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temp_double)) + "°F"
        self.temp_max_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temp_max_double)) + "°F"
        self.temp_min_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temp_min_double)) + "°F"
        self.wind_deg_label.text = convert_deg_to_direction(input: wind_deg_int)
        self.wind_speed_label.text = String(format: "%.2f", wind_speed_double) + " mph"
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 1.0)
        // update background animations
        if let view = self.view as! SKView? {
            
            switch (weather_description_string) {
            case "Clear Sky":
                clear_sky(view: background_view)
            case "Few Clouds":
                few_clouds(view: background_view)
            case "Broken Clouds":
                few_clouds(view: background_view)
            case "Shower Rain":
                if let scene = SKScene(fileNamed: "ShowerRain") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Rain":
                if let scene = SKScene(fileNamed: "Rain") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Thunderstorm":
                if let scene = SKScene(fileNamed: "Rain") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Snow":
                if let scene = SKScene(fileNamed: "Snow") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Mist":
                if let scene = SKScene(fileNamed: "Snow") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            default: print("default")
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func convert_text_to_white() -> Void {
        city_label.textColor = off_white
        weather_description_label.textColor = off_white
        temp_label.textColor = off_white
        temp_title.textColor = off_white
        temp_max_label.textColor = off_white
        temp_min_label.textColor = off_white
        wind_title.textColor = off_white
        wind_deg_label.textColor = off_white
        wind_speed_label.textColor = off_white
    }
    
    // MARK: data function
    
    // completion handler for make_request(). Parser.
    func request_completion_handler(json: Data?) -> Void {
        if let json_unwrapped = json {
            DispatchQueue.main.async {
                let weather_data = try? self.decoder.decode(weather_data.self, from: json_unwrapped)
                if var weather_data_unwrapped = weather_data {
                    print(weather_data_unwrapped)
                    weather_data_unwrapped.set_description(description: "snow")
                    self.update_UI(
                        city_name: weather_data_unwrapped.name,
                        weather_description_string: weather_data_unwrapped.return_description().capitalized,
                        country_name: weather_data_unwrapped.sys.country,
                        temp_double: weather_data_unwrapped.main.temp,
                        temp_max_double: weather_data_unwrapped.main.temp_max,
                        temp_min_double: weather_data_unwrapped.main.temp_min,
                        wind_deg_int: weather_data_unwrapped.wind.deg,
                        wind_speed_double: weather_data_unwrapped.wind.speed,
                        background_view: self.background
                    )
                }
            }
        } else { print("json unwrap error") }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
