//
//  ControllerOfWebView.swift
//  productWikieHere
//
//  Created by Andrzej Semeniuk on 3/23/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ControllerOfWebView : UIViewController
{
    var webview:UIWebView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.white)
    
    
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfWebView")
        

        
        self.webview            = UIWebView()
        
        webview.delegate        = self
        
        webview.scalesPageToFit = true
        
        
        
        activityIndicator.hidesWhenStopped = true
        
        webview.addSubview(activityIndicator)
        


        self.view               = webview
        
        view.contentMode        = .scaleAspectFit
        
        
        
        
        if true
        {
            var items = navigationItem.rightBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(title:"Map", style:.plain, target:self, action: #selector(ControllerOfWebView.openMap)),
            ]
            
            navigationItem.rightBarButtonItems = items
        }

        
        
        
//        view.frame              = self.view.frame
        
        print("frame=\(view.frame)")
        
        super.viewDidLoad()
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func openMap()
    {
        let map = ControllerOfMap()
        
        map.title = "Map"
        
        self.navigationController?.pushViewController(map, animated:true)
    }

    
    
    
    func load(url:String)
    {
        print("ControllerOfWebView: url=\(url)")
        
        if let url = URL(string:url)
        {
            print("frame=\(view.frame)")
            
            let request = URLRequest(url:url)

            webview.loadRequest(request)
        }
    }
    


    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.view?.backgroundColor = Data.Manager.settingsGetBackgroundColor()

        super.viewWillAppear(animated)
    }

    
    
}

extension ControllerOfWebView : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        // specify alpha to make activity indicator view transparent
        activityIndicator.backgroundColor   = UIColor(gray:0.1,alpha:0.35)
        // use the frame of web view to reposition the indicator precisely
        activityIndicator.frame             = webView.frame //activityIndicator.superview?.frame
        // no need to set center if frame is set
        //        activityIndicator.center            = webview.center
        //        activityIndicator.alpha             = 0.33
        activityIndicator.transform         = CGAffineTransform(scaleX: 1.5,y: 1.5)
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError:Error)
    {
        activityIndicator.stopAnimating()
        
        print("webview: did fail load with error: \(didFailLoadWithError)")
    }

}
