import SpriteKit

class ShowerRain: SKScene {
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.post(
            name: Notifications.nighttime_determined,
            object: nil
        )
        
        run(SKAction.sequence([
            // background
            SKAction.colorize(with: SKColor(displayP3Red: 0, green: 0.25, blue: 0.5, alpha: 0.25), colorBlendFactor: 1.0, duration: 1.0),
            // animation
            SKAction.repeat(SKAction.sequence([
                SKAction.run(playRain),
                SKAction.wait(forDuration: 0.5)
            ]), count: 3),
            SKAction.repeat(SKAction.sequence([
                SKAction.run(playRain),
                SKAction.wait(forDuration: 0.25)
            ]), count: 5),
            SKAction.repeat(SKAction.sequence([
                SKAction.run(playRain),
                SKAction.wait(forDuration: 0.125)
            ]), count: 5),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.run(playRain),
                SKAction.wait(forDuration: 0.05)
            ]))
        ]))
    }
    
    func playRain() -> Void {
        let rain_node = SKSpriteNode(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), size: CGSize(width: 3, height: 50))
        rain_node.position = CGPoint(x: Utilities.random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(rain_node)
        
        let movement = SKAction.move(by: CGVector(dx: 0, dy: -screen_height * 2), duration: 0.5)
        let removal = SKAction.removeFromParent()
        
        rain_node.run(SKAction.sequence([movement, removal]))
    }

}
