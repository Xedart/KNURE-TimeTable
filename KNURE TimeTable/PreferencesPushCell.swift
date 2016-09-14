//
//  PreferencesPushCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class PreferencesPushCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        titleLabel.textColor = FlatTeal()
    }
    
    @IBOutlet weak var titleLabel: UILabel!

}

class PreferencesPushEmptyCell: UITableViewCell {
    
    @IBOutlet weak var tipTextView: UITextView!
    
    func setNoSchedulesTip() {
        
        tipTextView.text = AppStrings.noSchedulesTip
    }
    
    func setAPNDisabledTip() {
        
        tipTextView.text = AppStrings.apnDisabledTip
    }
    
}
