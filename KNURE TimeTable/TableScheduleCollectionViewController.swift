//
//  TableScheduleCollectionViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class exampleLayout: UICollectionViewLayout {
    
    override func prepare() {
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        var size = CGSize()
        size.width = collectionView!.frame.width
        size.height = collectionView!.frame.height
        return size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        attr.frame.size.height = 40
        attr.frame.origin.x = 10
        attr.frame.size.width = collectionView!.frame.width - 20
        print(collectionView?.frame.width)
        return [attr]
    }
    
}

class TableScheduleCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.collectionViewLayout

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.after(when: delayTime) {
            
            self.collectionView?.reloadData()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cel
        let label = UILabel()
        label.frame = cell.bounds
        label.backgroundColor = UIColor.red()
        cell.backgroundColor = UIColor.green()
        for subView in cell.subviews {
            subView.removeFromSuperview()
        }
        cell.addSubview(label)
        
        return cell
    }
}
