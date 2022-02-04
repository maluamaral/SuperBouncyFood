//
//  Edges.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 03/02/22.

import SpriteKit

class Edge: SKNode {
    private var edges: [SKNode]
    private var sceneParent: SKNode
    
    init(edges: [SKNode] , parent: SKNode) {
        self.edges = edges
        self.sceneParent = parent
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeEdgeBounds(){
        for edge in edges {
            switch edge.name {
            case "left" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: sceneParent.frame.height))
                edge.position = CGPoint(x: 0, y: sceneParent.frame.midY)
                print("esquerda")
            case "right" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: sceneParent.frame.height))
                edge.position = CGPoint(x: sceneParent.frame.maxX, y: sceneParent.frame.midY)
                print("direita")
            case "top" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sceneParent.frame.width, height: 1 ))
                edge.position = CGPoint(x: sceneParent.frame.midX, y: sceneParent.frame.maxY)
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
