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
    static var instance:ControllerOfPages!  = nil
    
    
    override func viewDidLoad()
    {
        ControllerOfPages.instance          = self
        
        self.delegate   = self
        
        self.dataSource = self
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController == ControllerOfMap.instance {
            return ControllerOfList.instance.navigationController
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController == ControllerOfList.instance.navigationController {
            return ControllerOfMap.instance
        }
        return nil
    }
 
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        switch pageViewController {
        case ControllerOfList.instance.navigationController!:   return  0
        case ControllerOfMap.instance:                          return  1
        default:                                                return -1
        }
    }
    
    

}