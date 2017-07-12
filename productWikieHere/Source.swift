//
//  Source.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
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
        
        enum Format : String
        {
            case JSON           = "json"
            case None           = "none"
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
            func get_gscoord(_ latitude:[Int], longitude:[Int]) -> String {
                return ""
            }
        }
        
        
        
        
        typealias Result = (_ error:String?,_ data:JSON?) -> ()
        
        
        
        
        class func get_geosearch(_ language:Language = .English, parameters:Dictionary<GeoSearchParameter,String>, format:Format = .JSON, result:@escaping Result)
        {
            let url = "https://" + language.rawValue + ".wikipedia.org/w/api.php"
            
            var pars:[String:AnyObject] = [
                "action"    : "query" as AnyObject,
                "list"      : "geosearch" as AnyObject,
                "format"    : format.rawValue as AnyObject
            ]
            
            for (key,value) in parameters {
                pars[key.rawValue] = value as AnyObject
            }
            
            
            print("get_geosearch:  url=\(url)")
            print("get_geosearch: pars=\(pars)")
            
            // https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=10000&gscoord=37.786971%7C-122.399677
            
            Alamofire.request(url, method: .get, parameters: pars).responseJSON { response in
                
                if let value = response.result.value {
                    let json = JSON(value)
                    print("get_geosearch: success, JSON: \(json)")
                    result(nil,json)
                }
                else {
                    print("get_geosearch: error=\(response.error)")
                }
                
            }
            
            
        }
        
        
        
        
        
        
        
        class func test1TypicalGeosearch1()
        {
            do
            {
                let parameters:[Source.Wikipedia.GeoSearchParameter:String] = [
                    .gscoord    : "30.25|-97.75",
                    .gsradius   : "10000",
                    .gsmaxdim   : "10000",
                    .gslimit    : "10",
                    .gsprop     : "type|name|country|region",
                    .gsprimary  : "all"
                ]
                
                Source.Wikipedia.get_geosearch(.English, parameters:parameters) { error,data in
                    if let d=data {
                        print("ok")
                        print(d)
                        
                        // format: query:geosearch:[item]
                        
                        for entry in d["query"]["geosearch"] {
                            print("entry=\(entry)") // entry= {"0",{...}}
                            
                            let item:Data.Item = entry.1
                            
                            print ("item=\(item)")
                        }
                    }
                    if let e=error {
                        print("error:\(e)")
                    }
                }
                
                
            }
            
        }
        

        
        
        
        
        
    }
}




