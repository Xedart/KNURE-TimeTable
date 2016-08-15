//
//  SchedulesTypesCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class SchedulesTypesCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    let cellTitle = [AppStrings.Groups, AppStrings.Teachers, AppStrings.Audytories]
    let cellImages = ["GroupsImage", "TeachersImage", "AuditoryImage"]
    
    func configure(_ indexPath: IndexPath) {
        typeLabel.text = cellTitle[(indexPath as NSIndexPath).row]
        typeImageView.image = UIImage(named: cellImages[(indexPath as NSIndexPath).row])
    }
}
