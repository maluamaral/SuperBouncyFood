//
//  Edges.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 03/02/22.

import SpriteKit

class Edge: SKNode {
    private var edges: [SKNode]
    private var camera: SKCameraNode
    
    init(edges: [SKNode], camera: SKCameraNode) {
        self.edges = edges
        self.camera = camera
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeEdgeBounds(area: SKSpriteNode) {
        for edge in edges {
            switch edge.name {
            case "left" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: area.frame.height * 2))
                edge.position = CGPoint(x: area.frame.minX, y: area.frame.midY)
            case "right" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: area.frame.height * 2))
                edge.position = CGPoint(x: area.frame.maxX, y: area.frame.midY)
            case "top" :
                edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: area.frame.width * 2, height: 1 ))
                edge.position = CGPoint(x: area.frame.midX, y: area.frame.maxY)
            default :
                print("nao há edges")
            }
            
            edge.physicsBody?.isDynamic = false
            edge.physicsBody?.affectedByGravity = false
        }
    }
    
    func update() {
        for edge in edges {
            switch edge.name {
            case "left" :
                edge.position.y = camera.position.y
            case "right" :
                edge.position.y = camera.position.y
            case "top" :
                edge.position.x = camera.position.x
            default :
                print("nao há edges")
            }
            
            edge.physicsBody?.isDynamic = false
            edge.physicsBody?.affectedByGravity = false
        }
    }

}
