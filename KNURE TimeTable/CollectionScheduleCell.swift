//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionScheduleCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textView: UITextView!
    
    func configure(eventTitle: String, eventType: String, auditory: String) {
        self.backgroundColor = UIColor.lightGrayColor()
        textView.text = "\n\(eventTitle)"
        textView.text.appendContentsOf("\n\(eventType) \(auditory)")
    }
}
