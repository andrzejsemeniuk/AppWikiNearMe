//
//  ControllerOfSettings.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfSettings : GenericControllerOfSettings
{
    
    override func viewDidLoad()
    {
        tableView                   = UITableView(frame:tableView.frame,style:.Grouped)
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        
        tableView.separatorStyle    = .None
        
        self.title                  = "Settings"
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        return [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetLastName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler() {
                                field in
                                // called to configure text field before displayed
                                field.text = Data.Manager.settingsGetLastName()
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.Default, handler: {
                                action in
                                
                                if let fields = alert.textFields, text = fields[0].text {
                                    if 0 < text.length {
                                        Data.Manager.settingsSave(text)
                                        
                                        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())

                                        self.tableView.reloadRowsAtIndexPaths([
                                            indexPath,
                                            NSIndexPath(forRow:indexPath.row+1,inSection:indexPath.section)
                                            ],
                                            withRowAnimation: .Left)
                                    }
                                }
                            })
                            
                            let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
                                action in
                            })
                            
                            alert.addAction(actionSave)
                            alert.addAction(actionCancel)
                            
                            AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
                                print("completed showing add alert")
                            })
                        }
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Load"
                        if Data.Manager.settingsListIsEmpty() {
                            cell.selectionStyle = .None
                            cell.accessoryType  = .None
                        }
                        else {
                            cell.selectionStyle = .Default
                            cell.accessoryType  = .DisclosureIndicator
                        }
                        self.registerCellSelection(indexPath) {
                            let list = Data.Manager.settingsList()
                            
                            print("settings list =\(list)")
                            
                            if 0 < list.count {
                                let controller = GenericControllerOfList()
                                
                                controller.items = Data.Manager.settingsList().sort()
                                controller.handlerForDidSelectRowAtIndexPath = { (controller:GenericControllerOfList,indexPath:NSIndexPath) -> Void in
                                    let selected = controller.items[indexPath.row]
                                    Data.Manager.settingsUse(selected)
                                    AppDelegate.rootViewController.view.backgroundColor = Data.Manager.settingsGetBackgroundColor()
                                    AppDelegate.controllerOfPages.view.backgroundColor  = Data.Manager.settingsGetBackgroundColor()
                                    controller.navigationController!.popViewControllerAnimated(true)
                                }
                                controller.handlerForCommitEditingStyle = { (controller:GenericControllerOfList,commitEditingStyle:UITableViewCellEditingStyle,indexPath:NSIndexPath) -> Bool in
                                    if commitEditingStyle == .Delete {
                                        let selected = controller.items[indexPath.row]
                                        Data.Manager.settingsRemove(selected)
                                        return true
                                    }
                                    return false
                                }
                                
                                self.navigationController?.pushViewController(controller, animated:true)
                            }
                        }
                    }
                },
                
                "Save current settings, or load previously saved settings"
            ],
            
            [
                "WIKIPEDIA SEARCH",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Maximum Results"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsGeoSearchMaximumResults,defaultValue:15),
                            minimum:10,
                            maximum:99,
                            update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsGeoSearchMaximumResults)
                        })
                        cell.selectionStyle = .None
                    }
                },

                ""
            ],
            
//            [
//                "THEME",
//                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.detailTextLabel {
//                        label.text = Data.Manager.settingsGetThemeName()
//                    }
//                    if let label = cell.textLabel {
//                        label.text          = "Theme"
//                        cell.accessoryType  = .DisclosureIndicator
//                        cell.selectionStyle = .Default
//                        self.registerCellSelection(indexPath) {
//                            let controller = GenericControllerOfList()
//                            self.navigationController?.pushViewController(controller, animated:true)
//                        }
//                    }
//                },
//                
//                "Pick a predefined theme and/or tweak settings below",
//            ],
            
            [
                "FILL",
                
                createCellForColor(Data.Manager.settingsGetBackgroundColor(),title:"Color",key:.SettingsBackgroundColor) {
                    AppDelegate.rootViewController.view.backgroundColor = Data.Manager.settingsGetBackgroundColor()
                    AppDelegate.controllerOfPages.view.backgroundColor  = Data.Manager.settingsGetBackgroundColor()
//                    self.tableView.backgroundColor = AppDelegate.rootViewController.view.backgroundColor
                },
                
                ""
            ],
            
            [
                "ROW",
            
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetEntryBackgroundThemeName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Background Theme"
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let controller = ControllerOfBackgroundTheme()
                            self.navigationController?.pushViewController(controller, animated:true)
                        }
                    }
                },
                
//                createCellForColor(Data.Manager.settingsGetEntrySelectionColor(),title:"Selection",key:.SettingsEntrySelectionColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Opacity"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsEntryRowOpacity, defaultValue:0.8), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsEntryRowOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                

                ""
            ],
            
            
            [
                "TITLE TEXT",
                
                createCellForFont(Data.Manager.settingsGetEntryTitleTextFont(),title:"Title",key:.SettingsEntryTitleTextFontName),
                
                createCellForColor(Data.Manager.settingsGetEntryTitleTextFontColor(),title:"Title",key:.SettingsEntryTitleTextFontColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsEntryTitleTextUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsEntryTitleTextUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsEntryTitleTextEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsEntryTitleTextEmphasize)
                        })
                    }
                },
                
                
                ""
            ],
            
            [
                "SUBTITLE TEXT",
                
                createCellForFont(Data.Manager.settingsGetEntrySubtitleTextFont(),title:"Title",key:.SettingsEntrySubtitleTextFontName),
                
                createCellForColor(Data.Manager.settingsGetEntrySubtitleTextFontColor(),title:"Title",key:.SettingsEntrySubtitleTextFontColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsEntrySubtitleTextUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsEntrySubtitleTextUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsEntrySubtitleTextEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsEntrySubtitleTextEmphasize)
                        })
                    }
                },
                
                
                ""
            ],
            
            [
                "INDEX TEXT",
                
                createCellForFont(Data.Manager.settingsGetEntryIndexTextFont(),title:"Index",key:.SettingsEntryIndexTextFontName),
                
                createCellForColor(Data.Manager.settingsGetEntryIndexTextFontColor(),title:"Index",key:.SettingsEntryIndexTextFontColor),
                
                createCellForColor(Data.Manager.settingsGetEntryIndexBackgroundColor(),name:"Background",title:"Background",key:.SettingsEntryIndexBackgroundColor),
                
                ""
            ],
            
            
            //            [
            //                "ITEM QUANTITY SOUNDS",
            //
            //                { (cell:UITableViewCell, indexPath:NSIndexPath) in
            //                    if let label = cell.textLabel {
            //                        label.text          = "Add"
            //                        cell.selectionStyle = .Default
            //                        cell.accessoryType  = .DisclosureIndicator
            //                        self.registerCellSelection(indexPath) {
            //                            // None,Default,Zap,Pop,Crackle
            //                        }
            //                    }
            //                },
            //
            //                { (cell:UITableViewCell, indexPath:NSIndexPath) in
            //                    if let label = cell.textLabel {
            //                        label.text          = "Subtract"
            //                        cell.selectionStyle = .Default
            //                        cell.accessoryType  = .DisclosureIndicator
            //                        self.registerCellSelection(indexPath) {
            //                        }
            //                    }
            //                },
            //                
            //                { (cell:UITableViewCell, indexPath:NSIndexPath) in
            //                    if let label = cell.textLabel {
            //                        label.text          = "Error"
            //                        cell.selectionStyle = .Default
            //                        cell.accessoryType  = .DisclosureIndicator
            //                        self.registerCellSelection(indexPath) {
            //                        }
            //                    }
            //                },
            //                
            //
            //                ""
            //            ],
            
        ]
    }
    
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        Data.Manager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool)
    {
//        tableView.backgroundColor = AppDelegate.rootViewController.view.backgroundColor
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()

        super.viewWillAppear(animated)
    }

    
    
    
}
