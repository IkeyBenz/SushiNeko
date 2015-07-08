//
//  Character.swift
//  SushiNeko
//
//  Created by Ikey Benzaken on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Character: CCSprite {
    
// We want to make methods that will move our character to the opposite side. An easy way to do this is scaleX. ScaleX flips sprites horrizontally around their anchor points. Since we made our anchor points at 50% of our screen (the middle), when we change scaleX to the -1 position, it evenly flips to the opposite side. We did this for right and left.
    var side: Side = .Left
    
    func moveLeft() {
        side = .Left
        scaleX = 1
    }
    
    func moveRight() {
        side = .Right
        scaleX = -1
    }
}