//
//  OpenWeatherService.swift
//  WeatherAppApalon
//
//  Created by Екатерина on 10/21/18.
//  Copyright © 2018 Екатерина. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

let openWeatherProvider = MoyaProvider<OpenWeatherEnum>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

let provider = MoyaProvider<OpenWeatherEnum>()

enum OpenWeatherEnum{
    case forecast(parameters: ForecastParameter)
}
extension OpenWeatherEnum:TargetType{
    var baseURL: URL {
        return URL(string: "http://api.openweathermap.org/data/2.5/")!
    }
    
    var path: String {
        switch self{
        case .forecast:
            return "forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forecast:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self{
        case .forecast(let param):
            return .requestParameters(parameters: ["APPID":param.aPPID,
                                                   "lon":param.lon,
                                                   "lat":param.lat,
                                                   "units":"metric"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    var validationType: ValidationType{
        return .successCodes
    }
    
}
