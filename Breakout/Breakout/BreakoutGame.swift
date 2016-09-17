//
//  BreakoutGame.swift
//  Breakout
//
//  Created by Donald Wood on 8/27/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import Foundation
import UIKit

class BreakoutGame: NSObject, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    //MARK: Constants
    struct Constants {
        //Ball Constants
        static let BallRadius: CGFloat = 10
        static let BallColor = UIColor.redColor()
        
        //PaddleConstants
        static let PaddleSize = CGSize(width: 100.0, height: 20.0)
        static let PaddleBottomOffset: CGFloat = 50
        static let PaddleCornerRadius: CGFloat = 10.0
        static let PaddleColor = UIColor.blackColor()
        
        //Brick Constants
        static let BrickRows: Int = 5
        static let BrickColumns: Int = 6
        static let BrickHorizontalSpacing: CGFloat = 5
        static let BrickVerticalSpacing: CGFloat = 5
        static let BrickHeight: CGFloat = 20
        static let BrickColor = UIColor.greenColor()
        static let BrickBarrierNamePrefix: String = "Brick"
        
        //Shadow Constants
        static let ShadowOffset = CGSize(width: 2.0, height: 2.0)
        static let ShadowOpacity: Float = 0.9
        static let ShadowRadius: CGFloat = 2.0
        
    }
    
    //MARK: Properties
    var gameView: UIView!
    var ball = UIView()
    var paddle = UIView()
    var bricks = [Brick]()
    let breakoutBehavior = BreakoutBehavior()
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamicAnimator.delegate = self
        return lazilyCreatedDynamicAnimator
    }()

    
    //MARK: Initializers
    init(gameView: UIView!) {
        self.gameView = gameView
        super.init()
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
        ball = addBall()
        paddle = addPaddle()
        bricks = addBricks()
    }
    
    //MARK: Methods
    func movePaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let position = gesture.locationInView(gameView)
            let originalPaddleX = paddle.frame.origin.x
            paddle.frame.origin.x = min(max(position.x - paddle.frame.width/2, gameView.bounds.minX), gameView.bounds.maxX - paddle.frame.width)
            if !paddle.frame.intersects(ball.frame) {
                breakoutBehavior.movePaddle(paddle)
            } else {
                paddle.frame.origin.x = originalPaddleX
            }
            gesture.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
        
    }

    func pushBall() {
        breakoutBehavior.pushBall(ball)
    }
 
    func resetGameViewAfterResize() {
        
        //Reset ball
        breakoutBehavior.removeBall(ball)
        ball.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
        breakoutBehavior.addBall(ball)
        
        //Reset Paddle
        paddle.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - Constants.PaddleBottomOffset)
        breakoutBehavior.movePaddle(paddle)
        
        //Reset bricks
        let brickSize = getBrickSize()
        for index in 0..<bricks.count {
            let row = (index/Constants.BrickColumns) + 1
            let column = index%Constants.BrickColumns + 1
            bricks[index].view.frame.size = brickSize
            bricks[index].view.center = getBrickOrigin(row: row, column: column, brickSize: brickSize)
        }
        breakoutBehavior.addBricks(bricks)
    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        let identOpt : NSCopying? = identifier
        
        if let boundaryIdentifier = identOpt as? String {
            //print("Boundary: \(boundaryIdentifier)")
            
            if boundaryIdentifier.hasPrefix("Brick_") {
                if let brickIndex = Int(boundaryIdentifier.componentsSeparatedByString("_")[1]) {
                    bricks[brickIndex].hitCount++
                    if bricks[brickIndex].hitCount >= bricks[brickIndex].maxHits {
                        bricks[brickIndex].deleted = true
                        breakoutBehavior.removeBrick(bricks[brickIndex])
                    }
                }
            }
            
        }
        
//        if let index = identifier as? Int {
//            if let action = bricks[index]?.action {
//                action(index)
//            } else {
//                destroyBrickAtIndex(index)
//            }
//        }
    }
    
    //MARK: Private Methods
    private func addBall() -> UIView {
        let ballSize = CGSize(width: Constants.BallRadius * 2, height: Constants.BallRadius * 2)
        let ball = UIView(frame: CGRect(origin: CGPoint.zero, size: ballSize))
        ball.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
        ball.layer.cornerRadius = CGFloat(Constants.BallRadius)
        ball.backgroundColor = Constants.BallColor
        ball.layer.shadowOffset = Constants.ShadowOffset
        ball.layer.shadowOpacity = Constants.ShadowOpacity
        ball.layer.shadowRadius = Constants.ShadowRadius
        breakoutBehavior.addBall(ball)
        return ball
    }
    
    private func addPaddle() -> UIView {
        let paddleSize = Constants.PaddleSize
        let paddleOrigin = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - Constants.PaddleBottomOffset)
        let paddle = UIView(frame: CGRect(origin: CGPoint.zero, size: paddleSize))
        paddle.center = paddleOrigin
        paddle.layer.cornerRadius = Constants.PaddleCornerRadius
        paddle.backgroundColor = Constants.PaddleColor
        paddle.layer.shadowOffset = Constants.ShadowOffset
        paddle.layer.shadowOpacity = Constants.ShadowOpacity
        paddle.layer.shadowRadius = Constants.ShadowRadius
        breakoutBehavior.addPaddle(paddle)
        return paddle
        
    }

    private func addBricks() -> [Brick] {
        var newBricks = [Brick]()
        let brickSize = getBrickSize()
        
        for row in 1...Constants.BrickRows {
            for column in 1...Constants.BrickColumns {
                let newBrickView = UIView(frame: CGRect(origin: CGPoint.zero, size: brickSize))
                newBrickView.center = getBrickOrigin(row: row, column: column, brickSize: brickSize)
                newBrickView.backgroundColor = Constants.BrickColor
                newBrickView.layer.shadowOffset = Constants.ShadowOffset
                newBrickView.layer.shadowOpacity = Constants.ShadowOpacity
                newBrickView.layer.shadowRadius = Constants.ShadowRadius
                
                let brickBarrierName = Constants.BrickBarrierNamePrefix + "_" + String((row - 1) * Constants.BrickColumns + column - 1)
                
                let newBrick = Brick(view: newBrickView, barrierName: brickBarrierName, maxHits: 1, hitCount: 0, deleted: false)
                
                newBricks.append(newBrick)
            }
        }
        
        breakoutBehavior.addBricks(newBricks)
        
        return newBricks
    }
    
    private func getBrickSize() -> CGSize {
        let width = (gameView.bounds.size.width - Constants.BrickHorizontalSpacing) / CGFloat(Constants.BrickColumns) - Constants.BrickHorizontalSpacing
        return CGSize(width: width, height: Constants.BrickHeight)
    }
    
    private func getBrickOrigin(row row: Int, column: Int, brickSize: CGSize) -> CGPoint {

        let x = (CGFloat(column) * (brickSize.width + Constants.BrickHorizontalSpacing) - brickSize.width / 2.0)
        let y = (CGFloat(row) * (brickSize.height + Constants.BrickVerticalSpacing) - brickSize.height / 2.0)
        return CGPoint(x: x, y: y)
        
    }
    
}

struct Brick {
    var view: UIView
    var barrierName: String
    var maxHits = 0
    var hitCount = 0
    var deleted = false
}

