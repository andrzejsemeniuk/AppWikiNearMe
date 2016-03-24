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
    
    
    
    
    
    func showViewControllerAtIndex(index:Int, animated:Bool) {
        presentationPageIndex = index
        
        setViewControllers([controllers[index]], direction:.Forward, animated:animated, completion:nil)
    }
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if var index = controllers.indexOf(viewController) {
            index -= 1
            if 0 <= index {
                return controllers[index]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if var index = controllers.indexOf(viewController) {
            index += 1
            if index < controllers.count {
                return controllers[index]
            }
        }
        return nil
    }
    
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return presentationPageIndex
    }
    
    
    
}