//
//  GameScene.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 27/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: Player!
    private var playerline: PlayerLine!
    private var spawner: PlatformSpawner!
    
    private var lastUpdate = TimeInterval(0)
    private var initialPosition: CGPoint?
    private var finalPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        // Add
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Player setup
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        
        // Playerline setup
        let playerlineNode = self.childNode(withName: "playerline") as! SKSpriteNode
        playerline = PlayerLine(node: playerlineNode, parent: self, player: player)
        playerlineNode.removeFromParent()
        
        // Plataform setup
        let platformsNode = childNode(withName: "platforms")!
        spawner = PlatformSpawner(platformModel: platformsNode, parent: self, player: player)
        
        spawner.start()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchType = self.identifyTouch(touches) {
            switch touchType {
            case .player:
                for touch in touches {
                    let location = touch.location(in: self)
                    
                    if player.node.contains(location) {
                        self.initialPosition = location
                    }
                }
                
                player.isMoving = true
               
                playerline.show()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                
                playerline.move(atualLocation: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                self.finalPosition = location
                
                player.jump(startPosition: initialPosition!, finalPosition: finalPosition!)
            }
            
            player.isMoving = false
            playerline.reset()
        }
    }
    
    func identifyTouch(_ touches: Set<UITouch>) -> TouchObject? {
        for touch in touches {
            let location = touch.location(in: self)
            
            if player.node.contains(location) {
                return .player
            }
        }
        
        return nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        
        }
}

enum TouchObject {
    case player
}
