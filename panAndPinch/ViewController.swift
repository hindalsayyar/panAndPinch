//
//  ViewController.swift
//  panAndPinch
//
//  Created by imedev4 on 24/04/2019.
//  Copyright © 2019 5W2H. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var backgroundImageView:UIImageView!
    var foregroundImageView:UIImageView!
    var container:UIView!
    var topContainer:UIView!
    
    var initialFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //create container for background and foreground images
        container = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(container)
        
        //background image
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundImageView.image = UIImage(named: "4k")
        self.container.addSubview(backgroundImageView)
        
        //set top image ImageView
        topContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.container.addSubview(topContainer)
        
        
        //background image
        foregroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        foregroundImageView.image = UIImage(named: "rose")
        self.topContainer.addSubview(foregroundImageView)
        
        
        
        
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        topContainer.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        topContainer.addGestureRecognizer(pan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialFrame = foregroundImageView.frame
        
    }
    
    //MARK: Pinch
    @objc func didPinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state != .changed {
            return
        }
        let scale = pinch.scale
        let location = pinch.location(in: topContainer)
        let scaleTransform = foregroundImageView.transform.scaledBy(x: scale, y: scale)
        foregroundImageView.transform = scaleTransform
        
        let dx = foregroundImageView.frame.midX - location.x
        let dy = foregroundImageView.frame.midY - location.y
        let x = dx * scale - dx
        let y = dy * scale - dy
        
        
        let translationTransform = CGAffineTransform(translationX: x, y: y)
        foregroundImageView.transform = foregroundImageView.transform.concatenating(translationTransform)
        
        pinch.scale = 1
    }
    
    
    //MARK: - pan ( move the view even if you zoomed to much)
    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        if pan.state != .changed {
            return
        }
        
        let scale = foregroundImageView.frame.size.width / initialFrame.size.width
        let translation = pan.translation(in: topContainer)
        let transform = foregroundImageView.transform.translatedBy(x: translation.x / scale, y: translation.y / scale)
        foregroundImageView.transform = transform
        pan.setTranslation(.zero, in: topContainer)
    }
    

}

