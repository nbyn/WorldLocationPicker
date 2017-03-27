//
//  WorldLocation.swift
//  WorldLocationPicker
//
//  Created by Malik Wahaj Ahmed on 21/03/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import Foundation

class WorldLocation : NSObject {
    
    class func getCountriesList() -> [NSDictionary]{
        
        var countriesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    countriesInfo = jsonResult as! [NSDictionary]
                } catch {}
            } catch {}
        }
        return countriesInfo
    }
    
    class func getStatesList(countryID:String) -> [NSDictionary] {
        
        var statesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    statesInfo = (jsonResult as! [NSDictionary]).filter{$0.value(forKey: "country_id") as! String == countryID}
                } catch {}
            } catch {}
        }
        return statesInfo
    }
    
    class func getCitiesList(stateID:String) -> [NSDictionary] {
        
        var citiesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    citiesInfo = (jsonResult as! [NSDictionary]).filter{$0.value(forKey: "state_id") as! String == stateID}
                } catch {}
            } catch {}
        }
        return citiesInfo
    }
    
}
