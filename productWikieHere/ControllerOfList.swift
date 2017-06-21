//
//  ControllerOfList.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SwiftyJSON
import TGF

class ControllerOfList : UITableViewController
{
    struct Cell
    {
        var index:              Int
        var indentation:        UInt            = 0
        
        var item:               Data.Item
        
        var title:              String          = ""
        var subtitle:           String          = ""
    }
    
    var cells:[Cell]                = []
    
    var coordinates0:String         = ""
    var coordinates1:String         = ""
    
    var selectedIndex:Int?
    
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfList")
        
        super.title = "List"
        
        
        tableView.separatorStyle = .none // UITableViewCellSeparatorStyle
        
        do
        {
            super.refreshControl = UIRefreshControl()
            
            super.refreshControl?.addTarget(self,action:#selector(ControllerOfList.refresh),for:.valueChanged)
        }
        
        
        if true
        {
            var items = navigationItem.leftBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(title:"Settings", style:.plain, target:self, action: #selector(ControllerOfList.openSettings)),
            ]
            
            navigationItem.leftBarButtonItems = items
        }

        if true
        {
            var items = navigationItem.rightBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(title:"Map", style:.plain, target:self, action: #selector(ControllerOfList.openMap)),
            ]
            
            navigationItem.rightBarButtonItems = items
        }
        
        
        super.viewDidLoad()
        
        
        AppDelegate.authorizationStatusUpdated = {
            // TODO
            //            reload()
            var status:String = ""
            
            switch CLLocationManager.authorizationStatus() {
                case .denied:               status = "Denied"
                case .notDetermined:        status = "Not Determined"
                case .restricted:           status = "Restricted"
                case .authorizedAlways:     status = "Authorized Always"
                case .authorizedWhenInUse:  status = "Authorized When In Use"
            }
            
            print("authorizationStatusUpdated to \(status)")
        }
        
        refresh()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func openSettings()
    {
        let settings = ControllerOfSettings()
        
        settings.title = "Settings"
        
        self.navigationController?.pushViewController(settings, animated:true)
    }
    
    
    
    func openMap()
    {
        let map = ControllerOfMap()
        
        map.title = "Map"
        
        self.navigationController?.pushViewController(map, animated:true)
    }
    
    
    
    struct Style
    {
        var entryTitleTextFont:                 UIFont                      = Data.Manager.settingsGetEntryTitleTextFont()
        var entryTitleTextFontColor:            UIColor                     = Data.Manager.settingsGetEntryTitleTextFontColor()
        var entryTitleTextUppercase:            Bool                        = Data.Manager.settingsGetEntryTitleTextUppercase()
        var entrySubtitleTextFont:              UIFont                      = Data.Manager.settingsGetEntrySubtitleTextFont()
        var entrySubtitleTextFontColor:         UIColor                     = Data.Manager.settingsGetEntrySubtitleTextFontColor()
        var entrySubtitleTextUppercase:         Bool                        = Data.Manager.settingsGetEntrySubtitleTextUppercase()
        var entryRowOpacity:                    CGFloat                     = CGFloat(Data.Manager.settingsGetEntryRowOpacity()).clamp01()
        var entryBackgroundThemeName:           String                      = Data.Manager.settingsGetEntryBackgroundThemeName()
        var entryBackgroundThemeColorFrom:      UIColor                     = Data.Manager.settingsGetEntryBackgroundThemeRangeColorFrom()
        var entryBackgroundThemeColorTo:        UIColor                     = Data.Manager.settingsGetEntryBackgroundThemeRangeColorTo()
        var entryIndexTextFont:                 UIFont                      = Data.Manager.settingsGetEntryIndexTextFont()
        var entryIndexTextFontColor:            UIColor                     = Data.Manager.settingsGetEntryIndexTextFontColor()
        var entryIndexBackgroundColor:          UIColor                     = Data.Manager.settingsGetEntryIndexBackgroundColor()
        var entryIndexBackgroundFont:           UIFont?                     = UIFont(name:"AppleSDGothicNeo-Medium",size:UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).pointSize+26)
    }
    
    fileprivate var style = Style()
    

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        selectedIndex = nil
        
        style = Style()
        
        reload()
        
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()
        
        super.viewWillAppear(animated)
    }
    
    
    fileprivate func colorForRow(_ row:Int) -> UIColor
    {
        let saturation = CGFloat(Data.Manager.settingsGetEntryBackgroundThemeSaturation())
        
        let mark:CGFloat = CGFloat(Float(row)/Float(cells.count)).clamp01()
        
        switch style.entryBackgroundThemeName
        {
        case "Apple":
            return UIColor(hue:mark.lerp01(0.15,0.35), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Charcoal":
            return row.isEven ? UIColor(white:0.09,alpha:1.0) : UIColor(white:0.13,alpha:1.0)
        case "Cherry":
            return UIColor(hue:mark.lerp01(0.90,0.97), saturation:saturation, brightness:0.9, alpha:1.0)
        case "Grape":
            return UIColor(hue:mark.lerp01(0.75,0.90), saturation:saturation, brightness:mark.lerp01(0.65,0.80), alpha:1.0)
        case "Gray":
            return UIColor(white:0.4,alpha:1.0)
        case "Orange":
            return UIColor(hue:mark.lerp01(0.05,0.11), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Pink":
            return UIColor(hue:mark.lerp01(0.87,0.95), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Plain":
            return UIColor.white
        case "Rainbow":
            return UIColor(hue:mark.lerp01(0.0,0.9), saturation:saturation, brightness:1, alpha:1.0)
        case "Range":
            let color0 = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorFrom).HSBA()
            let color1 = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorTo).HSBA()
            return UIColor(hue:mark.lerp01(color0.hue,color1.hue),
                           saturation:mark.lerp01(color0.saturation,color1.saturation)*saturation,
                           brightness:mark.lerp01(color0.brightness,color1.brightness),
                           alpha:1.0)
        case "Sky":
            return UIColor(hue:mark.lerp01(0.56,0.61), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Solid":
            let HSBA = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeSolidColor).HSBA()
            return UIColor(hue:CGFloat(HSBA.hue), saturation:HSBA.saturation*saturation, brightness:CGFloat(HSBA.brightness), alpha:1.0)
        case "Strawberry":
            return UIColor(hue:mark.lerp01(1.00,0.96), saturation:saturation, brightness:mark.lerp01(1.00,0.87), alpha:1.0)
        default:
            break
        }
        return UIColor.white
    }
    
    func styleIndex(_ view:UIView,number:UInt) -> (label:UIView,fill:UIView?)
    {
        let label = UILabel()
        
        label.font                  = style.entryIndexTextFont
        label.textColor             = style.entryIndexTextFontColor
        label.text                  = String(number)
        label.textAlignment         = .center
        
        label.sizeToFit()
        
        label.frame.size.height     = label.font.ascender
        label.frame.origin.x        = view.frame.size.width/2 - label.frame.size.width/2
        label.frame.origin.y        = view.frame.size.height/2 - label.frame.size.height/2
        
        //        label.backgroundColor       = UIColor.redColor()
        
        var FILL:UIView?
        
        if let font = style.entryIndexBackgroundFont
        {
            let fill = UILabel()
            
            //            fill.backgroundColor       = UIColor.greenColor()
            
            fill.font                   = font
            fill.textColor              = style.entryIndexBackgroundColor
            fill.text                   = "●" // "●"
            fill.textAlignment          = .center
            
            fill.sizeToFit()
            
            fill.frame.origin.x         = view.frame.size.width/2 - fill.frame.size.width/2
            fill.frame.origin.y         = fill.frame.size.height/2 - fabs(font.descender) - fabs(font.leading) - fabs(font.capHeight)/2 //+ 2
            //            fill.frame.origin.y         = floor(fill.frame.size.height/2.0) - fabs(font.descender) - fabs(font.leading) - floor(fabs(font.capHeight)/2.0) // + 2
            
            //            print("height=\(fill.frame.size.height), a=\(font.ascender), c=\(font.capHeight), d=\(font.descender), l=\(font.leading)")
            view.addSubview(fill)
            
            FILL=fill
        }
        
        view.addSubview(label)
        
        return (label,FILL)
    }
    
    
    fileprivate func styleCell(_ cell:UITableViewCell, indexPath:IndexPath)
    {
        cell.selectionStyle = .none
        
        if true
        {
            let color                   = colorForRow(indexPath.row)

            let factor:CGFloat          = 0.3
            
            if indexPath.row.isEven {
                let HSBA                = color.HSBA()
                
                let f                   = 1.0 - style.entryRowOpacity.clamp01()*factor
                
                cell.backgroundColor    = UIColor(hue:HSBA.hue,saturation:HSBA.saturation,brightness:HSBA.brightness*f,alpha:HSBA.alpha)
            }
            else {
                cell.backgroundColor    = color
            }
        }
        
        if let label = cell.textLabel {
//            label.frame.origin.y += 4
            label.font      = style.entryTitleTextFont
            label.textColor = style.entryTitleTextFontColor
            if style.entryTitleTextUppercase {
                label.text  = label.text?.uppercased()
            }
        }
        if let label = cell.detailTextLabel {
//            label.frame.origin.y -= 4
            label.font      = style.entrySubtitleTextFont
            label.textColor = style.entrySubtitleTextFontColor
            if style.entrySubtitleTextUppercase {
                label.text  = label.text?.uppercased()
            }
        }
        
        let view = UIView()
        
        view.frame                  = CGRect(x: 0,y: 0,width: cell.bounds.height,height: cell.bounds.height)
        view.backgroundColor        = UIColor.white.withAlphaComponent(0)

        
        
        let label = UILabel()
        
        label.font                  = style.entryIndexTextFont
        label.textColor             = style.entryIndexTextFontColor
        label.text                  = String(indexPath.row+1)
        label.textAlignment         = .center
        
        label.sizeToFit()
        
        label.frame.size.height     = label.font.ascender
        label.frame.origin.x        = view.frame.size.width/2 - label.frame.size.width/2
        label.frame.origin.y        = view.frame.size.height/2 - label.frame.size.height/2

//        label.backgroundColor       = UIColor.redColor()
        
        if let font = style.entryIndexBackgroundFont
        {
            let fill = UILabel()
            
//            fill.backgroundColor       = UIColor.greenColor()
            
            fill.font                   = font
            fill.textColor              = style.entryIndexBackgroundColor
            fill.text                   = "●" // "●"
            fill.textAlignment          = .center

            fill.sizeToFit()
            
            fill.frame.origin.x         = view.frame.size.width/2 - fill.frame.size.width/2
            fill.frame.origin.y         = fill.frame.size.height/2 - fabs(font.descender) - fabs(font.leading) - fabs(font.capHeight)/2 //+ 2
//            fill.frame.origin.y         = floor(fill.frame.size.height/2.0) - fabs(font.descender) - fabs(font.leading) - floor(fabs(font.capHeight)/2.0) // + 2
            
//            print("height=\(fill.frame.size.height), a=\(font.ascender), c=\(font.capHeight), d=\(font.descender), l=\(font.leading)")
            view.addSubview(fill)
        }

        view.addSubview(label)

        cell.accessoryView          = view
        cell.editingAccessoryView   = view
        
    }
    
    
    override func numberOfSections   (in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cells.count
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var CELL = cells[indexPath.row]
        
        let cell = UITableViewCell(style:.subtitle,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
//            label.text = String(CELL.index) + ". " + (CELL.item["title"].rawString() ?? "")
            label.text = CELL.item["title"].rawString() ?? ""
            CELL.title = label.text ?? ""
        }
        if let label = cell.detailTextLabel {
            if false {
                if let lat = CELL.item["lat"].rawString(), let lon = CELL.item["lon"].rawString() {
                    label.text = lat.trimIfBeyondDigitCount(7).prefixWithPlusIfPositive() + "," + lon.trimIfBeyondDigitCount(7).prefixWithPlusIfPositive()
                }
            }
            if false {
                if let pageid = CELL.item["pageid"].rawString() {
                    if pageid != "null" {
                        if let text = label.text {
                            label.text = pageid + " @ " + text
                        }
                        else {
                            label.text = pageid
                        }
                    }
                }
            }
            if var distance = CELL.item["dist"].rawString() {
//                distance = ">> " + distance + " m"
                distance += " m "
                if let text = label.text {
                    label.text = text + " " + distance
                }
                else {
                    label.text = distance
                }
            }
            if var name = CELL.item["name"].rawString() {
                if !name.empty {
                    name = "\"" + name + "\""
                    if let text = label.text {
                        label.text = text + " " + name
                    }
                    else {
                        label.text = name
                    }
                }
            }
            if let type = CELL.item["type"].rawString() {
                if type != "null" {
                    if let text = label.text {
                        label.text = text + " [" + type.capitalized() + "]"
                    }
                    else {
                        label.text = "[" + type.capitalized() + "]"
                    }
                }
            }

            CELL.subtitle = label.text ?? ""
        }
        
//        cell.accessoryType = .DisclosureIndicator

        
        styleCell(cell,indexPath:indexPath)
        

        return cell
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row

        let cell    = cells[indexPath.row]
        
        let pageid  = cell.item["pageid"].rawString()
        
        if 0 < (pageid?.length)!
        {
            let url = "https://en.wikipedia.org/?curid=" + String(pageid!)
            //            let url = "https://www.amazon.com"
            
            let controller = ControllerOfWebView()
            
            controller.title = cell.item["title"].rawString() ?? ""
            
            self.navigationController?.pushViewController(controller, animated:true)
            
            controller.load(url)
        }
    }
    
    
    
    
    
    
    
    
    
    fileprivate func fetch(_ gscoord:String, gsradius:UInt = 10000, gsmaxdim:UInt = 100000, gslimit:UInt = 15, update:@escaping ([Cell])->())
    {
        let parameters:[Source.Wikipedia.GeoSearchParameter:String] = [
            .gscoord    : gscoord,
            .gsradius   : String(gsradius),
            .gsmaxdim   : String(gsmaxdim),
            .gslimit    : String(gslimit),
            .gsprop     : "type|name|country|region",
            .gsprimary  : "all"
        ]
        
        Source.Wikipedia.get_geosearch(.English,parameters:parameters) { (error,data) in
            if let data=data {
                var cells:[Cell] = []
                
                var index = 1
                for entry in data["query"]["geosearch"] {
                    cells.append(Cell(index:index,indentation:0,item:entry.1,title:"",subtitle:""))
                    index += 1
                }
                
                update(cells)
            }
            if let error=error {
                print("error:\(error)")
            }
        }
    }
    
    
    
    
    func reload()
    {
        selectedIndex = nil
        
        tableView.reloadData()
    }
    
    
    
    
    func refresh()
    {
        // make a call to core location to update coordinates
        // during this time, show activity view
        // once retrieved or error, stop showing activity, reload
        
        refreshControl?.beginRefreshing()
        
        AppDelegate.locationsUpdated = { ok in
            if ok {
                if let location = AppDelegate.locations.first {
                    self.coordinates1 = String(location.coordinate.latitude) + "|" + String(location.coordinate.longitude)
                    print("refresh: updated coordinate1 to \(self.coordinates1) from \(location.coordinate)")
                }
            }
            if true //self.coordinates1 != self.coordinates0
            {
                
                self.coordinates0 = self.coordinates1
                
                var gslimit = Data.Manager.settingsGetGeoSearchMaximumResults(defaultValue:10)

                if gslimit < 10 {
                    gslimit = 10
                }

                self.fetch(self.coordinates1,gslimit:gslimit) { cells in
                    self.cells = cells
                    self.reload()
                    self.refreshControl?.endRefreshing()
                }
            }
            else {
//                self.refreshControl?.endRefreshing()
            }
        }
        
        AppDelegate.updateLocation()
    }
    
    
    
    
}
