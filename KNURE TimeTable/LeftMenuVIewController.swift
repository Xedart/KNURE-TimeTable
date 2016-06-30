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
        
        titleView.textColor = UIColor.white()
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
        lineView.backgroundColor = UIColor.lightGray()
        titleView.frame = CGRect(x: 16, y: 8, width: frame.width - 16, height: frame.height - 8)
        titleView.text = groupTitle
    }
    
}

class noteCell: UITableViewCell {
    static let kAccordionCellViewReuseIdentifier = "AccordionCellViewReuseIdentifier";
    
    var textView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.addSubview(textView)
        textView.textColor = UIColor.clear()
    }
    
    func configure(_ note: Note, frame: CGRect) {
        textView.frame = CGRect(x: 8, y: 0, width: frame.width - 16, height: frame.height)
        textView.backgroundColor = UIColor.clear()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = "\(note.creationDate)\n\(note.text)"
        textView.isEditable = false
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
        view.backgroundColor = UIColor.clear()
        var tableViewHeight = CGFloat()
        
        //defining tableViewHeight
        if UIDevice.current().userInterfaceIdiom == .phone {
            tableViewHeight = 54.0
        } else if UIDevice.current().userInterfaceIdiom == .pad {
            tableViewHeight = 84.0
        }
        var width: CGFloat = 0
        if UIDevice.current().userInterfaceIdiom == .pad {
            width = view.frame.width / 2
        } else {
            width = view.frame.width - 100
        }
        infoTableView = FZAccordionTableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - tableViewHeight * 5) / 2.0, width: width, height: tableViewHeight * 5), style: UITableViewStyle.grouped)
        infoTableView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        infoTableView.delegate = self;
        infoTableView.dataSource = self;
        infoTableView.isOpaque = false;
        infoTableView.backgroundColor = UIColor.clear();
        infoTableView.backgroundView = nil;
        infoTableView.separatorStyle = .none;
        infoTableView.bounces = false;
        infoTableView.scrollsToTop = false;
        infoTableView.allowMultipleSectionsOpen = true
        infoTableView.emptyDataSetSource = self
        
        // registering cell classes:
        infoTableView.register(noteHeader.self, forHeaderFooterViewReuseIdentifier: noteHeader.kAccordionHeaderViewReuseIdentifier)
        infoTableView.register(noteCell.self, forCellReuseIdentifier: noteCell.kAccordionCellViewReuseIdentifier)
        
        self.view.addSubview(infoTableView)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        infoTableView.reloadData()
    }
}

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
        cell.configure(schedule.notes[(indexPath as NSIndexPath).section].notes[(indexPath as NSIndexPath).row], frame: tableView.rectForRow(at: indexPath))
        cell.backgroundColor = UIColor.clear()
        
        let delayTime = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.after(when: delayTime) {
            cell.textView.textColor = UIColor.white()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: noteHeader.kAccordionHeaderViewReuseIdentifier) as! noteHeader
        header.configure(schedule.notes[section].groupTitle, frame: tableView.rectForHeader(inSection: section))
        let coverView = UIView(frame: header.frame)
        coverView.addSubview(header)
        coverView.tag = section
        coverView.backgroundColor = UIColor.clear()
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LeftMenuVIewController.toggleSection(_:))))
        return coverView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let metrix = UITextView()
        metrix.font = UIFont.systemFont(ofSize: 17)
        metrix.frame = CGRect(x: 8, y: 0, width: tableView.frame.width - 16, height: 100)
        let note = schedule.notes[(indexPath as NSIndexPath).section].notes[(indexPath as NSIndexPath).row]
        metrix.text = "\(note.creationDate)\n\(note.text)"
        return metrix.contentSize.height

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
}


extension LeftMenuVIewController: FZAccordionTableViewDelegate {
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        for row in 0..<schedule.notes[section].notes.count {
            let row = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? noteCell
            row?.textView.textColor = UIColor.clear()
            
        }
    }
}

extension LeftMenuVIewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> AttributedString! {
        if !schedule.notes.isEmpty {
            return AttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: 1), NSForegroundColorAttributeName: UIColor.lightGray()])
        }
        return AttributedString(string: AppStrings.NoNotes, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: 1), NSForegroundColorAttributeName: UIColor.white()])
    }
}












