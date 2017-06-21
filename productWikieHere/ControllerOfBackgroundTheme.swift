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
        tableView                   = UITableView(frame:tableView.frame,style:.grouped)
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.separatorStyle    = .none
        
        self.title                  = "Backgrounds"
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        var rows = [[Any]]()
        
        let definePredefinedBackgroundThemeWithName = { (name:String) -> Any in
            return { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    cell.selectionStyle = .default
                    label.text          = name
                    self.addAction(indexPath: indexPath) {
                        Data.Manager.settingsSetEntryBackgroundThemeWithName(name)
                        self.reload()
                    }
                }
                if Data.Manager.settingsGetEntryBackgroundThemeName() == name {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
            }
        }
        
        rows    = [
            
            [
                "", //"PREDEFINED THEME SATURATION",
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Saturation"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsEntryBackgroundThemeSaturation, defaultValue:0.4), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsEntryBackgroundThemeSaturation)
                        })
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                    }
                },
                
                
                ""
            ],
            
            [
                "PREDEFINED THEMES",
                
                definePredefinedBackgroundThemeWithName("Apple"),
                definePredefinedBackgroundThemeWithName("Charcoal"),
                definePredefinedBackgroundThemeWithName("Cherry"),
                definePredefinedBackgroundThemeWithName("Grape"),
                definePredefinedBackgroundThemeWithName("Gray"),
                definePredefinedBackgroundThemeWithName("Orange"),
                definePredefinedBackgroundThemeWithName("Plain"),
                definePredefinedBackgroundThemeWithName("Pink"),
                definePredefinedBackgroundThemeWithName("Rainbow"),
                definePredefinedBackgroundThemeWithName("Sky"),
                definePredefinedBackgroundThemeWithName("Strawberry"),
                
                ""
            ],
            
            [
                "DYNAMIC THEMES",
                
                definePredefinedBackgroundThemeWithName("Solid"),
                
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeSolidColor(),name:"  Color",title:"Solid",key:.SettingsEntryBackgroundThemeSolidColor) {
                    //                        self.reload()
                },
                
                definePredefinedBackgroundThemeWithName("Range"),
                
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeRangeColorFrom(),name:"  Color From",title:"Range From",key:.SettingsEntryBackgroundThemeRangeColorFrom) {
                    //                        self.reload()
                },
                createCellForColor(Data.Manager.settingsGetEntryBackgroundThemeRangeColorTo(),name:"  Color To",title:"Range To",key:.SettingsEntryBackgroundThemeRangeColorTo) {
                    //                        self.reload()
                },
                
                ""
            ],
        ]
        
        return rows
    }
    
}
