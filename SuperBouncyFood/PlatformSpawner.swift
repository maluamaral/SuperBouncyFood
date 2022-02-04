//
//  PlataformSpawner.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 01/02/22.
//

import SpriteKit

class PlatformSpawner {
    
    private var platformModel: SKNode
    private var parent: SKNode
    private var platforms = [SKNode]()
    private var player: Player
    
    private var jump : CGFloat = 0
    
    
    init(platformModel: SKNode, parent: SKNode, player: Player) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        
    }
    
    func makePlatforms(){
        let spaceBetweenPlatforms = parent.frame.size.height/5
        for i in 0..<Int(parent.frame.size.height/spaceBetweenPlatforms) {
            let x = CGFloat.random(in: 30...parent.frame.size.width - 50)
            let y = CGFloat.random(in: CGFloat(i)*spaceBetweenPlatforms + 200...CGFloat(i+1)*spaceBetweenPlatforms-10)
            print("\(x), \(y)")
            spawn(at: CGPoint(x: x, y: y))
        }
    }
    
    
    func updatePlatforms(ground: SKNode) {
        let minimumHeight: CGFloat = parent.frame.size.height/2
        guard let playerVelocity = player.node.physicsBody?.velocity.dy else {
            return
        }
        var distance = playerVelocity/50
        if player.isMoving {
            //minimumHeight = 0
            distance = 30 - jump
            jump += 0.16
            
        }
        if player.node.position.y > minimumHeight && playerVelocity > 0  {
            for platform in platforms {
                platform.position.y -= CGFloat(distance)
                ground.position.y -= CGFloat(distance)
                if platform.position.y < platform.frame.size.height/2 {
                    print("saindo de fininho")
                    
                    update(platform: platform, positionY: platform.position.y, ground: ground)
                }
                
            }
        }
    }
    
    func update(platform: SKNode, positionY: CGFloat, ground: SKNode) {
        platform.position.x = CGFloat.random(in: 30...parent.frame.size.width)
        platform.removeAllActions()
        ground.removeFromParent()
        platform.alpha = 1.0
        ground.position.y = parent.frame.size.height + ground.frame.size.height/2 + ground.position.y
        platform.position.y = parent.frame.size.height + platform.frame.size.height/2 + platform.position.y
        
        
    }
    
    func spawn(at position: CGPoint) {
        let new = platformModel.copy() as! SKNode
        new.position = position
        parent.addChild(new)
        platforms.append(new)
       
    }
}
