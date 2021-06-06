//
//  WeatherModel.swift
//  Clima
//
//  Created by fmustafa on 6/6/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double

    var conditionName: String { // computed property
        return getConditionName(weatherId: conditionId)
    }

    func getConditionName(weatherId: Int) -> String {
        switch weatherId {
        case 200...232: // Thunderstorm
            return "cloud.bolt"
        case 300...321: // Drizzle
            return "cloud.drizzle"
        case 500...531: // Rain
            return "cloud.rain"
        case 600...622: // Snow
            return "cloud.snow"
        case 701...781: // Atmosphere
            return "cloud.fog"
        case 801...804: // Clouds
            return "cloud"
        default:
            return "sun.max"
        }
    }
}
