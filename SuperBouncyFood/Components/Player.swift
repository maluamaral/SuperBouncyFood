//
//  Player.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit
import FirebaseAnalytics

class Player: GameObject {
    var isMoving: Bool = false
    var topY: CGFloat = 0
    
    func jump(lineScale: CGFloat, lineRotation: CGFloat) {
        let yImpulse = cos(lineRotation) * pow(lineScale, 0.5) * 1000.0
        let xImpulse = sin(lineRotation) * pow(lineScale, 0.5) * -1000.0
        
        let impulse = CGVector(dx: xImpulse, dy: yImpulse)
        node.physicsBody?.velocity = impulse
        
        Analytics.logEvent("player_jump", parameters: [
            "impulse_y": yImpulse as NSNumber,
            "impulse_x": xImpulse as NSNumber
        ])
    }
    
    func start() {
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.mass = 0.35
        node.physicsBody?.friction = 0.1
        node.name = "player"
        
        topY = node.position.y
    }
    
    func update(_ currentTime: TimeInterval) {
        if node.position.y > topY {
            topY = node.position.y
        }
        
        if let playerPB = node.physicsBody {
            // Check if is moving
            if playerPB.velocity.dy > CGFLOAT_EPSILON {
                isMoving = true
            } else if playerPB.velocity.dy < -CGFLOAT_EPSILON {
                isMoving = true
            } else  {
                isMoving = false
            }
        } else {
            isMoving = false
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
    
    func die() {
        animationSetup(state: .dead)
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
