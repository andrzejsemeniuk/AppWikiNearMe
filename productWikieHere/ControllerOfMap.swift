//
//  ControllerOfMap.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class ControllerOfMap : UINavigationController, MKMapViewDelegate
{
    var map     :MKMapView!
    var here    :MKUserTrackingBarButtonItem!
    
    override func viewDidLoad()
    {
        map = MKMapView()
        
//        map.delegate        = self
        
        map.mapType                 = .Standard
        map.zoomEnabled             = true
        map.scrollEnabled           = true
        map.pitchEnabled            = false
        map.rotateEnabled           = true
        
        map.showsPointsOfInterest   = true
        map.showsBuildings          = true
        map.showsCompass            = true
//        map.showsZoomControls       = true
        map.showsScale              = true
        map.showsTraffic            = false
        
        map.showsUserLocation       = true
        
        
        
        super.view = map

        
        
        self.here = MKUserTrackingBarButtonItem(mapView:self.map)
        
//        self.setNavigationBarHidden(false,animated:true)
        
//        self.navigationBar.topItem?.setRightBarButtonItem(here,animated:true)
//        self.navigationItem.rightBarButtonItem = here
        
        
        var toolbar = UIToolbar()
        
        // TODO SET-UP LAYOUT CONSTRAINT
        
        toolbar.frame = CGRectMake(0,200,0,0)
        
        toolbar.setItems([here],animated:true)
        
        self.view.addSubview(toolbar)
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
}