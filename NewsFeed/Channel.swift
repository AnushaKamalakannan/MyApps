//
//  Channel.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import Foundation
// Channel Structure for view
struct channel {
    
    var id : String?
    var name : String?
    var descriptionChannel:String?
    var url :String?
    var language = ""
    var country = ""
    var availableSorting = [String]()
    var category = ""
    
// Subscript Implementataion
    subscript(name : String?)->String{
                return "ChannelName : \(name ?? "" )\nLanguage : \(language )\nCountry : \(country)\nCategory : \(category)"
    }
    
    
    
}
