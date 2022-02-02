//
//  PlayerLine.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class PlayerLine: GameObject {
    private var parent: SKNode
    private var player : Player
    
    init(node: SKSpriteNode, parent: SKNode, player: Player) {
        self.parent = parent
        self.player = player
        super.init(node: node)
    }
    
    func show(){
        node.position = CGPoint(x: player.node.position.x, y: player.node.position.y + 50)
        parent.addChild(node)
    }
    
    func move(atualLocation: CGPoint){
        let pointB = CGPoint(x: node.position.x, y: atualLocation.y)
        let catetoAd = atualLocation.x - pointB.x
        let catetoOp = node.position.y - pointB.y
        
        let angle = catetoAd / catetoOp

        if atualLocation.y <= player.node.position.y {
            node.isHidden = false
            node.zRotation =  angle
            
            // TODO fazer referente a distancia percorida
            node.yScale = 2
        }else{
            node.isHidden = true
        }
    }
    
    func reset(){
        node.zRotation = 0
        node.yScale = 1
        node.removeFromParent()
    }
}
