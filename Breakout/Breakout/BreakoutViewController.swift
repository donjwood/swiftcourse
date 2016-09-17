//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Donald Wood on 8/3/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    

    @IBOutlet weak var gameView: UIView!
 
    lazy var breakoutGame: BreakoutGame = {
        let lazilyCreatedBreakoutGame = BreakoutGame(gameView: self.gameView)
        return lazilyCreatedBreakoutGame
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakoutGame = BreakoutGame(gameView: self.gameView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        breakoutGame.resetGameViewAfterResize()
    }
    
    func pushBall() {
        breakoutGame.pushBall()
    }
    
    func movePaddle(gesture: UIPanGestureRecognizer) {
        breakoutGame.movePaddle(gesture)
    }
    
    @IBAction func tapToPushBall(sender: UITapGestureRecognizer) {
        pushBall()
    }
    
    @IBAction func panToMovePaddle(sender: UIPanGestureRecognizer) {
        movePaddle(sender)
    }
   }

