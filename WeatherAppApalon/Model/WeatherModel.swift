//
//  WeatherModel.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/22/18.
//  Copyright © 2018 Екатерина. All rights reserved.
//

import Foundation
import RealmSwift
class WeatherModel:Object{
    @objc dynamic var temp:Double = 0.0
    @objc dynamic var tempMin:Double = 0.0
    @objc dynamic var tempMax:Double = 0.0
    @objc dynamic var dateTime:String? = nil
    @objc dynamic var main:String? = nil
    @objc dynamic var icon:String? = nil
    
    
    convenience init(weather: Weather){
        self.init()
        self.temp = weather.temp!
        self.tempMin = weather.tempMin!
        self.tempMax = weather.tempMax!
        self.dateTime = weather.dateTime
        self.main = weather.main!
        self.icon = weather.icon!
    }
}
