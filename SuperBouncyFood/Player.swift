//
//  Player.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class Player: GameObject {
    var isMoving: Bool = false
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
    
    }
    
    func jump(startPosition: CGPoint, finalPosition: CGPoint){
        let dx = -(finalPosition.x - startPosition.x) * 5
        let dy = -(finalPosition.y - startPosition.y)  * 10
        let impulse = CGVector(dx: dx, dy: dy)
        
        node.physicsBody?.applyImpulse(impulse)
    }
    
    func touchBegan() {
        self.isMoving = true
    }
}
