//
//  GraphView.swift
//  Calculator
//
//  Created by Donald Wood on 5/28/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func graphFunction(x: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {

    //MARK: Constants
    private struct Constants {
        static let minScale: CGFloat = 0.1
        static let maxScale: CGFloat = 200
    }

    
    //MARK: Graph Properties
    var axesDrawer = AxesDrawer()
    
    @IBInspectable
    var axesColor: UIColor = UIColor.blueColor()
    
    @IBInspectable
    var graphColor: UIColor = UIColor.blueColor()
    
    override var center: CGPoint {
        didSet{
            graphOrigin = center
        }
    }
    
    var graphOrigin: CGPoint = CGPointZero {
        didSet {setNeedsDisplay() }
        //return convertPoint(center, fromView: superview)
    }
    
    var graphBounds: CGRect {
        return convertRect(bounds, fromView: superview)
    }
    
    @IBInspectable
    var scale: CGFloat = 25 {
        didSet {
            scale = min(max(scale, Constants.minScale), Constants.maxScale)
            setNeedsDisplay()
        }
    }
    
    weak var dataSource: GraphViewDataSource?
    
    //MARK: Overidden view methods
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        axesDrawer.color = axesColor
        axesDrawer.drawAxesInRect(graphBounds, origin: graphOrigin, pointsPerUnit: scale)
        drawGraph()
    }
    
    //MARK: Gesture Recognizers
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            //Resetting back to 1 means that only getting difference from last time scale was updated
            gesture.scale = 1
        }
    }
    
    func moveCenter(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            graphOrigin.x += translation.x
            graphOrigin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }

    }

    func centerOnDoubleTap(gesture:UITapGestureRecognizer) {
        graphOrigin = gesture.locationInView(self)
    }
    
    //MARK: Drawing Methods
    func drawGraph() {
        
        graphColor.set()
        let path = UIBezierPath()
        
        var lastDataPointValid = false
        
        for var cgXCoord: CGFloat = bounds.minX; cgXCoord <= bounds.maxX; cgXCoord++ {
            
            let cartXCoord = CGXCoordToCartesianCoord(cgXCoord)
            
            if let cartYCoord = dataSource?.graphFunction(cartXCoord) {
            
                let cgYCoord = CartYCoordToCGCoord(cartYCoord)
            
                if !lastDataPointValid {
                    path.moveToPoint(CGPoint(x:cgXCoord, y:cgYCoord))
                    lastDataPointValid = true
                } else {
                    path.addLineToPoint(CGPoint(x:cgXCoord, y:cgYCoord))
                    path.stroke()
                }
                
            } else {
                
                lastDataPointValid = false
                
            }
        }
    }
    
    func CGXCoordToCartesianCoord (cgXCoord: CGFloat) -> Double {
        return Double((cgXCoord - graphOrigin.x) / scale)
    }
    
    func CGYCoordToCartesianCoord (cgYCoord: CGFloat) -> Double {
        return Double(((cgYCoord - graphOrigin.y) / scale) * -1)
    }
    
    func CartesianXCoordToCGCoord (cartXCoord: Double) -> CGFloat {
        return CGFloat(cartXCoord) * scale + graphOrigin.x
    }
    
    func CartYCoordToCGCoord (cartYCoord: Double) -> CGFloat {
        return CGFloat(cartYCoord) * -1 * scale + graphOrigin.y
    }

    
}
