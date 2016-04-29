//
//  SchedulesTypesCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class SchedulesTypesCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    let cellTitle = [AppStrings.Groups, AppStrings.Teachers, AppStrings.Audytories]
    let cellImages = ["GroupsImage", "TeachersImage", "AuditoryImage"]
    
    func configure(indexPath: NSIndexPath) {
        typeLabel.text = cellTitle[indexPath.row]
        typeImageView.image = UIImage(named: cellImages[indexPath.row])
    }
}
