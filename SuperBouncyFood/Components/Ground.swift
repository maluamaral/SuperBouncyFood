//
//  Ground.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 02/02/22.
//
import SpriteKit

class Ground: GameObject {
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
    }
    
    func start(){
        node.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: 1024, height: 266))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
    }
    
}
