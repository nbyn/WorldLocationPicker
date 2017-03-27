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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var filteredArray:[NSDictionary] = []
    var dataArray = [NSDictionary]()
    
    var dataTypeStr = ""
    
    var selectedData:NSDictionary!
    var doneButtonTapped: ((NSDictionary)->())?
    
    static func createPicker(dataArray: [NSDictionary], typeStr : String) -> SearchAndFindPicker {
        let newViewController = UIStoryboard(name: "SearchAndFindPicker", bundle: nil).instantiateViewController(withIdentifier: "SearchAndFindPicker") as! SearchAndFindPicker
        newViewController.dataArray = dataArray
        newViewController.dataTypeStr = typeStr
        return newViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.searchBar.placeholder = "Search \(dataTypeStr)"
        
        self.searchBar.setTextColor(color: .black)
        self.searchBar.setPlaceholderTextColor(color: .black)
        self.searchBar.setTextFieldColor(color: .clear)
        self.searchBar.setSearchImageColor(color: .black)
        self.searchBar.setTextFieldClearButtonColor(color: .black)
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
        
        if let selectedItems = tableView.indexPathsForSelectedRows {
            for iPath in selectedItems {
                tableView.deselectRow(at: iPath, animated: true)
                let cell = tableView.cellForRow(at: iPath) as! SearchAndFindCell
                cell.actionButton.isHidden = true
            }
        }
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
            let tmp = data.value(forKey: "name") as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAndFindCell", for: indexPath) as! SearchAndFindCell
        if(searchActive){
            cell.labelName.text = filteredArray[indexPath.row].value(forKey: "name") as? String
        } else {
            cell.labelName.text = dataArray[indexPath.row].value(forKey: "name") as? String
        }
        cell.actionButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        clearSelection()
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchAndFindCell
        cell.actionButton.isHidden = false
        if (searchActive && filteredArray.count > 0) {
            selectedData = filteredArray[indexPath.row]
        }
        else {
            selectedData = dataArray[indexPath.row]
        }
    }
}
