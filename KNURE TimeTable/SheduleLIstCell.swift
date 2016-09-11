//
//  SheduleLIstCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/14/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class SheduleLIstCell: UITableViewCell {
    
    let titleLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        titleLbl.frame = CGRect(x: 15, y: 0, width: self.frame.width, height: self.frame.height)
        titleLbl.textColor = FlatTeal()
        titleLbl.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        self.addSubview(titleLbl)
    }
    
    func configure(_ title: String, row: Int) {
        titleLbl.text = ""
        titleLbl.text = title
        // append a mark to already choosen cell:
        let defaults = UserDefaults.standard
        if let defaultsKey = defaults.object(forKey: AppData.defaultScheduleKey) as? String {
            if title == defaultsKey {
                titleLbl.text?.append(" ✓")
            }
        }
    }
    
    func configureAsEmpty() {
        selectionStyle = .none
        titleLbl.textColor = FlatTeal()
        titleLbl.font = UIFont.systemFont(ofSize: 17, weight: 0.2)
        titleLbl.text = AppStrings.NoSchedule

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
