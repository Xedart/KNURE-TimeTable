//
//  LeftMenuVIewController.swift//
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import FZAccordionTableView

class noteHeader: FZAccordionTableViewHeaderView {
    
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 54;
    static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";
    
    var titleView = UILabel()
    var lineView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleView.textColor = UIColor.whiteColor()
        titleView.font = UIFont(name: "HelveticaNeue", size: 22)
        self.contentView.addSubview(titleView)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configure(groupTitle: String, frame: CGRect) {
        // frames setup:
        lineView.frame = CGRect(x: 16, y: frame.height, width: frame.width - 16, height: 0.3)
        lineView.backgroundColor = UIColor.lightGrayColor()
        titleView.frame = CGRect(x: 16, y: 8, width: frame.width - 16, height: frame.height - 8)
        titleView.text = groupTitle
    }
    
}

class noteCell: UITableViewCell {
    static let kAccordionCellViewReuseIdentifier = "AccordionCellViewReuseIdentifier";
    
    var textView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.addSubview(textView)
        textView.textColor = UIColor.clearColor()
    }
    
    func configure(note: Note, frame: CGRect) {
        textView.frame = CGRect(x: 8, y: 0, width: frame.width - 16, height: frame.height)
        textView.backgroundColor = UIColor.clearColor()
        textView.font = UIFont.systemFontOfSize(17)
        textView.text = "\(note.creationDate)\n\(note.text)"
        textView.editable = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LeftMenuVIewController: UIViewController {
    
    var schedule: Shedule!
    var infoTableView: FZAccordionTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        var tableViewHeight = CGFloat()
        
        //defining tableViewHeight
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            tableViewHeight = 54.0
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            tableViewHeight = 84.0
        }
        var width: CGFloat = 0
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            width = view.frame.width / 2
        } else {
            width = view.frame.width - 100
        }
        infoTableView = FZAccordionTableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - tableViewHeight * 5) / 2.0, width: width, height: tableViewHeight * 5), style: UITableViewStyle.Grouped)
        infoTableView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleTopMargin, .FlexibleWidth]
        infoTableView.delegate = self;
        infoTableView.dataSource = self;
        infoTableView.opaque = false;
        infoTableView.backgroundColor = UIColor.clearColor();
        infoTableView.backgroundView = nil;
        infoTableView.separatorStyle = .None;
        infoTableView.bounces = false;
        infoTableView.scrollsToTop = false;
        infoTableView.allowMultipleSectionsOpen = true
        infoTableView.emptyDataSetSource = self
        
        // registering cell classes:
        infoTableView.registerClass(noteHeader.self, forHeaderFooterViewReuseIdentifier: noteHeader.kAccordionHeaderViewReuseIdentifier)
        infoTableView.registerClass(noteCell.self, forCellReuseIdentifier: noteCell.kAccordionCellViewReuseIdentifier)
        
        self.view.addSubview(infoTableView)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        infoTableView.reloadData()
    }
}

extension LeftMenuVIewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.notes[section].notes.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if schedule == nil {
            return 0
        } else {
            return schedule.notes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(noteCell.kAccordionCellViewReuseIdentifier) as! noteCell
        cell.configure(schedule.notes[indexPath.section].notes[indexPath.row], frame: tableView.rectForRowAtIndexPath(indexPath))
        cell.backgroundColor = UIColor.clearColor()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            cell.textView.textColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(noteHeader.kAccordionHeaderViewReuseIdentifier) as! noteHeader
        header.configure(schedule.notes[section].groupTitle, frame: tableView.rectForHeaderInSection(section))
        let coverView = UIView(frame: header.frame)
        coverView.addSubview(header)
        coverView.tag = section
        coverView.backgroundColor = UIColor.clearColor()
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LeftMenuVIewController.toggleSection(_:))))
        return coverView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let metrix = UITextView()
        metrix.font = UIFont.systemFontOfSize(17)
        metrix.frame = CGRect(x: 8, y: 0, width: tableView.frame.width - 16, height: 100)
        let note = schedule.notes[indexPath.section].notes[indexPath.row]
        metrix.text = "\(note.creationDate)\n\(note.text)"
        return metrix.contentSize.height

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return noteHeader.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func toggleSection(sender: UITapGestureRecognizer) {
        infoTableView.toggleSection(sender.view!.tag)
    }
}


extension LeftMenuVIewController: FZAccordionTableViewDelegate {
    func tableView(tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        for row in 0..<schedule.notes[section].notes.count {
            let row = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as? noteCell
            row?.textView.textColor = UIColor.clearColor()
            
        }
    }
}

extension LeftMenuVIewController: DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if !schedule.notes.isEmpty {
            return NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(22, weight: 1), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        return NSAttributedString(string: AppStrings.NoNotes, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(22, weight: 1), NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
}












