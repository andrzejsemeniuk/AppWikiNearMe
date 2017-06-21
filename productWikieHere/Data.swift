//
//  Data.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

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
    
    typealias Item = JSON
    
    
    
    
    class Manager : NSObject
    {
        enum Key: String
        {
            case PageList, PageWeb, PageMap, PageSettings
            
            case SettingsBackgroundColor                        = "s+background"

            case SettingsTheme                                  = "s+theme"
            case SettingsThemeName                              = "s+theme-name"

            case SettingsEntryBackgroundTheme                   = "s+e+bg"
            case SettingsEntryBackgroundThemeName               = "s+e+bg-name"
            case SettingsEntryBackgroundThemeSolidColor         = "s+e+bg-solid-color"
            case SettingsEntryBackgroundThemeRangeColorFrom     = "s+e+bg-range-color-from"
            case SettingsEntryBackgroundThemeRangeColorTo       = "s+e+bg-range-color-to"
            case SettingsEntryBackgroundThemeCustomColors       = "s+e+bg-custom-colors"
            case SettingsEntryBackgroundThemeSaturation         = "s+e+bg-saturation"
            
            case SettingsEntrySelectionColor                    = "s+e+selection+color"
            
            case SettingsEntryTitleTextUppercase                = "s+e+title+text+uppercase"
            case SettingsEntryTitleTextEmphasize                = "s+e+title+text+emphasize"
            case SettingsEntryTitleTextFontName                 = "s+e+title+text+font+name"
            case SettingsEntryTitleTextFontColor                = "s+e+title+text+font+color"
            case SettingsEntryTitleTextInsets                   = "s+e+title+text+insets"

            case SettingsEntrySubtitleTextUppercase             = "s+e+subtitle+text+uppercase"
            case SettingsEntrySubtitleTextEmphasize             = "s+e+subtitle+text+emphasize"
            case SettingsEntrySubtitleTextFontName              = "s+e+subtitle+text+font+name"
            case SettingsEntrySubtitleTextFontColor             = "s+e+subtitle+text+font+color"
            case SettingsEntrySubtitleTextInsets                = "s+e+subtitle+text+insets"

            case SettingsEntryIndexTextFontName                 = "s+e+index+text+font+name"
            case SettingsEntryIndexTextFontColor                = "s+e+index+text+font+color"
            case SettingsEntryIndexBackgroundColor              = "s+e+index+bg+color"

            case SettingsEntryRowOpacity                        = "s+e+row-even-alpha"
            
            case SettingsGeoSearchMaximumResults                = "s+g+max-results"
            
            case SettingsCurrent                                = "settings:current"
            case SettingsList                                   = "s+list"
            case SettingsLastName                               = "s+last-name"
        }
        

        
        
        
        
        
        
        
        
        
        
        class func settingsGetCurrent() -> [String:AnyObject]
        {
            if let defaults = UserDefaults.standard.dictionary(forKey: Key.SettingsCurrent.rawValue) {
                return defaults as [String : AnyObject]
            }
            
            let defaults = [String:AnyObject]()
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
            
            return defaults
        }
        
        
        
        
        class func settingsGetBoolForKey(_ key:Key, defaultValue:Bool = false) -> Bool
        {
            if let result = settingsGetCurrent()["b:"+key.rawValue] as? Bool {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetBool(_ value:Bool, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["b:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetFloatForKey(_ key:Key, defaultValue:Float = 0) -> Float
        {
            if let result = settingsGetCurrent()["f:"+key.rawValue] as? Float {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetFloat(_ value:Float, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["f:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetStringForKey(_ key:Key, defaultValue:String = "") -> String
        {
            if let result = settingsGetCurrent()["s:"+key.rawValue] as? String {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetString(_ value:String, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["s:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsPackColor(_ value:UIColor) -> [Float]
        {
            let rgba = value.RGBA()
            
            let RGBA:[Float] = [
                Float(rgba.red),
                Float(rgba.green),
                Float(rgba.blue),
                Float(rgba.alpha)
            ]
            
            return RGBA
        }
        
        class func settingsUnpackColor(_ value:[Float], defaultValue:UIColor) -> UIColor
        {
            if 3 < value.count
            {
                return UIColor.RGBA(value[0],value[1],value[2],value[3])
            }
            else
            {
                return defaultValue
            }
        }
        
        class func settingsGetColorForKey(_ key:Key, defaultValue:UIColor = UIColor.black) -> UIColor
        {
            if let result = settingsGetCurrent()["c:"+key.rawValue] as? [Float] {
                return settingsUnpackColor(result,defaultValue:defaultValue)
            }
            return defaultValue
        }
        
        class func settingsSetColor(_ value:UIColor, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["c:"+forKey.rawValue] = settingsPackColor(value) as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetArrayForKey(_ key:Key, defaultValue:[AnyObject] = []) -> [AnyObject]
        {
            if let result = settingsGetCurrent()["A:"+key.rawValue] as? [AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetArray(_ value:[AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["A:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        class func settingsGetDictionaryForKey(_ key:Key, defaultValue:[String:AnyObject] = [:]) -> [String:AnyObject]
        {
            if let result = settingsGetCurrent()["D:"+key.rawValue] as? [String:AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetDictionary(_ value:[String:AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["D:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetFontName(_ key:Key, defaultValue:String = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).familyName) -> String
        {
            return settingsGetStringForKey(key,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        class func settingsGetEntrySelectionColor(_ defaultValue:UIColor = UIColor.gray) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntrySelectionColor,defaultValue:defaultValue)
        }
        

        
        
        
        class func settingsGetEntryTitleTextFont(_ defaultValue:UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)) -> UIFont
        {
            let emphasize:Float = Data.Manager.settingsGetBoolForKey(.SettingsEntryTitleTextEmphasize) ? 2.0 : 0
            
            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntryTitleTextFontName,defaultValue:defaultValue.fontName),
                                 size:CGFloat(emphasize)+defaultValue.pointSize) {
                return font1
            }

            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntryTitleTextFontName,defaultValue:defaultValue.fontName),
                                  size:defaultValue.pointSize) {
                return font1
            }

            return defaultValue
        }
        
        class func settingsGetEntryTitleTextFontColor(_ defaultValue:UIColor = UIColor.gray) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryTitleTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryTitleTextUppercase(_ defaultValue:Bool = false) -> Bool
        {
            return settingsGetBoolForKey(.SettingsEntryTitleTextUppercase,defaultValue:defaultValue)
        }
        

        
        
        
        
        class func settingsGetEntrySubtitleTextFont(_ defaultValue:UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)) -> UIFont
        {
            let emphasize:Float = Data.Manager.settingsGetBoolForKey(.SettingsEntrySubtitleTextEmphasize) ? 1.0 : 0
            
            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntrySubtitleTextFontName,defaultValue:defaultValue.fontName),
                                  size:CGFloat(emphasize)+defaultValue.pointSize) {
                return font1
            }
            
            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntrySubtitleTextFontName,defaultValue:defaultValue.fontName),
                                  size:defaultValue.pointSize) {
                return font1
            }
            
            return defaultValue
        }
        
        class func settingsGetEntrySubtitleTextFontColor(_ defaultValue:UIColor = UIColor.black) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntrySubtitleTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntrySubtitleTextUppercase(_ defaultValue:Bool = false) -> Bool
        {
            return settingsGetBoolForKey(.SettingsEntrySubtitleTextUppercase,defaultValue:defaultValue)
        }
        

        
        
        class func settingsGetEntryIndexTextFont(_ defaultValue:UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)) -> UIFont
        {
//            let emphasize:Float = Data.Manager.settingsGetBoolForKey(.SettingsEntryIndexTextEmphasize) ? 1.0 : 0
//            
//            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntryIndexTextFontName,defaultValue:defaultValue.fontName),
//                                  size:CGFloat(emphasize)+defaultValue.pointSize) {
//                return font1
//            }
            
            if let font1 = UIFont(name:Data.Manager.settingsGetFontName(.SettingsEntryIndexTextFontName,defaultValue:defaultValue.fontName),
                                  size:defaultValue.pointSize) {
                return font1
            }
            
            return defaultValue
        }
        
        class func settingsGetEntryIndexTextFontColor(_ defaultValue:UIColor = UIColor.black) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryIndexTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryIndexBackgroundColor(_ defaultValue:UIColor = UIColor.yellow) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryIndexBackgroundColor,defaultValue:defaultValue)
        }
        

        
        
        
        
        class func settingsGetEntryRowOpacity(_ defaultValue:Float = 0.9) -> Float
        {
            return settingsGetFloatForKey(.SettingsEntryRowOpacity,defaultValue:defaultValue)
        }
        
        
        

        
        class func settingsGetEntryBackgroundThemeSaturation(_ defaultValue:Float = 0.7) -> Float
        {
            return settingsGetFloatForKey(.SettingsEntryBackgroundThemeSaturation,defaultValue:defaultValue)
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetGeoSearchMaximumResults(defaultValue:UInt = 10) -> UInt
        {
            let value = settingsGetFloatForKey(.SettingsGeoSearchMaximumResults,defaultValue:Float(defaultValue))
            
            if 0 <= value {
                return UInt(value)
            }
            
            return defaultValue
        }
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetBackgroundColor(_ defaultValue:UIColor = UIColor.white) -> UIColor
        {
            return settingsGetColorForKey(.SettingsBackgroundColor,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsSetThemeWithName(_ name:String)
        {
            settingsSetString(name,forKey:Key.SettingsThemeName)
        }
        
        
        
        
        
        
        
        class func settingsGetThemeName(_ defaultValue:String = "Default") -> String
        {
            return settingsGetStringForKey(Key.SettingsThemeName,defaultValue:defaultValue)
        }
        
        
        
        
        

        
        
        
        
        class func settingsSetEntryBackgroundThemeWithName(_ name:String)
        {
            settingsSetString(name,forKey:Key.SettingsEntryBackgroundThemeName)
        }
        
        
        class func settingsGetEntryBackgroundThemeName(_ defaultValue:String = "Plain") -> String
        {
            return settingsGetStringForKey(Key.SettingsEntryBackgroundThemeName,defaultValue:defaultValue)
        }
        
        

        
        class func settingsGetEntryBackgroundThemeSolidColor(_ defaultValue:UIColor = UIColor.red) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryBackgroundThemeSolidColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryBackgroundThemeRangeColorFrom(_ defaultValue:UIColor = UIColor.yellow) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorFrom,defaultValue:defaultValue)
            //        let dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //
            //        if let color = dictionary["from"] as? [Float] {
            //            return settingsUnpackColor(color,defaultValue:defaultValue)
            //        }
            //
            //        return defaultValue
        }
        
        class func settingsGetEntryBackgroundThemeRangeColorTo(_ defaultValue:UIColor = UIColor.orange) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorTo,defaultValue:defaultValue)
            //        let dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //
            //        if let color = dictionary["to"] as? [Float] {
            //            return settingsUnpackColor(color,defaultValue:defaultValue)
            //        }
            //
            //        return defaultValue
        }
        
        
        
        class func settingsSetEntryBackgroundThemeSolidColor(_ color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeSolidColor)
        }
        
        class func settingsSetEntryBackgroundThemeRangeColorFrom(_ color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeRangeColorFrom)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //        dictionary["from"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsThemeRangeColors)
        }
        
        class func settingsSetEntryBackgroundThemeRangeColorTo(_ color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeRangeColorTo)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //        dictionary["to"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsThemeRangeColors)
        }
        
        
        
        
        
        
        
        
        
        class func displayHelpPageForList(_ controller:UIViewController)
        {
            let key = "display-help-items"
            
            let defaults = UserDefaults.standard
            
            if !defaults.bool(forKey: key) {
                defaults.set(true,forKey:key)
                
                let alert = UIAlertController(title:"Items", message:"Tap on the right side of an item to increase its quantity.  Tap on the left side to decrease its quantity.", preferredStyle:.alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.present(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        
        class func clearHelpFlags()
        {
            let defaults = UserDefaults.standard
            
            defaults.removeObject(forKey: "display-help-categories")
            defaults.removeObject(forKey: "display-help-items")
            defaults.removeObject(forKey: "display-help-summary")
        }
        
        
        
        
        
        
        
        class func resetIfEmpty()
        {
            if settingsList().empty {
                reset()
                _ = settingsUse("Sky")
            }
        }
        
        class func reset()
        {
            UserDefaults.clear()
            
            // DEFAULT
            
            _ = settingsUse                                 ("Default")
            
            settingsSetFloat                            (10                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(hue:0.53,saturation:0.80,brightness:1),forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Orange")
            settingsSetFloat                            (0.30                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("Helvetica-Bold"               ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("Helvetica"                    ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextEmphasize)

            settingsSetString                           ("Helvetica-Bold"               ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor.red             ,forKey:.SettingsEntryIndexBackgroundColor)

            _ = settingsSave                                ("Default")
            
            // PLAIN

            _ = settingsUse                                 ("Plain")
            
            settingsSetFloat                            (20                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(white:0.9,alpha:1)     ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Plain")
            settingsSetFloat                            (0.40                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("Helvetica-Bold"               ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor.black           ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("Helvetica"                    ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(white:0.5,alpha:1)     ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("Helvetica-Bold"               ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor.gray            ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Plain")

            
            
            settingsSetColor                            (UIColor.black           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.127,1,1])       ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Plain+Yellow")

            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.090,1,1])       ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Plain+Orange")

            settingsSetColor                            (UIColor.white           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0,1,1])           ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Plain+Red")

            // CHARCOAL+Y|O|R|G
            
            settingsSetFloat                            (30                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(white:0.85,alpha:1)    ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Charcoal")
            settingsSetFloat                            (0.30                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("Futura-CondensedMedium"       ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor(white:0.4,alpha:1)     ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("Futura-CondensedMedium"       ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(white:0.3,alpha:1)     ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("Futura"                       ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor(white:0.7,alpha:1)     ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(white:0.2,alpha:1)     ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Charcoal")
            
            settingsSetColor                            (UIColor(white:0.2,alpha:1)     ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.120,1,1])       ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Charcoal+Yellow")
            
            settingsSetColor                            (UIColor(white:0.1,alpha:1)     ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.090,1,0.85])    ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Charcoal+Orange")
            
            settingsSetColor                            (UIColor(hsb:[0,1,0.80])        ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Charcoal+Red")
            
            settingsSetColor                            (UIColor(hsb:[0.30,0.95,0.70])  ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Charcoal+Green")
            

            // STRAWBERRY

            settingsSetFloat                            (25                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(hsb:[0.4,0.6,0.9])     ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Strawberry")
            settingsSetFloat                            (0.30                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("Futura-CondensedMedium"       ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.1,0.4,1])       ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("Futura-CondensedMedium"       ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0,0.4,1])         ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("Futura"                       ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.1,0.2,1])         ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0,1,1])           ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Strawberry")
            
            settingsSetColor                            (UIColor(hsb:[0,0,0])           ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.15,0.6,0.9])        ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Strawberry+Yellow")
            
            settingsSetColor                            (UIColor(hsb:[0.40,0.61,0.82])      ,forKey:.SettingsEntryIndexBackgroundColor)
            _ = settingsSave                                ("Strawberry+Green")
            
            
            // RAINBOW
            
            
            settingsSetFloat                            (10                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(hsb:[0.53,0.4,1])        ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Rainbow")
            settingsSetFloat                            (0.30                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("AvenirNextCondensed-DemiBold" ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor(gray:1.0)              ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (true                           ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-Italic"   ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(gray:1.0)              ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-Heavy"    ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.1,0.2,1])       ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0,1,1])           ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Rainbow+White")
            
            settingsSetColor                            (UIColor(hsb:[0.53,0.6,1])     ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(gray:0.1)              ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetColor                            (UIColor(gray:0.1)              ,forKey:.SettingsEntrySubtitleTextFontColor)
            _ = settingsSave                                ("Rainbow+Black")

            // ORANGE

            settingsSetFloat                            (20                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(hsb:[0.55,0.4,1])        ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Orange")
            settingsSetFloat                            (0.20                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("AvenirNextCondensed-DemiBold" ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.12,0.4,1.0])    ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (true                           ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-Italic"   ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.12,0.5,1.0])    ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (true                           ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-Heavy"    ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.11,1,1])       ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.55,0.4,1])      ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Orange+Blue")
            
            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntryIndexTextFontColor)
            _ = settingsSave                                ("Orange+Blue+Black")
            
            // SKY
            
            settingsSetFloat                            (20                             ,forKey:.SettingsGeoSearchMaximumResults)
            
            settingsSetColor                            (UIColor(hsb:[0.60,0.2,1])        ,forKey:.SettingsBackgroundColor)
            
            settingsSetEntryBackgroundThemeWithName     ("Sky")
            settingsSetFloat                            (0.20                           ,forKey:.SettingsEntryRowOpacity)
            
            settingsSetString                           ("Cochin-Bold"                  ,forKey:.SettingsEntryTitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.55,0.1,1])      ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntryTitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-Italic"   ,forKey:.SettingsEntrySubtitleTextFontName)
            settingsSetColor                            (UIColor(hsb:[0.55,0.2,1])      ,forKey:.SettingsEntrySubtitleTextFontColor)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextUppercase)
            settingsSetBool                             (false                          ,forKey:.SettingsEntrySubtitleTextEmphasize)
            
            settingsSetString                           ("AvenirNextCondensed-DemiBold" ,forKey:.SettingsEntryIndexTextFontName)
            settingsSetColor                            (UIColor(gray:1)                ,forKey:.SettingsEntryIndexTextFontColor)
            settingsSetColor                            (UIColor(hsb:[0.03,1,1])        ,forKey:.SettingsEntryIndexBackgroundColor)
            
            _ = settingsSave                                ("Sky")
            
            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntryTitleTextFontColor)
            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntrySubtitleTextFontColor)
//            settingsSetColor                            (UIColor(gray:0.15)              ,forKey:.SettingsEntryIndexTextFontColor)
            _ = settingsSave                                ("Sky+Black")
            

            // CHERRY
            // GRAPE
            // NIGHT
            // SPRING
            // AUTUMN
            // WINTER
            
            settingsSetBool(true,forKey:.SettingsEntryTitleTextEmphasize)
            //        settingsSetBool(true,forKey:.SettingsPageCategoriesUppercase)
        }
        
        class func synchronize()
        {
            let defaults = UserDefaults.standard
            
            defaults.synchronize()
        }
        
        
        
        
        
        class func settingsGetLastName(_ defaultValue:String = "") -> String
        {
            let defaults = UserDefaults.standard
            
            if let result = defaults.string(forKey: Key.SettingsLastName.rawValue) {
                return result
            }
            
            return defaultValue
        }
        
        fileprivate class func settingsKeyForName(_ name:String) -> String {
            return "settings="+name
        }
        
        
        class func settingsUse      (_ name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                if let settings = defaults.dictionary(forKey: settingsKeyForName(name))
                {
                    defaults.set(settings,forKey:Key.SettingsCurrent.rawValue)
                    
                    defaults.set(name,forKey:Key.SettingsLastName.rawValue)
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsRemove    (_ name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                defaults.removeObject(forKey: settingsKeyForName(name))
                
                do
                {
                    var list = Set<String>(settingsList())
                    
                    list.remove(name)
                    
                    let array = Array(list)
                    
                    defaults.set(array,forKey:Key.SettingsList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func settingsSave     (_ name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                if let settings = defaults.dictionary(forKey: Key.SettingsCurrent.rawValue)
                {
                    defaults.set(settings,forKey:settingsKeyForName(name))
                    
                    defaults.set(name,forKey:Key.SettingsLastName.rawValue)
                    
                    do
                    {
                        var list = Set<String>(settingsList())
                        
                        list.insert(name)
                        
                        let array = Array(list)
                        
                        defaults.set(array,forKey:Key.SettingsList.rawValue)
                    }
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsListIsEmpty() -> Bool
        {
            let defaults = UserDefaults.standard
            
            let array = defaults.array(forKey: Key.SettingsList.rawValue)
            
            return array == nil || 0 == array!.count
        }
        
        class func settingsList     () -> [String]
        {
            var result:[String] = []
            
            let defaults = UserDefaults.standard
            
            if let array = defaults.array(forKey: Key.SettingsList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                    
                }
            }
            
            return result
        }
        
        
    }
    

}
