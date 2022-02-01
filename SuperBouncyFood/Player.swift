//
//  Player.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 28/01/22.
//

import SpriteKit

class Player: GameObject {
    var isMoving: Bool = false
    
    func touchBegan() {
        self.isMoving = true
    }
}
