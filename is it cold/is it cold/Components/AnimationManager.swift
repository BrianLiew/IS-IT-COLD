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
        switch (DataObject.hourly[0].weather[0].main) {
        case "Clear", "Few Clouds", "Broken Clouds", "Clouds":
            if (DataObject.hourly[0].weather[0].main == "Clear") {
                Clear.playDayClearSky(view: UIView)
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
                scene.scaleMode = .aspectFill
                SKView.presentScene(scene)
            }
        case "Mist":
            if let scene = SKScene(fileNamed: "Mist") {
                scene.scaleMode = .aspectFill
                SKView.presentScene(scene)
            }
        default:
            NSLog("AnimationManager initiateAnimation | description parameter matches no case, no animation played")
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
