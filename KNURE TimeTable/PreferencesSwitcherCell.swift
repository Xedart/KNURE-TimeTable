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
        if row == 0 {
            cellTitleLabel.text = AppStrings.Notes
        } else if row == 1 {
            cellTitleLabel.text = AppStrings.customEvents
        }
    }
    
    @IBAction func triggerSwitch(_ sender: UISwitch) {
        print(sender.tag)
    }
}
