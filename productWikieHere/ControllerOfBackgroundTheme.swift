//
//  ControllerOfBackgroundTheme.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfBackgroundTheme : GenericControllerOfSettings
{
    
    override func viewDidLoad()
    {
        tableView               = UITableView(frame:tableView.frame,style:.Grouped)
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .None
        
        self.title              = "Backgrounds"
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        var rows = [[Any]]()
        
        var CATEGORIES = [Any]()
        
        let definePredefinedBackgroundThemeWithName = { (name:String) -> Any in
            return { (cell:UITableViewCell, indexPath:NSIndexPath) in
                if let label = cell.textLabel {
                    cell.selectionStyle = .Default
                    label.text          = name
                    self.addAction(indexPath) {
                        Data.Manager.settingsSetEntryBackgroundThemeWithName(name)
                        self.reload()
                    }
                }
                if Data.Manager.settingsGetEntryBackgroundThemeName() == name {
                    cell.accessoryType = .Checkmark
                }
                else {
                    cell.accessoryType = .None
                }
            }
        }
        
        rows    = []
        
        if 0 < CATEGORIES.count {
            rows.append(CATEGORIES)
        }
        
        rows.append(
            [
                "", //"PREDEFINED THEME SATURATION",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    //                    let slider = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsEntryBackgroundThemeSaturation, defaultValue:0.4), update: { (myslider:UISlider) in
                    //                        Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsEntryBackgroundThemeSaturation)
                    //                    })
                    //                    let W:CGFloat = AppDelegate.rootViewController.view.bounds.width
                    //                    let w:CGFloat = W/2.0
                    //                    cell.frame  = CGRectMake(W/2.0-w,0,w,cell.bounds.height)
                    //                    cell.addSubview(slider)
                    if let label = cell.textLabel {
                        label.text          = "Saturation"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsEntryBackgroundThemeSaturation, defaultValue:0.4), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsEntryBackgroundThemeSaturation)
                        })
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                    }
                },
                
                
                ""
            ])
        
        rows.append(
            [
                "PREDEFINED THEMES",
                
                definePredefinedBackgroundThemeWithName("Apple"),
                definePredefinedBackgroundThemeWithName("Charcoal"),
                definePredefinedBackgroundThemeWithName("Grape"),
                definePredefinedBackgroundThemeWithName("Gray"),
                definePredefinedBackgroundThemeWithName("Orange"),
                definePredefinedBackgroundThemeWithName("Plain"),
                definePredefinedBackgroundThemeWithName("Rainbow"),
                definePredefinedBackgroundThemeWithName("Strawberry"),
                
                ""
            ])
        
        rows.append(
            [
                "DYNAMIC THEMES",
                
                definePredefinedBackgroundThemeWithName("Solid"),
                
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeSolidColor(),name:"  Color",title:"Solid",key:.SettingsEntryBackgroundThemeSolidColor) {
                    //                        self.reload()
                },
                
                definePredefinedBackgroundThemeWithName("Range"),
                
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeRangeFromColor(),name:"  Color From",title:"Range From",key:.SettingsEntryBackgroundThemeRangeFromColor) {
                    //                        self.reload()
                },
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeRangeToColor(),name:"  Color To",title:"Range To",key:.SettingsEntryBackgroundThemeRangeToColor) {
                    //                        self.reload()
                },
                
                ""
            ])
        
        return rows
    }
    
}
