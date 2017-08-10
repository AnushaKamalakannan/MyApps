//
//  MainPageCellTableViewCell.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import UIKit

// custom class for main page table view cell

class mainPageCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var descriptionChannel: UILabel!
    @IBOutlet var webViewClickButton : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            }
    
    
  //MARK: impl of Delegates & Protocols
    func setCellData(_ channelObj : channel){
        
        self.title.text = channelObj.name
        self.descriptionChannel.text = channelObj.descriptionChannel
        
    }
    
}
