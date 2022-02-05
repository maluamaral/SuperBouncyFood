//
//  PlataformSpawner.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 01/02/22.
//

import SpriteKit

class PlatformSpawner {
    
    private var platformModel: SKSpriteNode
    private var parent: SKNode
    private var platforms = [SKSpriteNode]()
    private var player: Player
    private var gameArea: SKSpriteNode!
    
    private var jump : CGFloat = 0
    
    
    init(platformModel: SKSpriteNode, parent: SKNode, player: Player, gameArea: SKSpriteNode) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        self.gameArea = gameArea
        
    }
    
    func makePlatforms(){
        let spaceBetweenPlatforms = gameArea.frame.size.height/4
        for i in 0..<Int(gameArea.frame.size.height/spaceBetweenPlatforms) {
            let x = CGFloat.random(in: gameArea.frame.minX...gameArea.frame.maxX)
            let y = CGFloat.random(in: CGFloat(i)*spaceBetweenPlatforms + 100...CGFloat(i+1)*spaceBetweenPlatforms)
            print("\(x), \(y)")
            spawn(at: CGPoint(x: x, y: y))
        }
    }
    
    
    func updatePlatforms(ground: SKNode, dish: SKNode) {
        let minimumHeight: CGFloat = gameArea.frame.size.height/2
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
                dish.position.y -= CGFloat(distance)
                if platform.position.y < platform.frame.size.height/2 {
                    print("saindo de fininho")
                    
                    update(platform: platform, positionY: platform.position.y, ground: ground, dish: dish as! SKSpriteNode)
                }
                
            }
        }
    }
    
    func update(platform: SKNode, positionY: CGFloat, ground: SKNode, dish: SKSpriteNode) {
        platform.position.x = CGFloat.random(in: 30...gameArea.frame.size.width)
        platform.removeAllActions()
        platform.alpha = 1.0
        
        ground.position.y = gameArea.frame.size.height + ground.frame.size.height/2 + ground.position.y
        platform.position.y = gameArea.frame.size.height + platform.frame.size.height/2 + platform.position.y
        dish.position.y = gameArea.frame.size.height + dish.frame.size.height/2 + dish.position.y
        
        ground.removeFromParent()
        dish.removeFromParent()
        
        
    }
    
    func spawn(at position: CGPoint) {
        let new = platformModel.copy() as! SKSpriteNode
        new.position = position
//        if new.position.x == player.node.position.y {
//            new.position.x +=
//        }
        new.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 242, height: 1))
        new.physicsBody?.isDynamic = false
        new.physicsBody?.affectedByGravity = false
        
        // case is left
        if new.position.x >= gameArea.frame.midX {
            new.xScale = -(new.xScale)
        }
        parent.addChild(new)
        platforms.append(new)
       
    }
    
}
