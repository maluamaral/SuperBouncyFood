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
    
    private let interval = TimeInterval(2)
    private var currentTime = TimeInterval(0)
    private var distance : CGFloat = 0
    
    
    init(platformModel: SKNode, parent: SKNode, player: Player) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        currentTime = interval
        
    }
    
    func start(){
        for _ in 0...4 {
            spawn()
        }
    }
    
    
    func update(deltaTime: TimeInterval) {

        currentTime += deltaTime

        // interval
        if currentTime > interval {
            //spawn()
            currentTime -= interval
        }

        if let firstplatform = platforms.first {
            if firstplatform.position.y > UIScreen.main.bounds.maxY {
                firstplatform.removeFromParent()
                platforms.removeFirst()
            }
        }
    }
    
    func spawn() {
        
        let new = platformModel.copy() as! SKNode
        new.position.y = distance
        new.position.x = CGFloat.random(in: -280...280)
        parent.addChild(new)
        platforms.append(new)
        distance += 250
    
    }
}
