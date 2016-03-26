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
        
        super.title = "Wiki Near Me"
        
        
        tableView.separatorStyle = .None // UITableViewCellSeparatorStyle
        
        do
        {
            super.refreshControl = UIRefreshControl()
            
            super.refreshControl?.addTarget(self,action:#selector(ControllerOfList.refresh),forControlEvents:.ValueChanged)
        }
        
        
        if true
        {
            var items = navigationItem.rightBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(title:"Settings", style:.Plain, target:self, action: #selector(ControllerOfList.openSettings)),
            ]
            
            navigationItem.rightBarButtonItems = items
        }

        
        super.viewDidLoad()
        
        
        AppDelegate.authorizationStatusUpdated = {
            // TODO
            //            reload()
            var status:String = ""
            
            switch CLLocationManager.authorizationStatus() {
                case .Denied:               status = "Denied"
                case .NotDetermined:        status = "Not Determined"
                case .Restricted:           status = "Restricted"
                case .AuthorizedAlways:     status = "Authorized Always"
                case .AuthorizedWhenInUse:  status = "Authorized When In Use"
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
    
    
    
    
    
    struct Style
    {
        var entryTitleTextFont:                 UIFont                      = Data.Manager.settingsGetEntryTitleTextFont()
        var entryTitleTextFontColor:            UIColor                     = Data.Manager.settingsGetEntryTitleTextFontColor()
        var entryTitleTextUppercase:            Bool                        = Data.Manager.settingsGetEntryTitleTextUppercase()
        var entrySubtitleTextFont:              UIFont                      = Data.Manager.settingsGetEntrySubtitleTextFont()
        var entrySubtitleTextFontColor:         UIColor                     = Data.Manager.settingsGetEntrySubtitleTextFontColor()
        var entrySubtitleTextUppercase:         Bool                        = Data.Manager.settingsGetEntrySubtitleTextUppercase()
        var entryRowEvenOpacity:                CGFloat                     = CGFloat(Data.Manager.settingsGetEntryRowEvenOpacity()).clamp01()
        var entryRowOddOpacity:                 CGFloat                     = CGFloat(Data.Manager.settingsGetEntryRowOddOpacity()).clamp01()
        var entryBackgroundThemeName:           String                      = Data.Manager.settingsGetEntryBackgroundThemeName()
        var entryBackgroundThemeColorFrom:      UIColor                     = Data.Manager.settingsGetEntryBackgroundThemeRangeColorFrom()
        var entryBackgroundThemeColorTo:        UIColor                     = Data.Manager.settingsGetEntryBackgroundThemeRangeColorTo()
        var entryIndexTextFont:                 UIFont                      = Data.Manager.settingsGetEntryIndexTextFont()
        var entryIndexTextFontColor:            UIColor                     = Data.Manager.settingsGetEntryIndexTextFontColor()
        var entryIndexBackgroundColor:          UIColor                     = Data.Manager.settingsGetEntryIndexBackgroundColor()
        var entryIndexBackgroundFont:           UIFont?                     = UIFont(name:"AppleSDGothicNeo-Medium",size:UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize+26)
    }
    
    private var style = Style()
    

    
    
    override func viewWillAppear(animated: Bool)
    {
        selectedIndex = nil
        
        style = Style()
        
        reload()
        
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()
        
        super.viewWillAppear(animated)
    }
    
    
    private func colorForRow(row:Int) -> UIColor
    {
        let saturation = CGFloat(Data.Manager.settingsGetEntryBackgroundThemeSaturation())
        
        let mark:CGFloat = CGFloat(Float(row)/Float(cells.count)).clamp01()
        
        switch style.entryBackgroundThemeName
        {
        case "Apple":
            return UIColor(hue:mark.lerp01(0.15,0.35), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Charcoal":
            return row.isEven ? UIColor(white:0.09,alpha:1.0) : UIColor(white:0.13,alpha:1.0)
        case "Grape":
            return UIColor(hue:mark.lerp01(0.75,0.90), saturation:saturation, brightness:mark.lerp01(0.65,0.80), alpha:1.0)
        case "Gray":
            return UIColor(white:0.4,alpha:1.0)
        case "Orange":
            return UIColor(hue:mark.lerp01(0.05,0.11), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Plain":
            return UIColor.whiteColor()
        case "Rainbow":
            return UIColor(hue:mark.lerp01(0.0,0.9), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Range":
            let hue0 = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorFrom).HSBA().hue
            let hue1 = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeRangeColorTo).HSBA().hue
            return UIColor(hue:mark.lerp01(hue0,hue1), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Strawberry":
            return UIColor(hue:mark.lerp01(0.89,0.99), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Solid":
            let HSBA = Data.Manager.settingsGetColorForKey(.SettingsEntryBackgroundThemeSolidColor).HSBA()
            return UIColor(hue:CGFloat(HSBA.hue), saturation:saturation, brightness:CGFloat(HSBA.brightness), alpha:1.0)
        default:
            break
        }
        return UIColor.whiteColor()
    }
    
    func styleIndex(view:UIView,number:UInt)
    {
        let label = UILabel()
        
        label.font                  = style.entryIndexTextFont
        label.textColor             = style.entryIndexTextFontColor
        label.text                  = String(number)
        label.textAlignment         = .Center
        
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
            fill.textAlignment          = .Center
            
            fill.sizeToFit()
            
            fill.frame.origin.x         = view.frame.size.width/2 - fill.frame.size.width/2
            fill.frame.origin.y         = fill.frame.size.height/2 - fabs(font.descender) - fabs(font.leading) - fabs(font.capHeight)/2 + 2
            //            fill.frame.origin.y         = floor(fill.frame.size.height/2.0) - fabs(font.descender) - fabs(font.leading) - floor(fabs(font.capHeight)/2.0) // + 2
            
            //            print("height=\(fill.frame.size.height), a=\(font.ascender), c=\(font.capHeight), d=\(font.descender), l=\(font.leading)")
            view.addSubview(fill)
        }
        
        view.addSubview(label)
    }
    
    
    private func styleCell(cell:UITableViewCell, indexPath:NSIndexPath)
    {
        cell.selectionStyle = .None
        
//        cell.selectedBackgroundView = nil
        
//        if let selected = selectedIndex {
//            if selected==indexPath.row {
//                cell.selectedBackgroundView = UIView()
//                cell.selectedBackgroundView?.backgroundColor = Data.Manager.settingsGetEntrySelectionColor()
//            }
//        }
        
        if true //cell.selectedBackgroundView == nil
        {
            let color                   = colorForRow(indexPath.row)

            cell.backgroundColor        = color
            
            let factor:CGFloat          = 0.4
            
            if indexPath.row.isEven {
//                cell.backgroundColor    = color.colorWithAlphaComponent(CGFloat(1.0-style.entryRowEvenOpacity*factor))
                let HSBA = color.HSBA()
                
                let f                   = 1.0-factor+style.entryRowEvenOpacity*factor
                
                cell.backgroundColor    = UIColor(hue:HSBA.hue,saturation:HSBA.saturation,brightness:HSBA.brightness*f)
            }
        }
        
        if let label = cell.textLabel {
            label.font      = style.entryTitleTextFont
            label.textColor = style.entryTitleTextFontColor
            if style.entryTitleTextUppercase {
                label.text  = label.text?.uppercaseString
            }
        }
        if let label = cell.detailTextLabel {
            label.font      = style.entrySubtitleTextFont
            label.textColor = style.entrySubtitleTextFontColor
            if style.entrySubtitleTextUppercase {
                label.text  = label.text?.uppercaseString
            }
        }
        
        let view = UIView()
        
        view.frame                  = CGRectMake(0,0,cell.bounds.height,cell.bounds.height)
        view.backgroundColor        = UIColor.whiteColor().colorWithAlphaComponent(0)

        
        
        let label = UILabel()
        
        label.font                  = style.entryIndexTextFont
        label.textColor             = style.entryIndexTextFontColor
        label.text                  = String(indexPath.row+1)
        label.textAlignment         = .Center
        
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
            fill.textAlignment          = .Center

            fill.sizeToFit()
            
            fill.frame.origin.x         = view.frame.size.width/2 - fill.frame.size.width/2
            fill.frame.origin.y         = fill.frame.size.height/2 - fabs(font.descender) - fabs(font.leading) - fabs(font.capHeight)/2 + 2
//            fill.frame.origin.y         = floor(fill.frame.size.height/2.0) - fabs(font.descender) - fabs(font.leading) - floor(fabs(font.capHeight)/2.0) // + 2
            
//            print("height=\(fill.frame.size.height), a=\(font.ascender), c=\(font.capHeight), d=\(font.descender), l=\(font.leading)")
            view.addSubview(fill)
        }

        view.addSubview(label)

        cell.accessoryView          = view
        cell.editingAccessoryView   = view
        
    }
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cells.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var CELL = cells[indexPath.row]
        
        let cell = UITableViewCell(style:.Subtitle,reuseIdentifier:nil)
        
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
                        label.text = text + " [" + type.capitalizedString + "]"
                    }
                    else {
                        label.text = "[" + type.capitalizedString + "]"
                    }
                }
            }

            CELL.subtitle = label.text ?? ""
        }
        
//        cell.accessoryType = .DisclosureIndicator

        
        styleCell(cell,indexPath:indexPath)
        

        return cell
    }
    
    
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndex = indexPath.row

        let cell    = cells[indexPath.row]
        
        let pageid  = cell.item["pageid"].rawString()
        
        if 0 < pageid?.length
        {
            let url = "https://en.wikipedia.org/?curid=" + String(pageid!)
            //            let url = "https://www.amazon.com"
            
            let controller = ControllerOfWebView()
            
            controller.title = cell.item["title"].rawString() ?? ""
            
            self.navigationController?.pushViewController(controller, animated:true)
            
            controller.load(url)
        }
    }
    
    
    
    
    
    
    
    
    
    private func fetch(gscoord:String, gsradius:UInt = 10000, gsmaxdim:UInt = 100000, gslimit:UInt = 15, update:([Cell])->())
    {
        let parameters:[Source.Wikipedia.GeoSearchParameter:String] = [
            .gscoord    : gscoord,
            .gsradius   : String(gsradius),
            .gsmaxdim   : String(gsmaxdim),
            .gslimit    : String(gslimit),
            .gsprop     : "type|name|country|region",
            .gsprimary  : "all"
        ]
        
        Source.Wikipedia.get_geosearch(language:.English,parameters:parameters) { (error,data) in
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
