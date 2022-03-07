//
//  PlayerLine.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class PlayerLine: GameObject {
    var isMoving = false
    
    private var container: SKSpriteNode
    private var parent: SKNode
    private var player : Player
    
    init(node: SKSpriteNode, parent: SKNode, player: Player, container: SKSpriteNode) {
        self.parent = parent
        self.player = player
        self.container = container
        super.init(node: node)
    }
    
    func show(atualLocation: CGPoint) {
//        node.position = CGPoint(x: player.node.position.x, y: player.node.position.y + 50)
        container.position = player.node.position
        self.calcYScale(by: atualLocation)
        parent.addChild(container)
    }
    
    func move(atualLocation: CGPoint) {
        // Check if the player drag to a point over the caracter
        if atualLocation.y > player.node.position.y {
            return
        }
        // Check the angle
        let pointB = CGPoint(x: player.node.position.x, y: atualLocation.y)
        let catetoAd = atualLocation.x - pointB.x
        let catetoOp = node.position.y - pointB.y
        let angle = catetoAd / catetoOp
        if abs(angle) > 1 {
            return
        }
        // Check if the playerline was removed
        if container.parent == nil {
            show(atualLocation: atualLocation)
        }
        
        self.container.zRotation =  -angle
        self.calcYScale(by: atualLocation)
        node.isHidden = false
    }
    
    func calcYScale(by atualLocation: CGPoint) {
        let pointB = CGPoint(x: player.node.position.x, y: atualLocation.y)
        let strength = abs(pointB.y - player.node.position.y) / 50
        if strength > 2 {
            node.yScale = 2
        } else if strength < 0.5 {
            node.yScale = 0.5
        } else {
            node.yScale = strength
        }
    }
    
    func reset() {
        container.zRotation = 0
        node.yScale = 0.5
        container.removeFromParent()
    }
}
