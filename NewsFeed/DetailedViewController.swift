//
//  DetailedViewController.swift
//  NewsFeed
//
//  Created by Anusha on 6/30/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    let  filterArray = ["Language","Category","Country", "All"] as [String]
    
    let FilterDictionary = ["Language":["en","fr","de"],"Category":["general","politics"],"country":["us","aus"]]
    
    @IBOutlet weak var tableViews: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableCell
        cell.labelField.text = filterArray[indexPath.row]
       return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected Values:\(String(describing: FilterDictionary[filterArray[indexPath.row]]))")
    }
    
}


class FilterTableCell: UITableViewCell{
    
    @IBOutlet weak var labelField: UILabel!
    
}
