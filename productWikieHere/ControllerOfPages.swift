//
//  ControllerOfPages.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfPages : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    var controllers:[UIViewController] = []
    
    var presentationPageIndex = 0
    
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfPages")
        

        self.delegate   = self
        
        self.dataSource = self
        
        presentationPageIndex = 0
        
        self.view.backgroundColor = UIColor(white:0.7,alpha:1) //UIColor.redColor()
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    func showViewControllerAtIndex(_ index:Int, animated:Bool) {
        presentationPageIndex = index
        
        setViewControllers([controllers[index]], direction:.forward, animated:animated, completion:nil)
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if var index = controllers.index(of: viewController) {
            index -= 1
            if 0 <= index {
                return controllers[index]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if var index = controllers.index(of: viewController) {
            index += 1
            if index < controllers.count {
                return controllers[index]
            }
        }
        return nil
    }
    
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return presentationPageIndex
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        view.backgroundColor = Data.Manager.settingsGetBackgroundColor()
        
        super.viewWillAppear(animated)
    }
   
}
