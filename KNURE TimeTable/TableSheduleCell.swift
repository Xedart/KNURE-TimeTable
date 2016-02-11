//
//  TableSheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleCell: UITableViewCell {
    
    //MARK: - IBOutlets:

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var subjectType: UILabel!
    @IBOutlet weak var auditory: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(shedule: Shedule, event: Event) {
        subjectTitle.text = shedule.subjects[event.subject_id].fullTitle
        startTime.text = AppData.pairsStartTime[event.numberOf_pair]
        endTime.text = AppData.pairsEndTime[event.numberOf_pair]
        subjectType.text = shedule.types[event.type].full_name
        auditory.text = String(event.auditory)
    }

}
