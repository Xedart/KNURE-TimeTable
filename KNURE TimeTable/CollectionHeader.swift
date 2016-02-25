//
//  CollectionHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateLabel = UILabel(frame: self.bounds)
        dateLabel.textAlignment = .Center
        self.addSubview(dateLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
