//
//  AppGuideViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 11/23/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

private let skipButtonY: CGFloat = 65
private let pageControllY: CGFloat = 85

class AppGuideViewController: UIViewController {
    
    var introView: EAIntroView!
    var titleView = AppGuidePageTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setIntroView()
        
        view.addSubview(titleView)
        view.sendSubview(toBack: titleView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleView.setCenter()
    }
    
    private func setIntroView() {
        
        let introPages = createPages()
        introView = EAIntroView(frame: self.view.frame, andPages: introPages)
        
        introView.delegate = self
        introView.skipButton.setTitle(AppStrings.skip, for: .normal)
        introView.skipButton.setTitleColor(FlatSkyBlue(), for: .normal)
        introView.skipButtonY = skipButtonY
        introView.skipButtonAlignment = .center
        
        introView.pageControlY = pageControllY
        introView.pageControl.currentPageIndicatorTintColor = UIColor.black
        introView.pageControl.pageIndicatorTintColor = UIColor.lightGray

        
        introView.show(in: self.view, animateDuration: 0.3)
    }
    
    private func createPages() -> [EAIntroPage] {
        
        let page1 = EAIntroPage(customViewFromNibNamed: "GuidePageView")
        let page2 = EAIntroPage(customViewFromNibNamed: "GuidePage2")
        let page3 = EAIntroPage(customViewFromNibNamed: "GuidePage3")
        
        return [page1!, page2!, page3!]
    }
}

    //MARK: - EAIntroDelegate:

extension AppGuideViewController: EAIntroDelegate {
    
    func intro(_ introView: EAIntroView!, didScrollWithOffset offset: CGFloat) {
        
        titleView.animate(for: Int(introView.currentPageIndex), with: offset - CGFloat(introView.currentPageIndex))
    }
    
    func intro(_ introView: EAIntroView!, pageAppeared page: EAIntroPage!, with pageIndex: UInt) {
        
        titleView.animateOnce(for: Int(pageIndex))
    }

    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: AppData.initialLunchKey)
        presentRootViewController()
    }
    
    //MARK: - Utilities:
    
    func presentRootViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        self.present(rootViewController, animated: true, completion: nil)
    }
}
