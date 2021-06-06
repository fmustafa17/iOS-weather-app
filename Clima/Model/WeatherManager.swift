//
//  WeatherManager.swift
//  Clima
//
//  Created by fmustafa on 6/6/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: NSObject {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=1d429718cf975be3730533a23c8e4d70&units=imperial&q="

    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let url = weatherUrl + cityName
        performRequest(urlString: url)
    }

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                self.handle(data: data, response: response, error: error)
            })

            // Start the task
            task.resume()
        }
    }

    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print(error)
            delegate?.didFailWithError(error: error)
            return
        }

        if let safeData = data {
            parseJSON(weatherData: safeData)
        }
    }

    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp

            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)

            delegate?.didUpdateWeather(weatherManager: self, weather: weatherModel)
            print(weatherModel.getConditionName(weatherId: id))
        } catch {
            print(error)
        }
    }


}
