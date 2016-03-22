//
//  Data.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation

class Data : NSObject
{
    struct Item
    {
        // title
        // proximity/distance?
        // lat+long
        // url
        // description?
    }
    
    class func itemsGetWithMaximumDistance(distanceInMeters:Int) {
        
        // list=geosearch
        
        // gscoord          specifies coordinate around which to search
        //  gscoord=12.345|-6.789
        
        // gspage           title of page around which to search (optional)
        //  gspage='title'
        
        // gsradius         search radius in meters (10-10000) (required)
        //  gsradius=100
        
        // gsmaxdim         restrict search to objects no larger than this ('dimension'), in meters
        //  gsmaxdim=1000
        
        // gslimit          maximum number of pages to return, no more than 500 allowed, default=10 (optional)
        //  gslimit=50
        
        // gsglobe          globe to search on, default='earth' (optional)
        //  gsglobe='earth'
        
        // gsnamespace      namespace to search, default='main' (optional)
        //  gsnamespace='main'
        
        // gsprop           specify additional coordinate properties to return separated with '|': type, name, country, region
        //  gsprop=type|name|country|region
        
        // gsprimary        return only primary coordinates ('primary'), secondary ('secondary') or both ('all')? default: primary
        //  gsprimary=all
        
        
    }
}