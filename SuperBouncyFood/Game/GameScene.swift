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
    private var dish: SKSpriteNode!
    private var playerline: PlayerLine!
    private var spawner: PlatformSpawner!
    private var scoreText: SKLabelNode!
    private var gameArea: SKSpriteNode!
    private var dishBase: SKSpriteNode!
    private var edges: Edge!
    
    private var initialPosition: CGPoint?
    private var firstPosition: CGPoint?
    private var finalPosition: CGPoint?
    private var jumpCounter: Float = 0
    private var score: Int = 0
    
    override func didMove(to view: SKView) {
        // Add
        self.physicsWorld.contactDelegate = self
        
        // Area setup
        gameArea = childNode(withName: "area") as? SKSpriteNode
        
        // Player setup
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        playerNode.name = "player"
        
        //Ground setup
        let groundNode = self.childNode(withName: "ground") as! SKSpriteNode
        ground = Ground(node: groundNode)
        groundNode.name = "ground"
        
        //Dish setup
        dish = self.childNode(withName: "dish") as? SKSpriteNode
        dishBase = self.childNode(withName: "base") as? SKSpriteNode
        
        // Playerline setup
        let playerlineNode = self.childNode(withName: "playerline") as! SKSpriteNode
        playerline = PlayerLine(node: playerlineNode, parent: self, player: player)
        playerlineNode.removeFromParent()
        
        // Plataform setup
        let platformNode = childNode(withName: "platform") as! SKSpriteNode
        spawner = PlatformSpawner(platformModel: platformNode, parent: self, player: player,gameArea: gameArea)
        platformNode.name = "plataform"
        
        // Score setup
        scoreText = childNode(withName: "score") as? SKLabelNode
        
        // Edges setup
        let leftEdgeNode = childNode(withName: "leftEdge")!
        let rightEdgeNode = childNode(withName: "rightEdge")!
        let topEdgeNode = childNode(withName: "topEdge")!
        
        leftEdgeNode.name = "left"
        rightEdgeNode.name = "right"
        topEdgeNode.name = "top"
        
        edges = Edge(edges: [leftEdgeNode, rightEdgeNode, topEdgeNode])
        
        start()
        
    }
    
    func start(){
        edges.makeEdgeBounds(area: gameArea)
        spawner.makePlatforms()
        firstPosition = player.node.position
        player.animationSetup(state: .stop)
        scoreSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchType = self.identifyTouch(touches) {
            switch touchType {
            case .player:
                for touch in touches {
                    let location = touch.location(in: self)
                    
                    if player.node.contains(location) {
                        self.initialPosition = location
                        player.start()
                        player.animationSetup(state: .holding)
                        
                    }
                }
                
                player.isMoving = true
                //playerline.show()
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                
                //playerline.move(atualLocation: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                self.finalPosition = location
                
                player.jump(startPosition: initialPosition!, finalPosition: finalPosition!)
                player.animationSetup(state: .movement)
//                
            }
            saveScore()
            player.isMoving = false
            //playerline.reset()
            ground.start()
            dishBase.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkPlayerPosition()
        spawner.updatePlatforms(ground: ground.node, dish: dish)
        
        if (player.node.physicsBody?.velocity.dy)! < 0 {
            player.animationSetup(state: .stop)
            
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
    
    func checkPlayerPosition() {
        if player.node.position.y < UIScreen.main.bounds.minY {
            gameOver()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
//        guard let nodeA = contact.bodyA.node else { return }
//        guard let nodeB = contact.bodyB.node else { return }

//            if nodeA.name == "edge" {
//
//            } else if nodeB.name == "player" {
//                //collisionBetween(player: nodeA, plataform: nodeB)
//            }
    }
    
    func collisionBetween(player: SKNode, plataform: SKNode) {
        jumpCounter += 1
        print("plataforma")
    }
    
    func scoreSetup(){
        scoreText.fontSize = 50.0
        scoreText.fontName = "HelveticaNeue-Regular"
        scoreText.fontColor = UIColor(named: "brigadeiro")
    
    }
    
    func saveScore(){
        jumpCounter = Float(player.node.position.y - initialPosition!.y)
        if jumpCounter > 0 {
            score += Int(jumpCounter)
            scoreText.text = "\(score)"
        }
        
    }
    
    func gameOver(){
        player.die()
    }
    
    func reset(){
        score = 0
        
    }
    
    
}

enum TouchObject {
    case player
}
