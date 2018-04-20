//
//  OnboardingViewController.swift
//  CatchApp
//
//  Created by Bosko Barac on 2/1/17.
//  Copyright © 2017 Borne. All rights reserved.
//

import UIKit
import CMPageControl

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var pageControl: CMPageControl!
    
    var contentViewControllers: [ContentViewController] = [ContentViewController]()
    var pageViewController: UIPageViewController!

    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
       // setupPageControl()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.white
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func initialSetup() {
        self.buttonDone.alpha = 0.0
        self.view.bringSubview(toFront: self.buttonDone)
        self.view.bringSubview(toFront: self.pageControl)
    }
    
    // MARK: - Initialize PageViewController
    
    fileprivate func createPageViewController() {
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.appViewController.pageViewController) as? UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let pageContentViewController1 = ContentViewController.instantiate(fromAppStoryboard: .Login)
        pageContentViewController1.labelOneInfo = "FIND\nSPORTS EVENTS"
        pageContentViewController1.itemIndex = 0
        
        let pageContentViewController2 = ContentViewController.instantiate(fromAppStoryboard: .Login)
        pageContentViewController2.labelOneInfo = "JOIN\nSPORTS EVENTS"
        pageContentViewController2.itemIndex = 1
        
        let pageContentViewController3 = ContentViewController.instantiate(fromAppStoryboard: .Login)
        pageContentViewController3.labelOneInfo = "ENJOY\nSPORTS EVENTS"
        pageContentViewController3.itemIndex = 2
        
        self.contentViewControllers = [pageContentViewController1, pageContentViewController2, pageContentViewController3]
        self.pageViewController!.setViewControllers([pageContentViewController1], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.pageViewController!.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        addChildViewController(self.pageViewController!)
        self.view.addSubview(pageViewController!.view)
        self.pageViewController!.didMove(toParentViewController: self)
    }
    
    // MARK: - Setup PageControl
    
    fileprivate func setupPageControl() {
        self.pageControl.currentIndex = 0
        self.pageControl.elementSelectedImage = UIImage(named: "ActiveDot")
        self.pageControl.elementImage = UIImage(named: "InactiveDot")
        self.pageControl.numberOfElements = self.contentViewControllers.count
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let contentViewController = viewController as! ContentViewController

        var index = contentViewController.itemIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }

        index -= 1
        
        return self.contentViewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let contentViewController = viewController as! ContentViewController
    
        var index = contentViewController.itemIndex as Int
        
        if ((index == NSNotFound)) {
            return nil
        }

        index += 1

        
        if (index == contentViewControllers.count) {
            return nil
        }
        
        return self.contentViewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        if let currentIndex = (pageViewController.viewControllers?.last as? ContentViewController)?.itemIndex {
            self.pageControl.currentIndex = currentIndex
            self.index = currentIndex
        }
        
        if (pageViewController.viewControllers?.last as? ContentViewController)?.itemIndex == 2 {
           self.animateButtonNextToShow()
        }
        else {
            self.animateButtonnextToHide()
        }
    }
    
    // MARK: - Animation
    
    func animateButtonNextToShow() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.buttonDone.alpha = 1.0
                        UIApplication.shared.statusBarStyle = .default
                        self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
        })
    }
    
    func animateButtonnextToHide() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.buttonDone.alpha = 0.0
                        UIApplication.shared.statusBarStyle = .lightContent
                        self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
        })
    }

    // MARK: - IBActions

    @IBAction func buttonDone(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.appSegues.onboardingViewControllerToWelcomeViewControllerSegue, sender: self)
    }
}
