//
//  LeftMenuVIewController.swift//
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import FZAccordionTableView
import DataModel

class noteHeader: FZAccordionTableViewHeaderView {
    
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 54;
    static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";
    
    var titleView = UILabel()
    var lineView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleView.textColor = UIColor.white
        titleView.font = UIFont(name: "HelveticaNeue", size: 22)
        self.contentView.addSubview(titleView)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configure(_ groupTitle: String, frame: CGRect) {
        // frames setup:
        lineView.frame = CGRect(x: 16, y: frame.height, width: frame.width - 16, height: 0.3)
        lineView.backgroundColor = UIColor.lightGray
        titleView.frame = CGRect(x: 16, y: 8, width: frame.width - 16, height: frame.height - 8)
        titleView.text = groupTitle
    }
    
}

class noteCell: UITableViewCell {
    
    static let kAccordionCellViewReuseIdentifier = "AccordionCellViewReuseIdentifier";
    
    var headerDateLabel = UILabel()
    var textView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(textView)
        self.addSubview(headerDateLabel)
        
        //teavtView:
        textView.textColor = UIColor.clear
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 10.0
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 17)
        
        // Hedare Label:
        headerDateLabel.textColor = UIColor.clear
        headerDateLabel.backgroundColor = UIColor.clear
        headerDateLabel.isUserInteractionEnabled = false
        headerDateLabel.layer.cornerRadius = 10.0
        headerDateLabel.clipsToBounds = true
        headerDateLabel.font = UIFont.systemFont(ofSize: 17)
        headerDateLabel.textAlignment = .center
    }
    
    func configure(_ note: Note, frame: CGRect) {
        
        //HeaderLabel:
        headerDateLabel.frame = CGRect(x: 8, y: 0, width: frame.width - 8, height: 25)
        
        //teatvView:
        textView.frame = CGRect(x: 8, y: 0, width: frame.width - 8, height: frame.height - 8)
        
        headerDateLabel.text = note.creationDate
        textView.text = "\n\(note.text)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LeftMenuVIewController: UIViewController {
    
    var schedule: Shedule!
    var infoTableView: FZAccordionTableView!
    var infoLavelView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        let tableViewYOrigin = CGFloat((view.frame.height - (view.frame.height * 0.8)) / 2).rounded()
        
        var width: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = view.frame.width / 2
        } else {
            width = view.frame.width - 100
        }
        infoTableView = FZAccordionTableView(frame: CGRect(x: 0, y: tableViewYOrigin, width: width, height: self.view.frame.size.height - (tableViewYOrigin * 2)), style: UITableViewStyle.grouped)
        infoTableView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        infoTableView.delegate = self;
        infoTableView.dataSource = self;
        infoTableView.isOpaque = false;
        infoTableView.backgroundColor = UIColor.clear;
        infoTableView.backgroundView = nil;
        infoTableView.separatorStyle = .none;
        infoTableView.bounces = false;
        infoTableView.scrollsToTop = false;
        infoTableView.allowMultipleSectionsOpen = true
        infoTableView.emptyDataSetSource = self
        infoTableView.allowsSelection = false
        
        // registering cell classes:
        infoTableView.register(noteHeader.self, forHeaderFooterViewReuseIdentifier: noteHeader.kAccordionHeaderViewReuseIdentifier)
        infoTableView.register(noteCell.self, forCellReuseIdentifier: noteCell.kAccordionCellViewReuseIdentifier)
        
        //Info label:
        infoLavelView = UILabel(frame: CGRect(x: (view.frame.width - 200) / 2, y: view.frame.height - 50, width: 200, height: 30))
        infoLavelView.textColor = UIColor.white
        infoLavelView.textAlignment = .center
        infoLavelView.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.view.addSubview(infoLavelView)
        self.view.addSubview(infoTableView)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        setFrame(size: size)
    }
    
    func setFrame() {
        
         let tableViewYOrigin = CGFloat((view.frame.height - (view.frame.height * 0.8)) / 2).rounded()
        
        var width: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = view.frame.width / 2
        } else {
            width = view.frame.width - 100
        }
        
        infoTableView.frame = CGRect(x: 0, y: tableViewYOrigin, width: width, height: self.view.frame.size.height - (tableViewYOrigin * 2))
        infoTableView.reloadData()
        
        // InfoLabel:
        infoLavelView.frame = CGRect(x: 0, y: (view.frame.height - tableViewYOrigin) + ((tableViewYOrigin - 30) / 2), width: view.frame.width, height: 30)
        
        //set infotable text"
        if !self.schedule.shedule_id.isEmpty {
            self.infoLavelView.text = "\(self.schedule!.shedule_id). \(AppStrings.numberOfNotes) \(self.schedule!.numberOfNotesInSchedule())"
        } else {
            self.infoLavelView.text = ""
        }
    }
    
    func setFrame(size: CGSize) {
        
        let tableViewYOrigin = CGFloat((size.height - (size.height * 0.8)) / 2).rounded()
        
        var width: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = size.width / 2
        } else {
            width = size.width - 100 // 100 - width of content controllers
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            //infoTableView:
            self.infoTableView.frame = CGRect(x: 0, y: tableViewYOrigin, width: width, height: size.height - (tableViewYOrigin * 2))
            
            // InfoLabel:
            self.infoLavelView.frame = CGRect(x: 0, y: (size.height - tableViewYOrigin) + ((tableViewYOrigin - 30) / 2), width: size.width, height: 30)
            self.infoTableView.reloadData()
            
            //set infotable text"
            if !self.schedule.shedule_id.isEmpty {
                self.infoLavelView.text = "\(self.schedule!.shedule_id). \(AppStrings.numberOfNotes) \(self.schedule!.numberOfNotesInSchedule())"
            } else {
                self.infoLavelView.text = ""
            }
        }
    }
}

    //MARK: - TableViewDataSource/Delegate:

extension LeftMenuVIewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.notes[section].notes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if schedule == nil {
            return 0
        } else {
            return schedule.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: noteCell.kAccordionCellViewReuseIdentifier) as! noteCell
        cell.configure(schedule.notes[indexPath.section].notes[(indexPath as NSIndexPath).row], frame: tableView.rectForRow(at: indexPath))
        cell.backgroundColor = UIColor.clear
        
        // set some delay time ( 0.25 second ) after showing text in order to prevent lag effect:
        // (not elegant workaraund but it works )
        let delayTime = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            cell.textView.textColor = UIColor.black
            cell.headerDateLabel.textColor = UIColor.darkGray
            cell.textView.backgroundColor = UIColor.white.withAlphaComponent(0.65)
            cell.headerDateLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: noteHeader.kAccordionHeaderViewReuseIdentifier) as! noteHeader
        header.configure(schedule.notes[section].groupTitle, frame: tableView.rectForHeader(inSection: section))
        let coverView = UIView(frame: header.frame)
        coverView.addSubview(header)
        coverView.tag = section
        coverView.backgroundColor = UIColor.clear
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LeftMenuVIewController.toggleSection(_:))))
        return coverView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let metrix = UITextView()
        metrix.font = UIFont.systemFont(ofSize: 17)
        metrix.frame = CGRect(x: 8, y: 0, width: tableView.frame.width - 8, height: 100)
        let note = schedule.notes[(indexPath as NSIndexPath).section].notes[(indexPath as NSIndexPath).row]
        metrix.text = "\(note.creationDate)\n\(note.text)"
        return metrix.contentSize.height + 8

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return noteHeader.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func toggleSection(_ sender: UITapGestureRecognizer) {
        infoTableView.toggleSection(sender.view!.tag)
    }
    
    // TableView Actions:
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: AppStrings.Delete, handler: { (action , indexPath) -> Void in
            
            // delete linked event from calendar:
            let deletingNote = self.schedule.notes[indexPath.section].notes[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //Sync with calendar:
            // Non custom events:
            if !deletingNote.isCoupledEventCustom {
                if CalendarManager.shouldSycNotes() {
                    appDelegate.eventsManager.deleteEvent(eventId: deletingNote.calendarEventId)
                }
            }
            
            // Custom events:
            if deletingNote.isCoupledEventCustom {
                if CalendarManager.shouldSycNotes() {
                    appDelegate.eventsManager.updateEventNotes(eventId: deletingNote.calendarEventId, notesText: nil)
                }
            }
            
            // delete note from data model:
            
            /* deleteNoteWithId returns true if there are no more notes in note group. i. e. note group is going to be deleted. */
            
            if self.schedule.deleteNoteWithId(self.schedule.notes[indexPath.section].notes[indexPath.row].idToken) {
                
                self.schedule.saveShedule()
                tableView.reloadData()
                
                //set infolabel text:
                if !self.schedule.shedule_id.isEmpty {
                    self.infoLavelView.text = "\(self.schedule!.shedule_id). \(AppStrings.numberOfNotes) \(self.schedule!.numberOfNotesInSchedule())"
                } else {
                    self.infoLavelView.text = ""
                }
                return
            } else {
                
                //row closing animation:
                DispatchQueue.main.async(execute: { () -> Void in
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    tableView.endUpdates()
                })
                self.schedule.saveShedule()
                
                // set infotable text:
                if !self.schedule.shedule_id.isEmpty {
                    self.infoLavelView.text = "\(self.schedule!.shedule_id). \(AppStrings.numberOfNotes) \(self.schedule!.numberOfNotesInSchedule())"
                } else {
                    self.infoLavelView.text = ""
                }
            }
        })
        deleteAction.backgroundColor = UIColor.clear
        
        return [deleteAction]
    }
        
}

    //MARK: - FZAccordionTableViewDelegate

extension LeftMenuVIewController: FZAccordionTableViewDelegate {
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        for row in 0..<schedule.notes[section].notes.count {
            let row = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? noteCell
            row?.textView.textColor = UIColor.clear
            row?.textView.backgroundColor = UIColor.clear
            row?.headerDateLabel.backgroundColor = UIColor.clear
            row?.headerDateLabel.textColor = UIColor.clear
            
        }
    }
}

    //MARK: - DZNEmptyDataSetSource

extension LeftMenuVIewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if !schedule.notes.isEmpty {
            return NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: 1), NSForegroundColorAttributeName: UIColor.lightGray])
        }
        return NSAttributedString(string: AppStrings.NoNotes, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: 1), NSForegroundColorAttributeName: UIColor.white])
    }
}
