//
//  AppDelegate.swift
//  Bouncer
//
//  Created by Donald Wood on 6/11/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    struct Motion {
        static let Manager = CMMotionManager()
    }
}

