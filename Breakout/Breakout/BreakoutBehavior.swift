//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Donald Wood on 8/3/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    //MARK: Constants
    struct Constants {
        static let BallPushMagnitude: CGFloat = 0.1
        static let PaddleBarrierName: String = "Paddle"
        static let BrickBarrierNamePrefix: String = "Brick"
    }
    
    //MARK: Properties
    let gravity = UIGravityBehavior()
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collider.collisionDelegate }
        set { collider.collisionDelegate = newValue }
    }
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
        lazilyCreatedBallBehavior.allowsRotation = false
        lazilyCreatedBallBehavior.elasticity = 1.0
        lazilyCreatedBallBehavior.friction = 0
        lazilyCreatedBallBehavior.resistance = 0
        return lazilyCreatedBallBehavior
    }()

    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
        }()
    
    //MARK: Init
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }

    //MARK: Add Items to Behavior
    func pushBall(ball: UIView) {
        
        //Create ball pusher
        let ballPusher = UIPushBehavior(items: [ball], mode: .Instantaneous)
            ballPusher.magnitude = Constants.BallPushMagnitude
            ballPusher.angle = createRandomAngle()
        
            //Method to remove ball pusher
            ballPusher.action = {[unowned ballPusher] in
                    ballPusher.dynamicAnimator!.removeBehavior(ballPusher)
            }
        
            addChildBehavior(ballPusher)
    }
    
    func addBall(ball: UIView){
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
        //pushStartBall(ball)
    }
    
    func removeBall(ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func addPaddle(paddle: UIView) {
        dynamicAnimator?.referenceView?.addSubview(paddle)
        addPaddleBarrier(paddle)
    }
    
    func addBricks(bricks: [Brick]) {
        for i in 0..<bricks.count {
            if !bricks[i].deleted {
                dynamicAnimator?.referenceView?.addSubview(bricks[i].view)
                addBrickBarrier(bricks[i])
            }
        }
    }
    
    func removeBrick(brickToRemove: Brick) {
        //Collider set before animation because if a collision happens during animation it calls this a second time.
        self.collider.removeBoundaryWithIdentifier(brickToRemove.barrierName)
        UIView.transitionWithView(brickToRemove.view, duration: 0.4, options: [.TransitionCurlUp, .CurveEaseIn], animations: {
                brickToRemove.view.alpha = 0
            }, completion: { (success) -> Void in
                brickToRemove.view.removeFromSuperview()
        })
        
    }
    
    func movePaddle(paddle: UIView) {
        addPaddleBarrier(paddle)
    }
    
    func removePaddle(paddle: UIView) {
        paddle.removeFromSuperview()
    }
    
    func addPaddleBarrier(paddle: UIView) {
        let paddleBarrier = UIBezierPath(roundedRect: paddle.frame, cornerRadius: paddle.layer.cornerRadius)
        addBarrier(paddleBarrier, named: Constants.PaddleBarrierName)
    }
    
    func addBrickBarrier(brick: Brick) {
        let brickBarrier = UIBezierPath(rect: brick.view.frame)
        addBarrier(brickBarrier, named: brick.barrierName)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    //MARK: Private Methods
    private func createRandomAngle() -> CGFloat {
        let randomAngleDeg = arc4random_uniform(360)
        return CGFloat(CDouble(randomAngleDeg) * (0))
    }
    
    private func pushStartBall(ball: UIView) {
        
        //Create ball pusher
        let ballPusher = UIPushBehavior(items: [ball], mode: .Instantaneous)
            ballPusher.magnitude = 0.05
            ballPusher.angle = CGFloat(180*M_PI/180)
            
            //Method to remove ball pusher
            ballPusher.action = {[unowned ballPusher] in
                ballPusher.dynamicAnimator!.removeBehavior(ballPusher)
            }
            
            addChildBehavior(ballPusher)
    }

    
}
