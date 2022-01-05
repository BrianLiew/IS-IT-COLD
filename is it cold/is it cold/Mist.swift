//
//  Mist.swift
//  is it cold
//
//  Created by Brian Liew on 1/4/22.
//

import Foundation
import SpriteKit

class Mist: SKScene {
    
    override func didMove(to view: SKView) {
        run(SKAction.sequence([
            // background
            SKAction.colorize(with: SKColor(displayP3Red: 0, green: 0.25, blue: 0.5, alpha: 0.25), colorBlendFactor: 1.0, duration: 1.0),
            SKAction.wait(forDuration: 0.25),
            // rain animation
            SKAction.repeat(SKAction.sequence([
                SKAction.run(rain),
                SKAction.wait(forDuration: 0.5)
            ]), count: 3),
            SKAction.repeat(SKAction.sequence([
                SKAction.run(rain),
                SKAction.wait(forDuration: 0.25)
            ]), count: 5),
            SKAction.repeat(SKAction.sequence([
                SKAction.run(rain),
                SKAction.wait(forDuration: 0.125)
            ]), count: 5),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.run(rain),
                SKAction.wait(forDuration: 0.025)
            ]))
        ]))
    }
    
    func rain() -> Void {
        let rain_node = SKSpriteNode(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), size: CGSize(width: 3, height: 50))
        rain_node.position = CGPoint(x: random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(rain_node)
        
        let movement = SKAction.move(by: CGVector(dx: 0, dy: -screen_height * 2), duration: 0.5)
        let removal = SKAction.removeFromParent()
        
        rain_node.run(SKAction.sequence([movement, removal]))
    }
    
    func random(from: Double, to: Double) -> Double { return Double.random(in: (from...to))}
    
}
