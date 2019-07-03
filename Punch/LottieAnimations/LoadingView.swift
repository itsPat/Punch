//
//  LoadingView.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-29.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    let animationView = AnimationView(name: "success")
    let blackView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func didMoveToSuperview() {
        if let superview = self.superview {
            constrainToEdgesOf(superview: superview)
            setupView()
            superview.bringSubviewToFront(self)
        }
    }
    
    func setupView() {
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !subviews.contains(activityView) {
            blackView.frame = frame
            blackView.backgroundColor = .black
            blackView.alpha = 0.5
            addSubview(blackView)
            
            activityView.frame = frame
            activityView.startAnimating()
            activityView.hidesWhenStopped = true
            addSubview(activityView)
        }
    }
    
    func complete() {
        self.activityView.stopAnimating()
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: animationView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            ])
        
        animationView.play { (complete) in
            if complete {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseOut, animations: {
                        self.blackView.alpha = 0.0
                        self.animationView.alpha = 0.0
                    }, completion: { (complete) in
                        if complete {
                            self.removeFromSuperview()
                        }
                    })
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constrainToEdgesOf(superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    
    
}
