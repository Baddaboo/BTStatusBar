//
//  BTStatusBar.swift
//  BTStatusBar
//
//  Created by Blake Tsuzaki on 5/28/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

import UIKit

enum BTStatusBarState {
    case transioningIn,
    transioningOut,
    displayingMessage,
    none
}

class BTStatusBar: NSObject {
    static var loadingAnimationInProgress: Bool = false
    static var statusBarWindow = UIWindow()
    static var applicationWindow: UIWindow?
    static var statusBarView = BTStatusBarGradientView()
    static var isLoadingDeterminate = false
    static var state: BTStatusBarState = .none
    static var loadingProgress: CGFloat = 0 {
        didSet {
            if isLoadingDeterminate {
                statusBarView.progress = loadingProgress
            }
        }
    }
    static var message: String? {
        get { return label.text }
        set {
            UIView.animate(withDuration: 0.5, animations: {
                label.alpha = 0
            }) { (_) in
                label.text = newValue
                UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                    label.alpha = 1
                }, completion: nil)
            }
        }
    }
    internal static var label = UILabel()
    internal static var backgroundView = UIView()
    
    class func beginLoadingWithMessage(message: String, indeterminate: Bool) {
        let screenSize = UIScreen.main.bounds
        let statusBarFrame = CGRect(x: 0, y: 0, width: screenSize.width, height: 20)
        isLoadingDeterminate = !indeterminate
        
        applicationWindow = UIApplication.shared.keyWindow
        
        statusBarWindow.windowLevel = UIWindowLevelStatusBar
        statusBarWindow.frame = statusBarFrame
        statusBarWindow.backgroundColor = .clear
        
        activateConstraints()
        
        statusBarWindow.makeKeyAndVisible()
        
        statusBarView.alpha = 1
        statusBarView.beginAnimations()
        
        backgroundView.alpha = 0
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: 0.2)
        label.text = message
        state = .transioningIn
        
        UIView.animate(withDuration: 0.5, animations: {
            backgroundView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                label.alpha = 1
            }, completion: { (_) in
                state = .displayingMessage
            })
        }
    }
    
    class func hideLoadingWithMessage(message: String?) {
        state = .transioningOut
        
        label.text = message
        statusBarView.alpha = 0
        statusBarView.endAnimations()
        
        UIView.animate(withDuration: 0.5, delay: 1, animations: {
            label.alpha = 0
            
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                backgroundView.alpha = 0
            }, completion: { (_) in
                state = .none
                
                self.applicationWindow?.makeKey()
            })
        }
    }
    
    class func activateConstraints() {
        if backgroundView.superview == nil {
            backgroundView.backgroundColor = .black
            statusBarWindow.addSubview(backgroundView)
        }
        if statusBarView.superview == nil {
            statusBarWindow.addSubview(statusBarView)
        }
        if label.superview == nil {
            label.textColor = .white
            label.textAlignment = .center
            statusBarWindow.addSubview(label)
        }
        
        if statusBarWindow.constraints.count == 0 {
            let viewList: [String: UIView] = [
                "statusBarView": statusBarView,
                "backgroundView": backgroundView,
                "label": label
            ]
            statusBarWindow.autoActivateConstraints(viewList: viewList, constraintList: [
                statusBarWindow.compoundConstraints(format: "H:|[statusBarView]|", views: viewList),
                statusBarWindow.compoundConstraints(format: "V:|[statusBarView]|", views: viewList),
                statusBarWindow.compoundConstraints(format: "H:|[backgroundView]|", views: viewList),
                statusBarWindow.compoundConstraints(format: "V:|[backgroundView]|", views: viewList),
                label.height(equalTo: statusBarWindow, offset: -2),
                label.left(),
                label.right(),
                label.top(equalTo: statusBarView, attribute: .top, spacing: 1)
                ])
        } else {
            statusBarWindow.setNeedsLayout()
        }
    }
}
