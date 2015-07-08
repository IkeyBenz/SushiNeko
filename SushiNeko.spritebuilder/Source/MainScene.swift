import Foundation

enum Side {
    case Left, Right, None
}

enum Gamestate {
    case Title, Ready, Playing, Gameover
}


class MainScene: CCNode {
    weak var piecesNode: CCNode!
    weak var character: Character!
    weak var restartButton: CCButton!
    var pieces: [Piece] = []
    var pieceLastSide: Side = .Left
    var pieceIndex:Int = 0
    var gamestate: Gamestate = .Title
    weak var lifeBar: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    var score:Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    var timeLeft: Float = 5 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }
    
    func didLoadFromCCB() {
// We want to make place ten pieces on top of each other. So we made a loop that runs ten times. We created a varible "piece" and set it equal to the CCB file "Piece." Since our CCB file "Piece" is a picture of sushi, now our "piece" variable will also be a picture of sushi. Now if we just add ten pieces to our scene, they wont be on top of eachother, they'll all be in one spot. So we need to change the poistion of the y axis of each piece everytime we add a new one. So we made a variable yPosition, which we set equal to the pieces original Height (the y axis) and we multiplied it by i. i is the varibale in our loop that changes from 0 to 10 every iteration of the loop. So when the program starts, the pieces original height is xx and its gonna multiply by 1; meaning we'll have the original yPosition of piece. But the next time the loop runs, i chages to 2. So the yPosition of the second piece will be twice as high, and so on. Now that was have a changing y position, we need to tell the program that the new position of our piece will be (0, yPosition) we use zero cause the x never changes and it was originally zero. Now that we generated ten new pieces with different yPositions, we need to put them into our program so they can actually be seen! We add them as a child, to the parent node "piecesNode" by saying piecesNode.addChild(piece). You put what you want to add, inside the parenthesis. And we also add our different pieces to the pieces array.
        
        for i in 0...10 {
            var piece: Piece = CCBReader.load("Piece") as! Piece
            pieceLastSide = piece.setObstacle(pieceLastSide)
            var yPosition = piece.contentSizeInPoints.height * CGFloat(i)
            
            piece.position = CGPoint(x: 0, y: yPosition)
            piecesNode.addChild(piece)
            pieces.append(piece)
        }
// Next we want to allow users to interact with our game. We do that by setting the userInteractionEnabled boolean to true.
        
        userInteractionEnabled = true
    }
    
// Our game works when the player touches the screen. So when the player touches the screen, we tell the program what to do inside the touchBegan method.
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if isGameOver() { return }
        var touchXPosition = touch.locationInWorld().x
        if touchXPosition < 160 {
            character.moveRight()
        } else if touchXPosition > 160 {
            character.moveLeft()
        }
        if gamestate == .Gameover { return }
        stepTower()
        score++
    }
    
// We want to create a method that moves pieces down everytime the player taps the screen. We also dont want to run out of pieces of sushi, we only have ten across the screen. So everytime a piece gets to the bottom, when the user taps, we move it to the top of the sushi stack. The first step is to declare a variable called pieceIndex by the top of our MainScene. Next, we create a variable called piece thats gonna be equal to our pieces array (that's why we also made an array of pieces earlier) at index "pieceIndex". Since we set pieceIndex to 0 above, our new piece variable is going to equal to the first piece, the piece at index 0, of our pieces array. We then create a variable called yDiff. This is going to be the difference in y axis when we move the first piece to the top of the stack. We multiply the sushi's height (piece.contentSize.height) by 10. We do 10 because we have ten pieces so if we want ours to move to the top, we need to multiply its height by 10 sushis in order for it to get to the top. Now that we have the difference, we actually need to apply it to our bottom piece. Since our variable piece is already set to index 0, when we just write "piece" alone, it knows we're talking about the bottom piece. So to change its position, we write piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff). Ok, so we set the position of piece (piece.position) to be equal to a ccpAdd() method. This is going to add whatever we put in the ccpAdd method, to our piece's position. In our case we want to add the difference in Y axis (yDiff). ccpAdd() takes two parameters: The thing you're adding to, and what you're adding. In our case, we're adding to the piece's position, hence piece.position. And we're adding a CGPoint() to it. We leave x to 0 because we don't want our x to change, we just want our y to change. So we add the CGPoint(x: 0, y: yDiff).
    func stepTower() {
        var piece = pieces[pieceIndex]
        
        var yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
// The sushis overlap eachother a little bit. By changing their zOrder, we change the order in which they overlap with eachother, by choosing which piece will be on top of the other. Notice the pieces on the bottom of the stack are behind the ones on top of the stack. So when we move our piece to the top, we also need to move its zOrder to front! +1 = front -1 = back
        piece.zOrder = piece.zOrder + 1  
   
// For our setObstacle() method to run, we need to tell it which obstacle was the last. At the start of the program it knows that there are ten pieces and goes through them all, but once we start adding more, the computer doesnt know. So we set pieceLastSide to our bottom piece.
        pieceLastSide = piece.setObstacle(pieceLastSide)

// ccpSub does just what ccpAdd does. Here, its gonna subract the pieces height from its y axis so it lowers every time the screen is tapped.
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))

        pieceIndex = (pieceIndex + 1) % 10

// Everytime the user taps, the time bar gets a little bigger.
        timeLeft = timeLeft + 0.25
        
        if isGameOver() { return }
    }
    
    func isGameOver() -> Bool {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gamestate == .Gameover
    }
    
    func triggerGameOver() {
        gamestate = .Gameover
        restartButton.visible = true
    }
    
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    override func update(delta: CCTime) {
        if gamestate != .Playing { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
}
