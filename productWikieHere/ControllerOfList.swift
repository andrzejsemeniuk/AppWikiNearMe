//
//  ControllerOfList.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ControllerOfList : UITableViewController
{
    struct Cell
    {
        var indentation:        UInt            = 0
        var item:               Data.Item
    }
    
    var cells:[Cell] = []
    
    
    override func viewDidLoad()
    {
        test1TypicalGeosearch1("30.25|-97.75")
        
        super.viewDidLoad()
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
        let CELL = cells[indexPath.row]
        
        let cell = UITableViewCell(style:.Subtitle,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = CELL.item["title"].rawString()
            label.font = fontInLabel.fontWithSize(label.font.pointSize-1)
        }
        if let label = cell.detailTextLabel {
            label.font = fontInDetail.fontWithSize(label.font.pointSize)
            label.textColor = UIColor.grayColor()
            if let lat = CELL.item["lat"].rawString(), let lon = CELL.item["lon"].rawString() {
                label.text = lat.trimIfBeyondDigitCount(7).prefixWithPlusIfPositive() + "," + lon.trimIfBeyondDigitCount(7).prefixWithPlusIfPositive()
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
            if let name = CELL.item["name"].rawString() {
                if !name.empty {
                    if let text = label.text {
                        label.text = name + " @ " + text
                    }
                    else {
                        label.text = name
                    }
                }
            }
        }
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
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

    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    
    
    
    func test1TypicalGeosearch1(gscoord:String = "30.25|-97.75")
    {
        do
        {
            let parameters:[Source.Wikipedia.GeoSearchParameter:String] = [
                .gscoord    : gscoord,
                .gsradius   : "10000",
                .gsmaxdim   : "10000",
                .gslimit    : "15",
                .gsprop     : "type|name|country|region",
                .gsprimary  : "all"
            ]
            
            Source.Wikipedia.get_geosearch(language:.English,parameters:parameters) { (error,data) in
                if let d=data {
                    print("ok")
                    print(d)
                    
                    // format: query:geosearch:[item]
                    
                    var cells:[Cell] = []
                    
                    for entry in d["query"]["geosearch"] {
                        print("entry=\(entry)") // entry= {"0",{...}}
                        
                        let item:Data.Item = entry.1
                        
                        print ("item=\(item)")
                        
                        cells.append(Cell(indentation:0,item:item))
                    }
                    
                    self.cells = cells
                    self.reload()
                }
                if let e=error {
                    print("error:\(e)")
                }
            }
            
            
        }
        
    }
    
}
