//
//  ViewController.swift
//  BTStatusBar
//
//  Created by Blake Tsuzaki on 5/28/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    let numberOfSimulatedValues: Int = 20
    let simulatedDelay: Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.addTarget(self, action: #selector(ViewController.simulateLoading), for: .touchUpInside)
    }

    func simulateLoading() {
        button.isEnabled = false
        
        BTStatusBar.beginLoadingWithMessage(message: "Preparing", indeterminate: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            BTStatusBar.message = "Uploading"
            for i in 0...self.numberOfSimulatedValues {
                let delay = DispatchTime.now() + 0.5*Double(i)*self.simulatedDelay
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    BTStatusBar.loadingProgress = CGFloat(i)/CGFloat(self.numberOfSimulatedValues)
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 14) { 
            BTStatusBar.hideLoadingWithMessage(message: "Completed")
            self.button.isEnabled = true
        }
    }
}

