//
//  ViewController.swift
//  WorldLocationPicker
//
//  Created by Malik Wahaj Ahmed on 19/03/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    let countryList = WorldLocation.getCountriesList()
    var stateList = [NSDictionary]()
    var cityList = [NSDictionary]()
    
    var selectedCountryID = ""
    var selectedStateID = ""
    var selectedCityID = ""
    
    @IBAction func selectCountryTapped(_ sender: UIButton) {
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: countryList as! [[String : AnyObject]], typeStr: "Country")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            sender.setTitle(selectedData["name"] as? String, for: .normal)
            self.selectedCountryID = (selectedData["id"] as? String)!
            self.stateList = WorldLocation.getStatesList(countryID: self.selectedCountryID)
        }
    }

    @IBAction func selectStateButtonTapped(_ sender: UIButton) {
        guard stateList.count > 0 else {
            print("Select Country First")
            return
        }
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: stateList as! [[String : AnyObject]], typeStr: "State")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            sender.setTitle(selectedData[ "name"] as? String, for: .normal)
            self.selectedStateID = (selectedData[ "id"] as? String)!
            self.cityList = WorldLocation.getCitiesList(stateID: self.selectedStateID)
        }
    }
    
    @IBAction func selectCityButtonTapped(_ sender: UIButton) {
        guard cityList.count > 0 else {
            print("Select State First")
            return
        }
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: cityList as! [[String : AnyObject]], typeStr: "City")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            sender.setTitle(selectedData["name"] as? String, for: .normal)
            self.selectedCityID = (selectedData[ "id"] as? String)!
        }
    }
    @IBAction func clearSelection(_ sender: UIButton) {
        
        countryButton.setTitle("Select Country", for: .normal)
        stateButton.setTitle("Select State", for: .normal)
        cityButton.setTitle("Select City", for: .normal)
    }
}

