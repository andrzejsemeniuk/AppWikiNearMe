//
//  Source.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Source
{
    
    class Wikipedia
    {
        enum Language : String
        {
            case Arabic         = "ar"
            case Catalan        = "ca"
            case Chinese        = "zh"
            case Czech          = "cs"
            case Danish         = "da"
            case Dutch          = "nl"
            case English        = "en"
            case Finnish        = "fi"
            case French         = "fr"
            case German         = "de"
            case Italian        = "it"
            case Japanese       = "ja"
            case Norwegian      = "no"
            case Polish         = "pl"
            case Russian        = "ru"
            case Spanish        = "es"
            case Swedish        = "sv"
            case Turkish        = "tr"
            case Ukrainian      = "uk"
        }
        
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
        
        
        // to make a call to wikipedia:
        //  https://[en|pl|...].wikipedia.org/w/api.php?
        //   action=query&list=geosearch&gsradius=10000&gscoord=37.786971|-122.399677
        

        enum GeoSearchParameter : String
        {
            case gscoord
            case gspage
            case gsradius
            case gsmaxdim
            case gslimit
            case gsglobe
            case gsnamespace
            case gsprop
            case gsprimary
            
            // "a handy function to convert a coordinate into a suitable string
            func get_gscoord(latitude latitude:[Int], longitude:[Int]) -> String {
                return ""
            }
        }
        
        typealias Result = () -> (error:String?,data:[String]?)
        
        class func get_geosearch(language language:Language = .English, parameters:[GeoSearchParameter:String], result:Result)
        {
            // call alamofire here
        }
    }
}