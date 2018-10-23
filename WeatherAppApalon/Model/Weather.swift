//
//  Weather.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/22/18.
//  Copyright © 2018 Екатерина. All rights reserved.
//

import Foundation

class Weather{
    
    var temp:Double?
    var tempMin:Double?
    var tempMax:Double?
    var dateTime:String?
    
    var main:String?
    var icon:String?
    var city:String?
    init(data: Any,city:String?) {
        guard let  dic = data as? [AnyHashable: Any] else { return }
                dateTime = dic["dt_txt"] as? String
                if let main = dic["main"] as? [AnyHashable: Any]{
                    temp = main["temp"] as? Double
                    tempMin = main["temp_min"] as? Double
                    tempMax = main["temp_max"] as? Double
                }
                if let weather = dic["weather"] as? [Any]{
                    let dict = weather[0] as? [AnyHashable:Any]
                    main = dict?["main"] as? String
                    icon = dict?["icon"] as? String
                }
        self.city = city
        
    }
    init(weatherModel:WeatherModel) {
        self.temp = weatherModel.temp
        self.tempMin = weatherModel.tempMin
        self.tempMax = weatherModel.tempMax
        self.dateTime = weatherModel.dateTime
        self.icon = weatherModel.icon
        self.main = weatherModel.main
        self.city = weatherModel.city
        
    }
    
}
