import Foundation
import SpriteKit

class AnimationManager {
    
    var SKView: SKView
    var UIView: UIView
    
    init(SKView: SKView, UIView: UIView) {
        self.SKView = SKView
        self.UIView = UIView
        
        addObserver()
    }
    
    @objc func initiateAnimation() -> Void {
        guard let weather = DataObject.hourly[0].weather, let condition = weather[0].main
        else {
            NSLog("AnimationManager initiateAnimation | nil value for DataObject's weather property or weather's main property, no animation executed")
            return
        }
        
        Clear.playNightClearSky(view: UIView)
        return
                        
        switch (condition) {
            case "Clear", "Few Clouds", "Broken Clouds", "Clouds":
                if (weather[0].main == "Clear") {
                    if let code = weather[0].icon {
                        if (code.hasSuffix("d")) {
                            Clear.playDayClearSky(view: UIView)
                        }
                        else {
                            Clear.playNightClearSky(view: UIView)
                        }
                    }
                }
                else {
                    Clouds.playClouds(view: UIView)
                }
            case "Shower Rain":
                if let scene = SKScene(fileNamed: "ShowerRain") {
                    scene.scaleMode = .aspectFill
                    SKView.presentScene(scene)
                }
            case "Rain":
                if let scene = SKScene(fileNamed: "Rain") {
                    scene.scaleMode = .aspectFill
                    SKView.presentScene(scene)
                }
            case "Thunderstorm":
                if let scene = SKScene(fileNamed: "Thunderstorm") {
                    scene.scaleMode = .aspectFill
                    SKView.presentScene(scene)
                }
            case "Snow":
                if let scene = SKScene(fileNamed: "Snow") {
                    print("case reached")
                    scene.scaleMode = .aspectFill
                    SKView.presentScene(scene)
                }
            case "Mist":
                if let scene = SKScene(fileNamed: "Mist") {
                    scene.scaleMode = .aspectFill
                    SKView.presentScene(scene)
                }
            default:
                NSLog("AnimationManager initiateAnimation | description parameter matches no case, no animation executed")
        }
        
        // view.ignoresSiblingOrder = true
        // view.showsFPS = true
        // view.showsNodeCount = true
    }
    
}

extension AnimationManager {
    
    private func addObserver() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(initiateAnimation),
            name: Notifications.data_object_updated,
            object: nil)
    }
    
}
