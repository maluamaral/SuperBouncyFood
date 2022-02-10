//
//  Player.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class Player: GameObject {
    var isMoving: Bool = false
    var isFalling: Bool = false
    var isJumping: Bool = false
    var impulse = CGVector(dx: 0, dy: 0)
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
    }
    
    func jump(lineScale: CGFloat, lineRotation: CGFloat) {
        let yImpulse = lineScale * 400.0
//        if yImpulse < 180 {
//            yImpulse *= 2
//        }
        
        let xImpulse = -lineRotation * 250
        
        let impulse = CGVector(dx: xImpulse, dy: yImpulse)
        node.physicsBody?.applyImpulse(impulse)
    }
    
    func start() {
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.mass = 0.35
        node.name = "player"
    }
    
    func update(_ currentTime: TimeInterval) {
        if let playerPB = node.physicsBody {
            // Check if is jumping
            if playerPB.velocity.dy > 0 {
                isJumping = true
            } else {
                isJumping = false
            }
            // Check if is falling
            if playerPB.velocity.dy < 0 {
                isFalling = true
            } else {
                isFalling = false
            }
            // Check if is moving
            if isJumping || isFalling {
                isMoving = true
            } else {
                isMoving = false
            }
        } else {
            isMoving = false
            isFalling = false
            isJumping = false
        }
        // Change player animation
        if (self.node.physicsBody?.velocity.dy)! < 0 {
            self.animationSetup(state: .stop)
        }
    }
    
    func animationSetup(state: AnimateState) {
        var texture = SKTexture()
        switch state {
        case .stop:
            texture = SKTexture(imageNamed: "Idle")
        case .holding:
            texture = SKTexture(imageNamed: "Holding")
        case .movement:
            texture = SKTexture(imageNamed: "Movement")
        case .dead:
            texture = SKTexture(imageNamed: "Dead")
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
