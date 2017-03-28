//
//  SearchAndFindPicker.swift
//  WorldLocationPicker
//
//  Created by Malik Wahaj Ahmed on 21/03/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import Foundation
import UIKit


class SearchAndFindPicker : UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var filteredArray:[[String:AnyObject]] = []
    var dataArray = [[String:AnyObject]]()
    
    var dataTypeStr = ""
    
    var selectedData:[String:AnyObject]!
    var doneButtonTapped: (([String:AnyObject])->())?
    
    static func createPicker(dataArray: [[String:AnyObject]], typeStr : String) -> SearchAndFindPicker {
        let newViewController = UIStoryboard(name: "SearchAndFindPicker", bundle: nil).instantiateViewController(withIdentifier: "SearchAndFindPicker") as! SearchAndFindPicker
        newViewController.dataArray = dataArray
        newViewController.dataTypeStr = typeStr
        return newViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.placeholder = "Search \(dataTypeStr)"
        
        self.searchBar.setTextColor(color: .black)
        self.searchBar.setPlaceholderTextColor(color: .black)
        self.searchBar.setTextFieldColor(color: .clear)
        self.searchBar.setSearchImageColor(color: .black)
        self.searchBar.setTextFieldClearButtonColor(color: .black)
        
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(tapGestureRecognizer:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        clearSelection()
    }
    
    func backgroundTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard (selectedData) != nil else {
            print("Select \(dataTypeStr)")
            return
        }
        doneButtonTapped?(selectedData)
        self.close()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.close()
    }
    
    func show(vc:UIViewController) {
        vc.addChildViewController(self)
        vc.view.addSubview(self.view)
    }
    
    func close() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func clearSelection() {
    
        var tempDataArray = [[String:AnyObject]]()
        for i in 0..<dataArray.count {
            var data = dataArray[i]
            data.updateValue(0 as AnyObject, forKey: "unselected")
            tempDataArray.append(data)
        }
        dataArray = tempDataArray
        tableView.reloadData()
    }
    
}

extension SearchAndFindPicker : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = dataArray.filter ({ (data) -> Bool in
            if let tmp = data["name"] as? NSString {
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }
            return false
        })
        if(filteredArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
}

extension SearchAndFindPicker : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredArray.count
        }
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAndFindCell", for: indexPath) as? SearchAndFindCell {
            if(searchActive && filteredArray.count > 0){
                cell.labelName.text = filteredArray[indexPath.row]["name"] as? String
            } else {
                cell.labelName.text = dataArray[indexPath.row]["name"] as? String
            }
            if let unselected = dataArray[indexPath.row]["unselected"] as? Int {
                cell.actionButton.isHidden = unselected == 0 ? true : false
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearSelection()
        if let cell = tableView.cellForRow(at: indexPath) as? SearchAndFindCell {
            cell.actionButton.isHidden = false
            if (searchActive && filteredArray.count > 0) {
                selectedData = filteredArray[indexPath.row]
            }
            else {
                selectedData = dataArray[indexPath.row]
            }
        }
    }
}

extension SearchAndFindPicker {
    
    func keyBoardWillShow() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    func keyBoardWillHide() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool){
        
        let kOffset:CGFloat = 80.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= kOffset;
            rect.size.height += kOffset;
        }
        else
        {
            rect.origin.y += kOffset;
            rect.size.height -= kOffset;
        }
        self.view.frame = rect;
        UIView.commitAnimations()
    }
    
}
