//
//  ControllerOfWebView.swift
//  productWikieHere
//
//  Created by Andrzej Semeniuk on 3/23/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfWebView : UIViewController, UIWebViewDelegate
{
    var webview:UIWebView!
    
    override func viewDidLoad()
    {
        print("viewDidLoad: ControllerOfWebView")
        

        
        self.webview            = UIWebView()
        
        webview.delegate        = self
        
        webview.scalesPageToFit = true
        

        self.view               = webview
        
        view.backgroundColor    = UIColor.redColor()
        
        view.contentMode        = .ScaleAspectFit
        
        
//        view.frame              = self.view.frame
        
        print("frame=\(view.frame)")
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    func load(url:String)
    {
        print("ControllerOfWebView: url=\(url)")
        
        if let nsurl = NSURL(string:url)
        {
            print("frame=\(view.frame)")
            
            let nsurlrequest = NSURLRequest(URL:nsurl)
            
            webview.loadRequest(nsurlrequest)
        }
    }
    
    
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        print("webview: did start load")
    }
    
    func webViewDidFinishtLoad(webView: UIWebView)
    {
        print("webview: did finish load")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError:NSError?)
    {
        print("webview: did fail load with error: \(didFailLoadWithError)")
    }
    

    
}