//
//  PreferencesPushCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class PreferencesHeaderView: UIView {
    
    var title = UILabel()
    var plusButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        //title:
        title = UILabel(frame: CGRect(x: 25, y: 0, width: self.frame.width - 50, height: self.frame.height))
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = FlatGrayDark()
        title.textAlignment = .center
        self.addSubview(title)
        
        //plusButton:
        plusButton = UIButton(type: .contactAdd)
        plusButton.tintColor = FlatTeal()
        plusButton.showsTouchWhenHighlighted = true
        plusButton.frame = CGRect(x: self.frame.width - 50, y: self.bounds.origin.y + 4, width: 40, height: self.frame.height - 8)
        
    }
    
    func configure(section: Int) {
        if section == 0 {
            title.text = AppStrings.syncWithCalendar
        } else {
            title.text = AppStrings.pushNotifications
        }
    }
    
    func showPlusButton() {
        self.addSubview(plusButton)
        self.bringSubview(toFront: plusButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PreferenceDisabledScheduleCell: UITableViewCell {
    
    var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 15, y: 0, width: self.frame.width, height: self.frame.height)
        titleLabel.textColor = FlatTeal()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
