//
//  ControllerOfMap.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfMap : UIViewController
{
    static var instance:ControllerOfMap! = nil
    
    override func viewDidLoad()
    {
        ControllerOfMap.instance        = self
    
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}