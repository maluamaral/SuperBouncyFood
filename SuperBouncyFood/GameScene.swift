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
    private var ground: Ground!
    private var playerline: PlayerLine!
    private var spawner: PlatformSpawner!
    private var edges: Edge!
    
    private var initialPosition: CGPoint?
    private var firstPosition: CGPoint?
    private var finalPosition: CGPoint?
    private var jumpCounter: Float = 0
    private var score: Int = 0
    
    override func didMove(to view: SKView) {
        // Add
        self.physicsWorld.contactDelegate = self
        
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Player setup
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        playerNode.name = "player"
        firstPosition = player.node.position
        
        //Ground setup
        let groundNode = self.childNode(withName: "ground") as! SKSpriteNode
        ground = Ground(node: groundNode)
        groundNode.name = "ground"
        
        // Playerline setup
        let playerlineNode = self.childNode(withName: "playerline") as! SKSpriteNode
        playerline = PlayerLine(node: playerlineNode, parent: self, player: player)
        playerlineNode.removeFromParent()
        
        // Plataform setup
        let platformsNode = childNode(withName: "platforms")!
        spawner = PlatformSpawner(platformModel: platformsNode, parent: self, player: player)
        platformsNode.name = "plataform"
        
        let leftEdgeNode = childNode(withName: "leftEdge")!
        let rightEdgeNode = childNode(withName: "rightEdge")!
        let topEdgeNode = childNode(withName: "topEdge")!
        
        leftEdgeNode.name = "left"
        rightEdgeNode.name = "right"
        topEdgeNode.name = "top"
        
        edges = Edge(edges: [leftEdgeNode, rightEdgeNode, topEdgeNode], parent: self)
        
        edges.makeEdgeBounds()
        spawner.makePlatforms()
        
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
//                
            }
            makeScore()
            player.isMoving = false
            playerline.reset()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        spawner.updatePlatforms(ground: ground.node)
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
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

            if nodeA.name == "edge" {
                print("opa, plataforma")
                  jumpCounter = 0
                  print("e morreu")
                
                
            } else if nodeB.name == "player" {
                collisionBetween(player: nodeA, plataform: nodeB)
            }
    }
    
    func collisionBetween(player: SKNode, plataform: SKNode) {
        jumpCounter += 1
        print("plataforma")
    }
    
    func makeScore(){
        score = Int(player.node.position.y - initialPosition!.y)
    }
}

enum TouchObject {
    case player
}
