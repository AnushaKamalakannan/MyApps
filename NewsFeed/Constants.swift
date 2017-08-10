//
//  Constants.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import Foundation


// Api list

let getChannelListUrl = "https://newsapi.org/v1/sources"



// cell Id

struct cellIds {
    
    static let list = cellIds()
    
    let mainPage = "cellId"
    
    
}

// Web Api constants


struct  web {
    
    static let constants = web()
    
    let category = "category"
    let country = "country"
    let description = "description"
    let id = "id"
    let language = "language"
    let name = "name"
    let sortBysAvailable = "sortBysAvailable"
    let url = "url"
    let sources = "sources"
}


// view controller Ids

struct viewController {
    
    static let ids = viewController()
    
    let webViewController = "webViewControllerId"
    
}

// protocol Objs

var channelListDelegateObj : channelListDelegate? = nil


// enum for filter button clicked

enum filterType {
    
    case language, category, country, all
    
}






