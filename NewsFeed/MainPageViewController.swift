//
//  MainPageViewController.swift
//  NewsFeed
//
//  Created by Anusha on 6/29/17.
//  Copyright © 2017 Prokarma. All rights reserved.
//

import UIKit

class mainPageViewController: UIViewController {
    
    //MARK: - variables
    fileprivate var channelArray = [channel]()
    fileprivate var allChannelArray = [channel]()
    
    
    @IBOutlet weak var tableViewChannel : UITableView!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterButtonView: UIView!
    
    
    //MARK: Implementataion of typealias
    typealias uniqueArray = Set<String>
    
    //MARK: Implementation of fileprivate
   fileprivate var languageArray = uniqueArray()
   fileprivate var countryArray = uniqueArray()
   fileprivate var categoryArray = uniqueArray()
    
   fileprivate var filterArrayCopy : ((filterType,Int)->())? = nil
   fileprivate var pickerFlag:filterType = .all
   
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        channelListDelegateObj = self
        WebService.getFromWeb(getChannelListUrl, completion:nil)
        filterArrayCopy = filterArray
    
        
    }
    
    // Language Button click
    @IBAction func languageClick(_ sender: Any) {
        self.filterAction()
        self.pickerFlag = .language
        pickerView.reloadComponent(0)
    }
    
    // Country Button Click
    @IBAction func countryClick(_ sender: Any) {
        self.filterAction()
        self.pickerFlag = .country
        pickerView.reloadComponent(0)
    }
    
    // Category Click
    @IBAction func categoryClick(_ sender: Any) {
        self.filterAction()
        self.pickerFlag = .category
        pickerView.reloadComponent(0)
    }
   
    
    
    // filer button click
    fileprivate func filterAction(){
        self.changeButtonView()
        self.tableViewChannel.addSubview(pickerView)
        self.pickerView.isHidden = false
    }
    
    
    @IBAction func clearButtonClick(_ sender: Any) {
       self.changeButtonView()
       self.pickerFlag = .all
       self.filterArray(pickerFlag, 0)
    }
    
    
    fileprivate func changeButtonView(){
        self.filterViewHeight.constant = self.filterButtonView.isHidden ? 80 : 0
        self.filterButtonView.isHidden = !self.filterButtonView.isHidden
    }
    
    
    //MARK: Implementation of Generics
    func sort<T>(_  arr : T)->T{
        if arr is [channel] {
            return (arr as! [channel]).sorted(by: { obj1, obj2 in
                obj1.name ?? " " < obj2.name ?? " "
            }) as! T
        }
     //MARK: Implementation of Shorthand arguments
        else if arr is [String] {
            return (arr as! [String]).sorted(by: { $0 < $1 }) as! T
        }
        return arr
    }
 }


// TableView Delegate Implemtation
extension mainPageViewController : UITableViewDataSource, UITableViewDelegate {
    // onclick action for tableview cell button
    
    func webviewButtonClick(_ sender : UIButton){
        if self.channelArray.count > sender.tag{
            guard  channelArray[sender.tag].url != nil, let url = URL(string: channelArray[sender.tag].url!) else {
                return
            }
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: viewController.ids.webViewController) as? webViewController{
                vc.urlRequest = URLRequest(url: url)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func OnFilterClicked(_ sender: UIButton) {
        self.changeButtonView()
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIds.list.mainPage, for: indexPath) as! mainPageCell
        cell.setCellData(channelArray[indexPath.row])
        cell.webViewClickButton.tag = indexPath.row
        cell.webViewClickButton.addTarget(self, action: #selector(self.webviewButtonClick(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelArray.count
    }
    // onclick action for tableview 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //MARK: Implementation of Guard
        guard channelArray.count > indexPath.row else {
            return
        }
        
        let channelObj = channelArray[indexPath.row]
        let details = channelObj[channelObj.name]
        let alert = UIAlertController(title: "NewsFeed", message: details, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .destructive, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
}


// List Delegate Implemetation
//MARK: impl of extension
extension mainPageViewController : channelListDelegate {
    
    
    //MARK: inout impl for values from service
    fileprivate func getValuesFromDict(_ channelObj : inout channel, _ values : NSDictionary){
        
        channelObj.name = values[web.constants.name] as? String

        //MARK: impl of optionalchaining
        var category = (values[web.constants.category] as? String) ?? ""
        
        channelObj.category = category
        
        var country = (values[web.constants.country] as? String) ?? ""
        
        channelObj.country = country
        
        channelObj.descriptionChannel = values[web.constants.description] as? String
        channelObj.id = values[web.constants.id] as? String
        
        var language = (values[web.constants.language] as? String) ?? ""
        
        channelObj.language = language
        
        self.languageArray.insert(language.uppercase())
        self.categoryArray.insert(category.uppercase())
        self.countryArray.insert(country.uppercase())
        
        channelObj.url = values[web.constants.url] as? String
        if let sortAvailable = values[web.constants.sortBysAvailable] as? NSArray {
            
            for sort in sortAvailable where ((sort as? String) != nil){
                
                channelObj.availableSorting.append( sort as! String)
                
            }
            
            channelObj.availableSorting = self.sort(channelObj.availableSorting)
            
        }
        
        
    }
    
    
    func getChannelList(_ dictionary: NSDictionary?) {
        guard  dictionary != nil  else {
            return
        }
        
 //MARK: Impl of if let
        if let sources = dictionary?[web.constants.sources] as? [NSDictionary]{
            var tempChannelArray = [channel]()
            for values in sources {
                var channelObj = channel()
                self.getValuesFromDict(&channelObj, values)
                tempChannelArray.append(channelObj)
            }
            
            tempChannelArray = self.sort(tempChannelArray)
            self.channelArray = tempChannelArray
            self.allChannelArray = tempChannelArray
            DispatchQueue.main.async {
                self.tableViewChannel.reloadData()
                
            }
        }
        
    }
    
}


// Picker view delegate methods

extension mainPageViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch pickerFlag {
            
        case .language:
            return self.languageArray.count
            
        case .country :
           return  self.countryArray.count
            
        case .category:
           return self.categoryArray.count
        case .all :
            return 0
            
        }
        
    }
    
    
    //MARK: impl of enum (default case is not allowed in swift for enum)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerFlag {
            
        case .language:
              return self.languageArray[languageArray.index(languageArray.startIndex, offsetBy: row)]
            
        case .country :
              return self.countryArray[countryArray.index(countryArray.startIndex, offsetBy: row)]
            
        case .category:
            return self.categoryArray[categoryArray.index(categoryArray.startIndex, offsetBy: row)]
        case .all :
            return nil
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // function call of variable
        self.filterArrayCopy!(pickerFlag,row)
        self.pickerView.isHidden = true
    }
    
    
    
    // filter channel data
    func filterArray( _ filteringType : filterType, _ row : Int){
  
    //MARK: impl of defer
        defer {
            
            self.tableViewChannel.reloadData()
            
        }
        
    //MARK: impl of closures inside enum cases
        self.channelArray = {
            switch filteringType {
                
            case .language :
                
                let val = self.languageArray[languageArray.index(languageArray.startIndex, offsetBy: row)]
                return allChannelArray.filter( { obj  in
                    
                    return obj.language == val.lowercased()
                    
                })
                
            case .category :
                
                let val = self.categoryArray[categoryArray.index(categoryArray.startIndex, offsetBy: row)]
                
                return allChannelArray.filter( {obj  in
                    
                    return obj.category == val.lowercased()
                })
                
            case .country :
                
                let val = self.countryArray[countryArray.index(countryArray.startIndex, offsetBy: row)]
                
                return allChannelArray.filter( {obj in
                    
                    return obj.country == val.lowercased()
                })
                
            case .all:
                
                return allChannelArray
            }
            
            }()
        }
    
}


//MARK: impl for mutating
extension String {
     mutating func uppercase()->String{
        self = self.uppercased()
        return self
    }
}








