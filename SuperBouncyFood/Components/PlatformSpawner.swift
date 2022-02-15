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
    private var gameArea: SKSpriteNode
    private var camera: SKCameraNode
    
    private var jump : CGFloat = 0
    private var reachLimit: Bool = false
    
    
    init(platformModel: SKSpriteNode, parent: SKNode, player: Player, gameArea: SKSpriteNode, camera: SKCameraNode) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        self.gameArea = gameArea
        self.camera = camera
    }
    
    func start() {
        makePlatforms()
    }
    
    func makePlatforms() {
        let frameSize: CGFloat = gameArea.frame.size.height
        let spaceBetweenPlatforms: CGFloat = platformModel.size.height * 3

        for _ in 0...Int(frameSize / spaceBetweenPlatforms) {
            spawnPlatform()
        }
    }
    
    func spawnPlatform() {
        let spaceBetweenPlatforms: CGFloat = platformModel.size.height * 3
        var y: CGFloat = 370
        var isRight = true
        if let lastPlatform = platforms.last {
            y = lastPlatform.frame.maxY + spaceBetweenPlatforms
            isRight = lastPlatform.position.x < gameArea.frame.midX
        }
        
        let minLeft: CGFloat = gameArea.frame.minX + (platformModel.size.width / 3)
        let maxRight: CGFloat = gameArea.frame.maxX - (platformModel.size.width / 4)
        let midLeft: CGFloat = gameArea.frame.midX - (platformModel.size.width / 2)
        let midRight: CGFloat = gameArea.frame.midX + (platformModel.size.width / 2)
        
        let x: CGFloat = isRight ?
            CGFloat.random(in: midRight...maxRight) :
            CGFloat.random(in: minLeft...midLeft)
        let spawnPoint = CGPoint(x: x, y: y)
        spawn(at: spawnPoint)
    }
    
    func update(ground: SKNode, dish: SKNode, base: SKSpriteNode) {
        updateGround(ground: ground, dish: dish, base: base)
        updatePlatforms()
    }
    
    func updateGround(ground: SKNode, dish: SKNode, base: SKSpriteNode) {
        if ground.parent == nil && dish.parent == nil && base.parent == nil {
            return
        }
        // Check if ground, dish, and base is off screen
        if ground.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            ground.removeFromParent()
            dish.removeFromParent()
            base.removeFromParent()
        }
    }
    
    // Check if some platform is off screen
    func updatePlatforms() {
        for (i, platform) in platforms.enumerated() {
            if platform.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
                platform.removeFromParent()
                platforms.remove(at: i)
                spawnPlatform()
            }
        }
    }
    
    func spawn(at position: CGPoint) {
        let new = platformModel.copy() as! SKSpriteNode
        new.position = position
       
        new.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 242, height: 45))
        new.physicsBody?.isDynamic = false
        new.physicsBody?.affectedByGravity = false
        new.name = "platform"
        
        // case is left
        if new.position.x >= gameArea.frame.midX {
            new.xScale = -(new.xScale)
        }
        parent.addChild(new)
        platforms.append(new)
    }
    
}
