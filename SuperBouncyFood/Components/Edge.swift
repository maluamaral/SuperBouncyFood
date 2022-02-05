//
//  Edges.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 03/02/22.

import SpriteKit

class Edge: SKNode {
    private var edges: [SKNode]
    
    init(edges: [SKNode]) {
        self.edges = edges
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeEdgeBounds(area: SKSpriteNode){
        for edge in edges {
            switch edge.name {
            case "left" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: area.frame.height))
                edge.position = CGPoint(x: area.frame.minX, y: area.frame.midY)
                print("esquerda")
            case "right" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: area.frame.height))
                edge.position = CGPoint(x: area.frame.maxX, y: area.frame.midY)
                print("direita")
            case "top" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: area.frame.width, height: 1 ))
                edge.position = CGPoint(x: area.frame.midX, y: area.frame.maxY)
                print("top")
            default :
                print("nao há edges")
            }
            
            edge.physicsBody?.isDynamic = false
            edge.physicsBody?.affectedByGravity = false
        }
        
        
        //Right
        
        //Top
    }

}
