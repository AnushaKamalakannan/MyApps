//
//  WebViewController.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    
    
    @IBOutlet var webView : UIWebView!
    var urlRequest : URLRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        if urlRequest != nil {
            self.webView.loadRequest(urlRequest!)
        }
    }        
}
