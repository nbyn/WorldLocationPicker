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
    
    let countryList = WorldLocation.getCountriesList()
    var stateList = [NSDictionary]()
    
    var selectedCountryID = ""
    var selectedStateID = ""
    
    @IBAction func selectCountryTapped(_ sender: UIButton) {
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: countryList, typeStr: "Country")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            sender.setTitle(selectedData.value(forKey: "name") as? String, for: .normal)
            self.selectedCountryID = (selectedData.value(forKey: "id") as? String)!
            self.stateList = WorldLocation.getStatesList(countryID: self.selectedCountryID)
        }
    }

    @IBAction func selectStateButtonTapped(_ sender: UIButton) {
        guard stateList.count > 0 else {
            print("Select Country First")
            return
        }
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: stateList, typeStr: "State")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            sender.setTitle(selectedData.value(forKey: "name") as? String, for: .normal)
            self.selectedStateID = (selectedData.value(forKey: "id") as? String)!
        }
    }
    
}

