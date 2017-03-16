//
//  LabelCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/30/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    
    
    @IBOutlet weak var EmptyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
