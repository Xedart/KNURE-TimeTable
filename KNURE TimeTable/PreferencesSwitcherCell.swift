//
//  PreferencesSwitcherCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class PreferencesSwitcherCell: UITableViewCell {
    
    //IBOutlets:
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellSwitcher: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(row: Int) {
        cellTitleLabel.textColor = FlatTeal()
        cellSwitcher.tag = row
        
        let defaults = UserDefaults.standard
        
        if row == 0 {
            cellTitleLabel.text = AppStrings.Notes
            
            if let notesControlState = defaults.object(forKey: AppData.shouldSuncNotesKey) as? Bool {
                cellSwitcher.isOn = notesControlState
            } else {
                defaults.set(true, forKey: AppData.shouldSuncNotesKey)
                cellSwitcher.isOn = true
            }
            
        } else if row == 1 {
            cellTitleLabel.text = AppStrings.customEvents
            
            if let eventsControlState = defaults.object(forKey: AppData.shouldSyncEventsKey) as? Bool {
                cellSwitcher.isOn = eventsControlState
            } else {
                defaults.set(true, forKey: AppData.shouldSyncEventsKey)
                cellSwitcher.isOn = true
            }
        }
    }
    
    @IBAction func triggerSwitch(_ sender: UISwitch) {
        
        let defaults = UserDefaults.standard
        
        // Note synchronization
        if sender.tag == 0 {
            defaults.set(sender.isOn, forKey: AppData.shouldSuncNotesKey)
        }
        
        // Events synchronization
        if sender.tag == 1 {
            defaults.set(sender.isOn, forKey: AppData.shouldSyncEventsKey)
        }
    }
}
