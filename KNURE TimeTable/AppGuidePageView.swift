//
//  AppGuidePageView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 11/23/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class AppGuidePageTitleView: UIView {
    
    public var firstPageView = FirstPageView()
    public var secondPageView = SecondPageView()
    public var thirdPageView = ThirdPageView()
    
    private var yConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        addSubview(thirdPageView)
        addSubview(secondPageView)
        addSubview(firstPageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animate(for page: Int, with offset: CGFloat) {
        
        switch page {
            
        case 0:
            rotate(with: offset)
        case 1:
            secondPageAnimation(with: offset)
        default:
            return
        }
    }
    
    public func animateOnce(for page: Int) {
        
        switch page {
        case 0:
            firstPageAnimation()
        case 1:
            secondPageAnimation()
        case 2:
            thirdPageViewAnimation()
        default:
            return
        }
    }
    
    private func setConstraintsForSubview() {
        
        //first pageView:
        firstPageView.translatesAutoresizingMaskIntoConstraints = false
        firstPageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        firstPageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        firstPageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        firstPageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //second pageView:
        secondPageView.translatesAutoresizingMaskIntoConstraints = false
        secondPageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        secondPageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        secondPageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        secondPageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //third pageView:
        thirdPageView.translatesAutoresizingMaskIntoConstraints = false
        thirdPageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thirdPageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thirdPageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thirdPageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        removeConstraints(constraints)
        setConstraintsForSubview()
        setFrame()
        setCenter()
    }
    
    private func setFrame() {
        
        let size = sizeForTraitCollection()
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    //Called by AppGuideViewController in viewDidLayoutSubviews():
    public func setCenter() {
        
        if let guideView = superview {
    
            let yPoint: CGFloat = -(guideView.center.y - (guideView.frame.size.height / 4))
            translatesAutoresizingMaskIntoConstraints = false
            if yConstraint != nil {
                yConstraint!.constant = yPoint
            } else {
                centerXAnchor.constraint(equalTo: guideView.centerXAnchor).isActive = true
                yConstraint = centerYAnchor.constraint(equalTo: guideView.centerYAnchor, constant: yPoint)
                yConstraint?.isActive = true
            }
        }
    }
    
    public func sizeForTraitCollection() -> CGSize {

        switch traitCollection.verticalSizeClass {
        case .compact:
            return CGSize(width: 100, height: 100)
        case .regular:
            if traitCollection.horizontalSizeClass == .regular {
                return CGSize( width: 300, height: 300)
            } else {
                return CGSize(width: 200, height: 200)
            }
        default:
            return CGSize()
        }
    }
}

    //MARK: Animations:

private extension AppGuidePageTitleView {
    
    //MARK: Continuous animation:
    
    //first page:
    func rotate(with offset: CGFloat) {
       
    }

    
    func secondPageAnimation(with offset: CGFloat) {
        
        let baseWidth = sizeForTraitCollection().width
        secondPageView.animate(with: offset, and: baseWidth)
    }
    
    //MARK: - Discrete animations:

    func firstPageAnimation() {
        
        secondPageView.animateDissappear()
        
        UIView.animate(withDuration: 0.25) {
            
            self.firstPageView.alpha = 1
        }
        
        //lighting animation:
        let lightingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: self.frame.size.height))
        lightingView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        lightingView.transform = CGAffineTransform(rotationAngle: (23 * CGFloat.pi) / 12)
        addSubview(lightingView)
        
        
        UIView.animate(withDuration: 0.25, delay: 0.03, animations: {
            lightingView.frame.origin.x = self.frame.width
        }, completion: { (finished) in
            lightingView.removeFromSuperview()
        })
    }
    
    func secondPageAnimation() {
        
        UIView.animate(withDuration: 0.25) {
            
            self.firstPageView.alpha = 0
            self.secondPageView.alpha = 1
        }
        secondPageView.animateAppear()
    }
    
    func thirdPageViewAnimation() {
        
        UIView.animate(withDuration: 0.25) {
            
            self.secondPageView.alpha = 0
        }
    }
}






/*
 layer.opacity = Float(1 - offset)
 
 UIView.animate(withDuration: 0, animations: {
 
 self.transform = CGAffineTransform(scaleX: offset + 1, y: offset + 1)
 }) */






