//
//  SecondPageView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 11/30/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class SecondPageView: UIView {

    var rowsImageView = UIImageView()
    var penImageView = UIImageView()
    var ringView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        rowsImageView.image = UIImage(named: "rows")
        penImageView.image = UIImage(named: "pen")
        ringView.image = UIImage(named: "ring")
        
        addSubview(rowsImageView)
        addSubview(ringView)
        setConstraintsForSubViews()
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animate(with offset: CGFloat, and baseWidth: CGFloat) {
        
       // rowsImageView.removeConstraints(rowsImageView.constraints)
        if offset >= 0 {
            rowsImageView.layer.frame.size.width = frame.width * (1 - offset / 4)
        } else {
            penImageView.layer.frame.origin.y = -(offset * 10)
            penImageView.layer.frame.origin.x = -(offset * 10)
        }
    }
    
    public func animateAppear() {
        
        rowsImageView.layer.frame.size.width = frame.width
        penImageView.frame = CGRect(x: -frame.width, y: -frame.height, width: frame.width, height: frame.height)
        if penImageView.superview == nil {
            addSubview(penImageView)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.penImageView.frame.origin.x = self.frame.origin.x
            self.penImageView.frame.origin.y = self.frame.origin.y
            self.penImageView.alpha = 1
        }) { (finished) in
            self.setConstraintsForPenImage()
        }
    }
    
    public func animateDissappear() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.penImageView.frame.origin.x = self.frame.width
            self.penImageView.frame.origin.y = self.frame.height
            self.penImageView.alpha = 0
        })
    }
    
    //MARK: - Constraints:
    
    private func setConstraintsForSubViews() {
        
        setConstraintsForRowsImage()
        setConstraintsForRingImage()
    }
    
    private func setConstraintsForRowsImage() {
        
        rowsImageView.translatesAutoresizingMaskIntoConstraints = false
        rowsImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        rowsImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rowsImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rowsImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setConstraintsForRingImage() {
        
        ringView.translatesAutoresizingMaskIntoConstraints = false
        ringView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ringView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ringView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ringView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setConstraintsForPenImage() {
        
        penImageView.translatesAutoresizingMaskIntoConstraints = false
        penImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        penImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        penImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        penImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
