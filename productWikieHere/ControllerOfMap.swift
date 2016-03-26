//
//  ControllerOfMap.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SwiftyJSON

class ControllerOfMap : UINavigationController, MKMapViewDelegate
{
    var map     :MKMapView!
    var here    :MKUserTrackingBarButtonItem!
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfMap")
        

        map = MKMapView()
        
        map.delegate                = self
        
        map.mapType                 = .Standard
        map.zoomEnabled             = true
        map.scrollEnabled           = true
        map.pitchEnabled            = false
        map.rotateEnabled           = true
        
        map.showsPointsOfInterest   = true
        map.showsBuildings          = true
        map.showsCompass            = true
//        map.showsZoomControls       = true
        map.showsScale              = true
        map.showsTraffic            = false
        
        map.showsUserLocation       = true
        
        
        
        super.view = map

        
        
//        self.here = MKUserTrackingBarButtonItem(mapView:self.map)
//        
////        self.setNavigationBarHidden(false,animated:true)
//        
////        self.navigationBar.topItem?.setRightBarButtonItem(here,animated:true)
////        self.navigationItem.rightBarButtonItem = here
//        
//        
//        var toolbar = UIToolbar()
//        
//        // TODO SET-UP LAYOUT CONSTRAINT
//        
//        toolbar.frame = CGRectMake(0,200,0,0)
//        
//        toolbar.setItems([here],animated:true)
//        
//        self.view.addSubview(toolbar)
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    
    
    
    class Annotation : NSObject, MKAnnotation
    {
        var _title:     String?
        var _subtitle:  String?
        var _coordinate:CLLocationCoordinate2D
        
        var title: String? {
            get {
                return _title
            }
        }
        var subtitle: String? {
            get {
                return _subtitle
            }
        }
        
        var coordinate: CLLocationCoordinate2D {
            get {
                return _coordinate
            }
        }
        
        init(coordinate:CLLocationCoordinate2D, title:String? = nil, subtitle:String? = nil)
        {
            self._title         = title
            self._subtitle      = subtitle
            self._coordinate    = coordinate
        }
    }
    
    struct AnnotationEntry
    {
        let index:              Int
        let location:           CLLocation
        let item:               JSON //Data.Item
        let annotation:         ControllerOfMap.Annotation
    }
    
    var annotations:[Int:AnnotationEntry] = [:]
    var indexOfAnnotation:[String:UInt] = [:]
    
    
    override func viewWillAppear(animated: Bool)
    {
        print("map view: view will appear")
        
        for annotation in annotations {
            map.removeAnnotation(annotation.1.annotation)
        }
        
        annotations = [:]
        indexOfAnnotation = [:]
            
        var index = 0
        
        var annotationsToShow:[MKAnnotation] = []
        
        for cell in AppDelegate.controllerOfList.cells {
            if let lat = cell.item["lat"].number, let lon = cell.item["lon"].number {
                let location            = CLLocation(latitude:lat.doubleValue,longitude:lon.doubleValue)
                var title               = String(index+1)
                if let t = cell.item["title"].string {
//                    title += ". " + t
                    title = t
                }
                var subtitle            = ""
                if let s = cell.item["dist"].number {
                    subtitle = String(s) + " m"
                }
                let annotation          = Annotation(coordinate:location.coordinate, title:title, subtitle:subtitle)
                annotations[index]      = AnnotationEntry(index:index,location:location,item:cell.item,annotation:annotation)
                indexOfAnnotation[title] = UInt(index)
                annotationsToShow.append(annotation)
            }
            index += 1
        }
        
//        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(annotationsToShow)
            self.map.showAnnotations(annotationsToShow,animated:true)
        
            if let selectedIndex = AppDelegate.controllerOfList.selectedIndex, let annotation = self.annotations[selectedIndex] {
                self.map.selectAnnotation(annotation.annotation, animated:true)
            }
//        })
        
        super.viewWillAppear(animated)
    }
    
    
//    func viewForAnnotation(annotation: MKAnnotation) -> MKAnnotationView?
    func mapViewLater(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let view = MKAnnotationView(annotation:annotation,reuseIdentifier:nil)
        
        view.image=nil
//        view.bounds.size = CGSizeMake(120,120)
//        view.frame.size = CGSizeMake(120,120)
        
        if let title = annotation.title, let utitle = title, let index = indexOfAnnotation[utitle] {
            AppDelegate.controllerOfList.styleIndex(view,number:index)
        }
        else {
            AppDelegate.controllerOfList.styleIndex(view,number:0)
        }
        
        return view
    }

    
}