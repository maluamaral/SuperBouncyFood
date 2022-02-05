//
//  Player.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class Player: GameObject {
    var isMoving: Bool = false
    var impulse = CGVector(dx: 0, dy: 0)
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
        
    }
    
    func jump(startPosition: CGPoint, finalPosition: CGPoint){
        let dx = -(finalPosition.x - startPosition.x) * 10
        let dy = -(finalPosition.y - startPosition.y)  * 10
        let impulse = CGVector(dx: dx, dy: dy)
        
        node.physicsBody?.applyImpulse(impulse)
    }
    
    func start(){
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = true
    }
    
    func animationSetup(state: AnimateState) {
        var texture = SKTexture()
        switch state {
        case .stop:
            texture = SKTexture(imageNamed: "idle")
        case .holding:
            texture = SKTexture(imageNamed: "holding")
        case .movement:
            texture = SKTexture(imageNamed: "movement")
        case .dead:
            texture = SKTexture(imageNamed: "dead")
        }
        
        node.texture = texture
    }
    
    func die(){
        
        animationSetup(state: .dead)
        print("morri")
        
    }
    
    func touchBegan() {
        self.isMoving = true
    }
}

enum AnimateState {
    case stop
    case holding
    case movement
    case dead
}
