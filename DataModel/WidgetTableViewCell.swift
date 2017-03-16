//
//  WidgetTableViewCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/18/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit


public class TodayTbaleViewCell: UITableViewCell {
    
    //Interface outlets:
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var separatorLineView: UIView!
    
    @IBOutlet weak var subjectTitleLabel: UILabel!
    
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    public func configure(fontColor: UIColor, event: Event, schedule: Shedule) {
        
        // set apropriate color to the label depends on version of notification center:
        
        startTimeLabel.textColor = fontColor
        endTimeLabel.textColor = fontColor
        subjectTitleLabel.textColor = fontColor
        
        additionalInfoLabel.clipsToBounds = true
        additionalInfoLabel.layer.cornerRadius = 5.0
        //additionalInfoLabel.layer.borderWidth = 0.4
        if fontColor == UIColor.white {
            additionalInfoLabel.layer.borderColor = UIColor.lightGray.cgColor
            separatorLineView.backgroundColor = UIColor.lightGray
            additionalInfoLabel.backgroundColor = AppData.colorsForPairOfType(Int(event.type))
        } else {
            additionalInfoLabel.layer.borderColor = UIColor.darkGray.cgColor
            separatorLineView.backgroundColor = UIColor.darkGray
            additionalInfoLabel.backgroundColor = AppData.colorsForPairOfType(Int(event.type))
        }
        
        // Set content to labels:
        
        //start time/ end time:
        startTimeLabel.text = AppData.pairsStartTime[event.numberOf_pair]
        endTimeLabel.text = AppData.pairsEndTime[event.numberOf_pair]
        
        //subject label:
        subjectTitleLabel.text = schedule.subjects[event.subject_id]!.briefTitle
        
        //type and auditory label:
        additionalInfoLabel.text = "\(schedule.types[event.type]!.short_name), \(event.auditory)"
    }
}

public class WidgetTableViewEmptyCell: UITableViewCell {
    
    // Interface outlets:
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func configure(fontColor: UIColor) {
        
        titleLabel.textColor = fontColor
        titleLabel.text = AppStrings.NoEvents
    }
}
