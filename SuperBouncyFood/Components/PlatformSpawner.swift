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
    private var pointMarkers = [SKSpriteNode]()
    private var player: Player
    private var gameArea: SKSpriteNode!
    private var pointMarker: SKSpriteNode!
    
    private var jump : CGFloat = 0
    
    
    init(platformModel: SKSpriteNode, parent: SKNode, player: Player, gameArea: SKSpriteNode, pointMarker: SKSpriteNode) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        self.gameArea = gameArea
        self.pointMarker = pointMarker
        
    }
    
    func makePlatforms(){
        let spaceBetweenPlatforms = gameArea.frame.size.height/4
        var x : CGFloat = 0
        for i in 0..<Int(gameArea.frame.size.height/spaceBetweenPlatforms) {
            if i == 0 || i == 1 {
                x = CGFloat.random(in: gameArea.frame.minX...player.node.frame.minX)
            }
            x = CGFloat.random(in: gameArea.frame.minX...gameArea.frame.maxX)
            let y = CGFloat.random(in: CGFloat(i)*spaceBetweenPlatforms + 100...CGFloat(i+1)*spaceBetweenPlatforms)
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
            //jump += 0.16
            
        }
        if player.node.position.y > minimumHeight && playerVelocity > 0  {
            for platform in platforms {
                for point in pointMarkers {
                    //TODO: nao deixar as plataformas descerem quando a coxinha nao consegue subir numa plataforma
                    
                    platform.position.y -= CGFloat(distance)
                    point.position.y -= CGFloat(distance)
                    ground.position.y -= CGFloat(distance)
                    dish.position.y -= CGFloat(distance)
                    if platform.position.y < platform.frame.size.height/2 {
                        print("saindo de fininho")
                        
                        update(platform: platform, ground: ground, dish: dish as! SKSpriteNode, point: point)
                    }
                }
                
            }
        }
    }
    
    func update(platform: SKSpriteNode, ground: SKNode, dish: SKSpriteNode, point: SKSpriteNode) {
        platform.position.x = CGFloat.random(in: gameArea.frame.minX...gameArea.frame.size.width)
        point.position = CGPoint(x: platform.position.x, y: platform.position.y)

        platform.removeAllActions()
        point.removeAllActions()
        platform.alpha = 1.0
        point.alpha = 1.0
        
        point.position.y = gameArea.frame.size.height + platform.frame.size.height/2 + platform.position.y
        ground.position.y = gameArea.frame.size.height + ground.frame.size.height/2 + ground.position.y
        platform.position.y = gameArea.frame.size.height + platform.frame.size.height/2 + platform.position.y
        dish.position.y = gameArea.frame.size.height + dish.frame.size.height/2 + dish.position.y

        ground.removeFromParent()
        dish.removeFromParent()
        
        
        
        
    }
    
    func spawn(at position: CGPoint) {
        let newPoint = pointMarker.copy() as! SKSpriteNode
        let new = platformModel.copy() as! SKSpriteNode
        new.position = position
        newPoint.position = CGPoint(x: position.x, y: position.y + 22)
       
        new.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 242, height: 45))
        new.physicsBody?.isDynamic = false
        new.physicsBody?.affectedByGravity = false
        
        // case is left
        if new.position.x >= gameArea.frame.midX {
            new.xScale = -(new.xScale)
        }
        parent.addChild(new)
        parent.addChild(newPoint)
        platforms.append(new)
        pointMarkers.append(newPoint)
        
    }
    
}
