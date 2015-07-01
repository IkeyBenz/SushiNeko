//
//  Piece.swift
//  SushiNeko
//
//  Created by Ikey Benzaken on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Piece: CCNode {
    weak var left: CCSprite!
    weak var right: CCSprite!

// In sprite builder we left the chopsticks as invisible because we were going to program them in later. Our goal for this piece of code is to make it that if the chopstick is suppose to be on the right side, we make the right schopstick visible. And if the chopstick is suppose to be on the left side, we make the left chopstick visible.
    
    var side: Side = .None {
        didSet{
            left.visible = false
            right.visible = false
            
            if side == .Right {
                right.visible = true
            } else if side == .Left {
                left.visible = true
            }
        }
    }
 
// Here we want to change the side that the chopsticks will appear according to the four rules listed online. If there was a chopstick on the last piece, then there wont be one on the next. 45% of the time, chopsticks will appear on the left side. 45% of the time chopsticks will appear on the right side. 10% of the time, no chopstick will appear. This code was self written :D
    
    func setObstacle(lastSide:Side) -> Side {
        var didHaveAnObstacle: Bool!
        var randomInt = CCRANDOM_0_1()
        
        if lastSide == .None {
            didHaveAnObstacle = false
        } else if lastSide == .Right {
           didHaveAnObstacle = true
        } else if lastSide == .Left {
            didHaveAnObstacle = true
        }
        
        if didHaveAnObstacle == true {
            side = .None
        } else if randomInt < 0.45 {
            side = .Right
        } else if randomInt < 0.9 {
            side = .Left
        } else {
            side = .None
        }
        
        return side
    }
}