//
//  GraphViewController.swift
//  Calculator
//
//  Created by Donald Wood on 5/27/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target:graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target:graphView, action:"moveCenter:"))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:graphView, action:"centerOnDoubleTap:")
            tapGestureRecognizer.numberOfTapsRequired = 2
            
            graphView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    var calcBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = calcBrain.evaluatedExpression
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: GraphViewDataSource Protocol Method
    func graphFunction(x: Double) -> Double? {
        
        var y: Double = 0.0
        
        calcBrain.variableValues["M"] = x
        y = calcBrain.evaluate() ?? 0
        
        if y.isNormal || y.isZero {
            return y
        } else {
            return nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
