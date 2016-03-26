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

            case SettingsEntryRowOddOpacity                     = "s+e+row-odd-alpha"
            case SettingsEntryRowEvenOpacity                    = "s+e+row-even-alpha"
            
            case SettingsGeoSearchMaximumResults                = "s+g+max-results"
            
            case SettingsCurrent                                = "settings:current"
            case SettingsList                                   = "s+list"
            case SettingsLastName                               = "s+last-name"
        }
        

        
        
        
        
        static let defaultFont:UIFont = UIFont(name:"Helvetica",size:UIFont.labelFontSize())!
        
        
        
        
        
        
        
        class func settingsGetCurrent() -> [String:AnyObject]
        {
            if let defaults = NSUserDefaults.standardUserDefaults().dictionaryForKey(Key.SettingsCurrent.rawValue) {
                return defaults
            }
            
            let defaults = [String:AnyObject]()
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
            
            return defaults
        }
        
        
        
        
        class func settingsGetBoolForKey(key:Key, defaultValue:Bool = false) -> Bool
        {
            if let result = settingsGetCurrent()["b:"+key.rawValue] as? Bool {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetBool(value:Bool, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["b:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetFloatForKey(key:Key, defaultValue:Float = 0) -> Float
        {
            if let result = settingsGetCurrent()["f:"+key.rawValue] as? Float {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetFloat(value:Float, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["f:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetStringForKey(key:Key, defaultValue:String = "") -> String
        {
            if let result = settingsGetCurrent()["s:"+key.rawValue] as? String {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetString(value:String, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["s:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsPackColor(value:UIColor) -> [Float]
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
        
        class func settingsUnpackColor(value:[Float], defaultValue:UIColor) -> UIColor
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
        
        class func settingsGetColorForKey(key:Key, defaultValue:UIColor = UIColor.blackColor()) -> UIColor
        {
            if let result = settingsGetCurrent()["c:"+key.rawValue] as? [Float] {
                return settingsUnpackColor(result,defaultValue:defaultValue)
            }
            return defaultValue
        }
        
        class func settingsSetColor(value:UIColor, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["c:"+forKey.rawValue] = settingsPackColor(value)
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetArrayForKey(key:Key, defaultValue:[AnyObject] = []) -> [AnyObject]
        {
            if let result = settingsGetCurrent()["A:"+key.rawValue] as? [AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetArray(value:[AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["A:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        class func settingsGetDictionaryForKey(key:Key, defaultValue:[String:AnyObject] = [:]) -> [String:AnyObject]
        {
            if let result = settingsGetCurrent()["D:"+key.rawValue] as? [String:AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetDictionary(value:[String:AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["D:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetFontName(key:Key, defaultValue:String = Data.Manager.defaultFont.fontName) -> String
        {
            return settingsGetStringForKey(key,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        class func settingsGetEntrySelectionColor(defaultValue:UIColor = UIColor.grayColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntrySelectionColor,defaultValue:defaultValue)
        }
        

        
        
        
        class func settingsGetEntryTitleTextFont(defaultValue:UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)) -> UIFont
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
        
        class func settingsGetEntryTitleTextFontColor(defaultValue:UIColor = UIColor.grayColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryTitleTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryTitleTextUppercase(defaultValue:Bool = false) -> Bool
        {
            return settingsGetBoolForKey(.SettingsEntryTitleTextUppercase,defaultValue:defaultValue)
        }
        

        
        
        
        
        class func settingsGetEntrySubtitleTextFont(defaultValue:UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)) -> UIFont
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
        
        class func settingsGetEntrySubtitleTextFontColor(defaultValue:UIColor = UIColor.blackColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntrySubtitleTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntrySubtitleTextUppercase(defaultValue:Bool = false) -> Bool
        {
            return settingsGetBoolForKey(.SettingsEntrySubtitleTextUppercase,defaultValue:defaultValue)
        }
        

        
        
        class func settingsGetEntryIndexTextFont(defaultValue:UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)) -> UIFont
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
        
        class func settingsGetEntryIndexTextFontColor(defaultValue:UIColor = UIColor.blackColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryIndexTextFontColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryIndexBackgroundColor(defaultValue:UIColor = UIColor.yellowColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryIndexBackgroundColor,defaultValue:defaultValue)
        }
        

        
        
        
        
        class func settingsGetEntryRowEvenOpacity(defaultValue:Float = 0.9) -> Float
        {
            return settingsGetFloatForKey(.SettingsEntryRowEvenOpacity,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryRowOddOpacity(defaultValue:Float = 0.8) -> Float
        {
            return settingsGetFloatForKey(.SettingsEntryRowOddOpacity,defaultValue:defaultValue)
        }
        
        

        
        class func settingsGetEntryBackgroundThemeSaturation(defaultValue:Float = 0.7) -> Float
        {
            return settingsGetFloatForKey(.SettingsEntryBackgroundThemeSaturation,defaultValue:defaultValue)
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetGeoSearchMaximumResults(defaultValue defaultValue:UInt = 10) -> UInt
        {
            let value = settingsGetFloatForKey(.SettingsGeoSearchMaximumResults,defaultValue:Float(defaultValue))
            
            if 0 <= value {
                return UInt(value)
            }
            
            return defaultValue
        }
        
        
        
        
        
        
        
        
        
        
        
        class func settingsGetBackgroundColor(defaultValue:UIColor = UIColor.whiteColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsBackgroundColor,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        class func settingsSetThemeWithName(name:String)
        {
            settingsSetString(name,forKey:Key.SettingsThemeName)
        }
        
        
        
        
        
        
        
        class func settingsGetThemeName(defaultValue:String = "Default") -> String
        {
            return settingsGetStringForKey(Key.SettingsThemeName,defaultValue:defaultValue)
        }
        
        
        
        
        

        
        
        
        
        class func settingsSetEntryBackgroundThemeWithName(name:String)
        {
            settingsSetString(name,forKey:Key.SettingsEntryBackgroundThemeName)
        }
        
        
        class func settingsGetEntryBackgroundThemeName(defaultValue:String = "Plain") -> String
        {
            return settingsGetStringForKey(Key.SettingsEntryBackgroundThemeName,defaultValue:defaultValue)
        }
        
        

        
        class func settingsGetEntryBackgroundThemeSolidColor(defaultValue:UIColor = UIColor.redColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsEntryBackgroundThemeSolidColor,defaultValue:defaultValue)
        }
        
        class func settingsGetEntryBackgroundThemeRangeColorFrom(defaultValue:UIColor = UIColor.yellowColor()) -> UIColor
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
        
        class func settingsGetEntryBackgroundThemeRangeColorTo(defaultValue:UIColor = UIColor.orangeColor()) -> UIColor
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
        
        
        
        class func settingsSetEntryBackgroundThemeSolidColor(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeSolidColor)
        }
        
        class func settingsSetEntryBackgroundThemeRangeColorFrom(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeRangeColorFrom)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //        dictionary["from"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsThemeRangeColors)
        }
        
        class func settingsSetEntryBackgroundThemeRangeColorTo(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsEntryBackgroundThemeRangeColorTo)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsThemeRangeColors)
            //        dictionary["to"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsThemeRangeColors)
        }
        
        
        
        
        
        
        
        
        
        class func displayHelpPageForList(controller:UIViewController)
        {
            let key = "display-help-items"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if !defaults.boolForKey(key) {
                defaults.setBool(true,forKey:key)
                
                let alert = UIAlertController(title:"Items", message:"Tap on the right side of an item to increase its quantity.  Tap on the left side to decrease its quantity.", preferredStyle:.Alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.Cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.presentViewController(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        
        class func clearHelpFlags()
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.removeObjectForKey("display-help-categories")
            defaults.removeObjectForKey("display-help-items")
            defaults.removeObjectForKey("display-help-summary")
        }
        
        
        
        
        
        
        
        class func resetIfEmpty()
        {
            if settingsList().empty {
                reset()
                settingsSave("Default")
                settingsUse("Default")
            }
        }
        
        class func reset()
        {
            settingsSetBool(true,forKey:.SettingsEntryTitleTextEmphasize)
            //        settingsSetBool(true,forKey:.SettingsPageCategoriesUppercase)
        }
        
        class func synchronize()
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.synchronize()
        }
        
        
        
        
        
        class func settingsGetLastName(defaultValue:String = "") -> String
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let result = defaults.stringForKey(Key.SettingsLastName.rawValue) {
                return result
            }
            
            return defaultValue
        }
        
        private class func settingsKeyForName(name:String) -> String {
            return "settings="+name
        }
        
        
        class func settingsUse      (name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let settings = defaults.dictionaryForKey(settingsKeyForName(name))
                {
                    defaults.setObject(settings,forKey:Key.SettingsCurrent.rawValue)
                    
                    defaults.setObject(name,forKey:Key.SettingsLastName.rawValue)
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsRemove    (name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.removeObjectForKey(settingsKeyForName(name))
                
                do
                {
                    var list = Set<String>(settingsList())
                    
                    list.remove(name)
                    
                    let array = Array(list)
                    
                    defaults.setObject(array,forKey:Key.SettingsList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func settingsSave     (name:String) -> Bool
        {
            var result = false
            
            var name = name
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let settings = defaults.dictionaryForKey(Key.SettingsCurrent.rawValue)
                {
                    defaults.setObject(settings,forKey:settingsKeyForName(name))
                    
                    defaults.setObject(name,forKey:Key.SettingsLastName.rawValue)
                    
                    do
                    {
                        var list = Set<String>(settingsList())
                        
                        list.insert(name)
                        
                        let array = Array(list)
                        
                        defaults.setObject(array,forKey:Key.SettingsList.rawValue)
                    }
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsListIsEmpty() -> Bool
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let array = defaults.arrayForKey(Key.SettingsList.rawValue)
            
            return array == nil || 0 == array!.count
        }
        
        class func settingsList     () -> [String]
        {
            var result:[String] = []
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let array = defaults.arrayForKey(Key.SettingsList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                    
                }
            }
            
            return result
        }
        
        
    }
    

}