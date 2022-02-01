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
                let pointB = CGPoint(x: playerline.node.position.x, y: location.y)
                let catetoAd = location.x - pointB.x
                let catetoOp = playerline.node.position.y - pointB.y
                
                //let hipotenusa = pow(catetoAd, 2) + pow(catetoOp, 2)
                
                let angle = catetoAd / catetoOp
            
//               let degreesToRadians =  angle * CGFloat.pi / 180
                if location.y <= player.node.position.y {
                    playerline.node.isHidden = false
                    playerline.node.zRotation =  angle
                    
                    // TODO fazer referente a distancia percorida
                    playerline.node.yScale = 2
                
                }else{
                    playerline.node.isHidden = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                self.finalPosition = location
                
                let dx = -(finalPosition!.x - initialPosition!.x) * 5
                let dy = -(finalPosition!.y - initialPosition!.y)  * 10
                let impulse = CGVector(dx: dx, dy: dy)
                
                player.node.physicsBody?.applyImpulse(impulse)
                //player.node.physicsBody?.applyAngularImpulse(100)
                
                //print(location)
                //                let force = CGVector(dx: location.x * -30, dy: location.y * 10)
                //                player.node.physicsBody?.applyImpulse(force)
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
