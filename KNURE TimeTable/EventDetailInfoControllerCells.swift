//
//  EventDetailInfoControllerCells.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/19/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import ChameleonFramework

class EventDetailInfoTitleCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleView: UITextView!
    
}

class EventDetailHeaderView: UIView {
    
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        // title
        title = UILabel(frame: CGRect(x: 8, y: -8, width: self.bounds.width, height: self.bounds.height))
        title.font = UIFont.systemFontOfSize(18)
        title.textColor = FlatSkyBlue()
        self.addSubview(title)
    }
    
    func configure(section: Int) {
        switch section {
        case 0:
            title.text = ""
        case 1:
            title.text = "Викладач"
        case 2:
            title.text = "Групи"
        case 3:
            title.text = "Нотатки"
        default:
            title.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




