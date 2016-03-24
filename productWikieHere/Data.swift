//
//  Data.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Data : NSObject
{
    
    /*
     
     {
     "type"     : null,
     "ns"       : 0,
     "dist"     : 1110.9,
     "name"     : "Louis and Mathilde Reuter House",
     "lon"      : -97.744722,
     "region"   : null,
     "pageid"   : 19248638,
     "lat"      : 30.241111,
     "country"  : null,
     "title"    : "National Register of Historic Places listings in Travis County, Texas"
     }

     
     */
    
//    struct Item
//    {
        // title
        // proximity/distance?
        // lat+long
        // url
        // description?
//        var name:           String          = ""
//        var title:          String          = ""
//        var pageid:         String          = ""
//        
//        var type:           String          = ""
//        var primary:        String          = ""
//
//        var region:         String          = ""
//        var country:        String          = ""
//        
//        var longitude:      Double          = 0
//        var latitude:       Double          = 0
//        var distance:       Float           = 0
//
//        var ns:             Int             = 0
//    }
    
    typealias Item = JSON
    
}