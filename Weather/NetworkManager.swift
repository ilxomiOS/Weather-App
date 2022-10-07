//
//  NetworkManager.swift
//  Weather
//
//  Created by Ilxom on 05/10/22.
// "https://api.openweathermap.org/data/2.5/weather?q=Tashkent&apikey=358389cc2e7b7f987ac85f1075b911c6&units=metric"

import Foundation

struct NetworkManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&apikey=358389cc2e7b7f987ac85f1075b911c6&units=metric"
    
    var onCompletion: ((CurrentWeather) -> ())?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let decodeData = try decoder.decode(WeatherData.self, from: data)
                guard let currentWeather = CurrentWeather(weatherData: decodeData) else { return }
                onCompletion?(currentWeather)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
