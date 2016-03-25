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
        
        
        do
        {
            super.refreshControl = UIRefreshControl()
            
            super.refreshControl?.addTarget(self,action:#selector(ControllerOfList.refresh),forControlEvents:.ValueChanged)
        }
        
        
        do
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
        
        self.navigationController?.pushViewController(settings, animated:true)
    }
    
    
    
    
    
    struct Style
    {
        var entryTitleTextFont:                 UIFont                      = Data.Manager.defaultFont
        var entryTitleTextFontColor:            UIColor                     = UIColor.blackColor()
        var entryTitleTextUppercase:            Bool                        = false
        var entrySubtitleTextFont:              UIFont                      = Data.Manager.defaultFont
        var entrySubtitleTextFontColor:         UIColor                     = UIColor.blackColor()
        var entrySubtitleTextUppercase:         Bool                        = false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        selectedIndex = nil
        
        style.entryTitleTextFont            = Data.Manager.settingsGetEntryTitleTextFont()
        style.entryTitleTextFontColor       = Data.Manager.settingsGetEntryTitleTextFontColor()
        style.entryTitleTextUppercase       = Data.Manager.settingsGetEntryTitleTextUppercase()

        style.entrySubtitleTextFont         = Data.Manager.settingsGetEntrySubtitleTextFont()
        style.entrySubtitleTextFontColor    = Data.Manager.settingsGetEntrySubtitleTextFontColor()
        style.entrySubtitleTextUppercase    = Data.Manager.settingsGetEntrySubtitleTextUppercase()

        reload()
        
        super.viewWillAppear(animated)
    }
    

    
    private var style               = Style()
    
    
    
    
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
            label.text = String(CELL.index) + ". " + (CELL.item["title"].rawString() ?? "")
            label.font = style.entryTitleTextFont
            label.textColor = style.entryTitleTextFontColor
            CELL.title = label.text ?? ""
            if style.entryTitleTextUppercase {
                label.text = label.text?.uppercaseString
            }
        }
        if let label = cell.detailTextLabel {
            label.font = style.entrySubtitleTextFont
            label.textColor = style.entrySubtitleTextFontColor
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

            if style.entrySubtitleTextUppercase {
                label.text = label.text?.uppercaseString
            }

            CELL.subtitle = label.text ?? ""
        }
        
        cell.accessoryType = .DisclosureIndicator
        
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
            if self.coordinates1 != self.coordinates0 {
                
                self.coordinates0 = self.coordinates1
                
                self.fetch(self.coordinates1) { cells in
                    self.cells = cells
                    self.reload()
                    self.refreshControl?.endRefreshing()
                }
            }
            else {
                self.refreshControl?.endRefreshing()
            }
        }
        
        AppDelegate.updateLocation()
    }
    
    
    
    
}
