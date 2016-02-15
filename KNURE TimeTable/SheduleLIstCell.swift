//
//  SheduleLIstCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/14/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class SheduleLIstCell: UITableViewCell {
    
    let titleLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        titleLbl.frame = CGRect(x: 15, y: 0, width: self.frame.width, height: self.frame.height)
        titleLbl.textColor = FlatTeal()
        titleLbl.font = UIFont.systemFontOfSize(16, weight: 0.3)
        self.addSubview(titleLbl)
    }
    
    func configure(title: String, row: Int) {
        if row % 2 == 1 {
            self.backgroundColor = FlatWhite().colorWithAlphaComponent(0.6)
        }
        titleLbl.text = title
        // append a mark to already choosen cell:
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultsKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            if title == defaultsKey {
                titleLbl.text?.appendContentsOf(" ✓")
            }
        }
    }
    
    func configureAsEmpty() {
        titleLbl.textColor = FlatTeal()
        titleLbl.font = UIFont.systemFontOfSize(18, weight: 0.2)
        titleLbl.text = "Нет расписаний"

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
