//
//  GameScene.swift
//  Jumper
//
//  Created by Maria Luiza Amaral on 27/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var player: Player!
    private var playerline: PlayerLine!
    private var initialPosition: CGPoint?
    private var finalPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        // Add
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Player setup
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        // Playerline setup
        let playerlineNode = self.childNode(withName: "playerline") as! SKSpriteNode
        playerline = PlayerLine(node: playerlineNode)
        playerlineNode.removeFromParent()
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
                playerline.node.position = CGPoint(x: player.node.position.x, y: player.node.position.y + 50)
                self.addChild(playerline.node)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)

                // TODO limitar quantidade de graus maximo, fazer o calculo usando o tamanho da tela
                playerline.node.zRotation = location.x / 50
                // TODO fazer referente a distancia percorida
                playerline.node.yScale = -location.y / 150
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)

                print(location)
                let force = CGVector(dx: location.x * -30, dy: location.y * 10)
                player.node.physicsBody?.applyImpulse(force)
            }
            
            player.isMoving = false
            playerline.node.zRotation = 0
            playerline.node.yScale = 2
            playerline.node.removeFromParent()
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
    }
}

enum TouchObject {
    case player
}
