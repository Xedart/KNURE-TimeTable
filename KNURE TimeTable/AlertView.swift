//
//  AlertView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class AlertView {
    static func getAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.Cancel, handler: handler))
        return alert
    }
}
