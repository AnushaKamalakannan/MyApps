//
//  WebSer vice.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import Foundation

class   WebService{

// get data from API's
 //MARK: impl of class function
class func getFromWeb(_ url : String, completion : ((NSDictionary?)->())?){
    
    guard let getUrl = URL(string: url) else {
        return
    }
    
    URLSession.shared.dataTask(with: getUrl, completionHandler: { (data, response, error) in
        
        // error validation
        guard error == nil else {
            print(error?.localizedDescription ?? "nil")
            return
        }
        
        if let data = data {
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if completion != nil
                {
                    completion!(json)
                }
                else
                {
                    if channelListDelegateObj != nil {
                        channelListDelegateObj?.getChannelList(json)
                    }
                }
                
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
    }).resume()
  }

}
