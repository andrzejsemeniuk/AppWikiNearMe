//
//  ControllerOfMap.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SwiftyJSON

class ControllerOfMap : UIViewController, MKMapViewDelegate
{
    var map     :MKMapView!
    var here    :MKUserTrackingBarButtonItem!
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfMap")
        

        map = MKMapView()
        
        map.delegate                = self
        
        map.mapType                 = .standard
        
        map.isZoomEnabled           = true
        map.isScrollEnabled         = true
        map.isPitchEnabled          = false
        map.isRotateEnabled         = true
        
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
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("map view: view will appear")
        
        // 1 remove any previously created annotations
        
        for annotation in annotations {
            map.removeAnnotation(annotation.1.annotation)
        }
        
        annotations                         = [:]
        indexOfAnnotation                   = [:]
        
        // 2 add annotations from list
        
        var index = 1
        
        var annotationsToShow:[MKAnnotation] = []
        
        for cell in AppDelegate.controllerOfList.cells {
            if let lat = cell.item["lat"].number, let lon = cell.item["lon"].number {
                let location                = CLLocation(latitude:lat.doubleValue,longitude:lon.doubleValue)
                var title                   = "" //String(index)
                if let t = cell.item["title"].string {
//                    title += ". " + t
                    title = t
                }
                var subtitle                = ""
                if let s = cell.item["dist"].number {
                    subtitle = String(describing: s) + " m"
                }
                let annotation              = Annotation(coordinate:location.coordinate, title:title, subtitle:subtitle)
                annotations[index]          = AnnotationEntry(index:index,location:location,item:cell.item,annotation:annotation)
                indexOfAnnotation[title]    = UInt(index)
                annotationsToShow.append(annotation)
            }
            index += 1
        }
        
        self.map.addAnnotations(annotationsToShow)
        // adding is not showing
        self.map.showAnnotations(annotationsToShow, animated:true)
        
        // 3 select annotation is a selection has been made on the list page
        if let selectedIndex = AppDelegate.controllerOfList.selectedIndex, let annotation = self.annotations[1+selectedIndex] {
            self.map.selectAnnotation(annotation.annotation, animated:true)
        }
        
        super.viewWillAppear(animated)
    }
    
    
    // this method creates a view for each annotation on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
//        print("annotation: title \(annotation.title), subtitle \(annotation.subtitle)")
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let view = MKPinAnnotationView(annotation:annotation,reuseIdentifier:nil)
        
        view.canShowCallout = true
        
        if let detail=view.leftCalloutAccessoryView {
//            detail.backgroundColor = UIColor.redColor()
        }
        
//        view.image=nil
//        view.bounds.size = CGSizeMake(120,120)
//        view.frame.size = CGSizeMake(120,120)
        
        if let title = annotation.title, let utitle = title, let index = indexOfAnnotation[utitle] {
            let (label,fill) = AppDelegate.controllerOfList.styleIndex(view,number:index)
            let divisor:CGFloat = 4
            if let width=fill?.frame.size.width {
                label.frame.origin.x -= width/divisor
                fill?.frame.origin.x -= width/divisor
            }
            if let height=fill?.frame.size.height {
                label.frame.origin.y -= height/divisor
                fill?.frame.origin.y -= height/divisor
            }
        }
        else {
//            AppDelegate.controllerOfList.styleIndex(view,number:0)
        }
        
        return view
    }

    
}
