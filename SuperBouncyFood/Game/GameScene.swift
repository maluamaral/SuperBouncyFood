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
    private var base: Base!
    private var background: Background!
    private var dish: SKSpriteNode!
    private var playerline: PlayerLine!
    private var playerLineContainer: SKSpriteNode!
    private var spawner: PlatformSpawner!
    private var scoreText: SKLabelNode!
    private var scoreMetersText: SKLabelNode!
    private var gameArea: SKSpriteNode!
    private var dishBase: SKSpriteNode!
    private var pointMarker: SKSpriteNode!
    private var edges: Edge!
    private var cam = SKCameraNode()
    private var topY = CGFloat(800)
    
    private var initialPosition: CGPoint?
    private var firstPosition: CGPoint?
    private var finalPosition: CGPoint?
    private var jumpCounter: Float = 0
    static var score: Int = 0
    
    override func didMove(to view: SKView) {
        // Add
        self.physicsWorld.contactDelegate = self
        
        // Camera
        self.camera = cam
        cam.position = CGPoint(x: 512, y: 683)
        
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
        
        // Base setup
        let baseNode = self.childNode(withName: "base") as! SKSpriteNode
        base = Base(node: baseNode)
        baseNode.name = "base"
        
        // Playerline setup
        playerLineContainer = self.childNode(withName: "playerLineContainer") as? SKSpriteNode
        let playerlineNode = playerLineContainer.childNode(withName: "playerline") as! SKSpriteNode
        playerline = PlayerLine(node: playerlineNode, parent: self, player: player, container: playerLineContainer)
        playerLineContainer.removeFromParent()
        
        // Plataform setup
        let platformNode = childNode(withName: "platform") as? SKSpriteNode
        platformNode!.name = "plataform"
        
        spawner = PlatformSpawner(platformModel: platformNode!, parent: self, player: player,gameArea: gameArea, camera: cam)
        
        // Score setup
        scoreText = childNode(withName: "score") as? SKLabelNode
        scoreMetersText = childNode(withName: "scoreMeters") as? SKLabelNode
        
        // Edges setup
        let leftEdgeNode = childNode(withName: "leftEdge")!
        let rightEdgeNode = childNode(withName: "rightEdge")!
        
        leftEdgeNode.name = "left"
        rightEdgeNode.name = "right"
        
        edges = Edge(edges: [leftEdgeNode, rightEdgeNode], camera: cam)
        
        // Background setup
        let backgroundNode = childNode(withName: "backgrounds")!
        background = Background(node: backgroundNode, gameArea: gameArea, camera: cam)
        
        start()
    }
    
    func start() {
        edges.makeEdgeBounds(area: gameArea)
        spawner.start()
        firstPosition = player.node.position
        player.animationSetup(state: .stop)
        scoreSetup()
        player.start()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchType = self.identifyTouch(touches) {
            switch touchType {
            case .player:
                if player.isMoving {
                    return
                }
                
                for touch in touches {
                    let location = touch.location(in: self)
                    
                    if player.node.contains(location) {
                        self.initialPosition = location
                        player.animationSetup(state: .holding)
                    }
                    
                    playerline.isMoving = true
                    playerline.show(atualLocation: location)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playerline.isMoving {
            for touch in (touches) {
                let location = touch.location(in: self)
                
                playerline.move(atualLocation: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !playerline.isMoving {
            return
        }
        
        for touch in (touches) {
            let location = touch.location(in: self)
            self.finalPosition = location
            player.jump(lineScale: playerline.node.yScale, lineRotation: playerLineContainer.zRotation)
            player.animationSetup(state: .movement)
        }
        
        playerline.isMoving = false
        playerline.reset()
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkPlayerPosition()
        spawner.update(ground: ground.node, dish: dish, base: base.node)
        player.update(currentTime)
        saveScore()
        background.update()
        edges.update()
        // Move camera
        if player.node.position.y > topY {
            topY = player.node.position.y
            cam.position.y = topY
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
        if player.node.frame.minY < cam.position.y - (gameArea.frame.height / 2) {
            gameOver()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        saveScore()
    }
    
    func scoreSetup() {
        scoreText.fontSize = 50.0
        scoreText.fontName = "HelveticaNeue-Bold"
        scoreText.fontColor = UIColor(named: "preto")
        scoreText.text = String(format: "%06d", 0)
        
        scoreMetersText.fontSize = 35.0
        scoreMetersText.fontName = "HelveticaNeue-Regular"
        scoreMetersText.fontColor = UIColor(named: "preto")
        scoreMetersText.text = "m"
        scoreMetersText.position.y = scoreText.position.y
        scoreMetersText.position.x = scoreText.frame.maxX + 15.0
    }
    
    func saveScore() {
        GameScene.score = (Int(player.topY) / 220) - 1
        print("GameScene.score \(GameScene.score)")
        scoreText.text = String(format: "%06d", GameScene.score)
    }
    
    func gameOver() {
        player.die()
//        let gameScene = GameOverScene(fileNamed: "GameOverScene")
//        gameScene?.scaleMode = .aspectFill
//        gameScene?.finalScore = GameScene.score
//        view?.presentScene(gameScene)
        
    }
    
    func reset(){
        GameScene.score = 0
    }
}

enum TouchObject {
    case player
}
