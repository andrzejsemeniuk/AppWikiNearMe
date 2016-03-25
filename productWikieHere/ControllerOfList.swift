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
        
        //        test1TypicalGeosearch1("30.25|-97.75")
        
        super.refreshControl = UIRefreshControl()
        
        super.refreshControl?.addTarget(self,action:#selector(ControllerOfList.refresh),forControlEvents:.ValueChanged)
        
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
    
    
    
    
    
    
    private var fontInLabel:UIFont  = UIFont(name:"Futura",size:UIFont.labelFontSize())!
    private var fontInDetail:UIFont = UIFont(name:"Futura",size:UIFont.labelFontSize())!
    
    
    
    
    
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
            label.font = fontInLabel.fontWithSize(label.font.pointSize-1)
            CELL.title = label.text ?? ""
        }
        if let label = cell.detailTextLabel {
            label.font = fontInDetail.fontWithSize(label.font.pointSize)
            label.textColor = UIColor.grayColor()
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
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        selectedIndex = nil
        
        super.viewWillAppear(animated)
    }
    
    
    
    
    private func fetch(gscoord:String, gsradius:UInt = 1000, gsmaxdim:UInt = 1000, gslimit:UInt = 15, update:([Cell])->())
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
