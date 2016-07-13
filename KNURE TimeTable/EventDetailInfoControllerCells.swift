//
//  EventDetailInfoControllerCells.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/19/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
//import ChameleonFramework

class EventDetailInfoTitleCell: UITableViewCell {

    @IBOutlet weak var eventTitleView: NoteTextView!
    
}

class EventDetailHeaderView: UIView {
    
    var title = UILabel()
    var saveNoteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        // title
        title = UILabel(frame: CGRect(x: 8, y: 0, width: self.bounds.width, height: self.bounds.height))
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = FlatSkyBlue()
        self.addSubview(title)
        
        // save button:
        saveNoteButton = UIButton(frame: CGRect(x: self.frame.width - 100, y: self.bounds.origin.y, width: 100, height: self.bounds.height))
        saveNoteButton.setTitle(AppStrings.Save, for: UIControlState())
        saveNoteButton.setTitleColor(AppData.appleButtonDefault, for: UIControlState())
        saveNoteButton.setTitleColor(AppData.appleButtonDefault.withAlphaComponent(0.6), for: .highlighted)
        saveNoteButton.addTarget(EventDetailViewController(), action: #selector(EventDetailViewController.saveNoteButtonTaped(_:)), for: .touchUpInside)
    }
    
    func configure(_ section: Int) {
        switch section {
        case 0:
            title.text = ""
        case 1:
            title.text = AppStrings.Teacher
        case 2:
            title.text = AppStrings.Groups
        case 3:
            title.text = AppStrings.Notes
        default:
            title.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSaveButton() {
        self.addSubview(saveNoteButton)
        self.bringSubview(toFront: saveNoteButton)
    }
    
    func hideSaveButton() {
        saveNoteButton.removeFromSuperview()
    }
}




