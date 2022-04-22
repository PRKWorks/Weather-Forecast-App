//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Ram Kumar on 20/10/21.
//

import Foundation
import UIKit

    // MARK: - WeatherAPI
    class WeatherAPI {
    struct const
    {
        static var ApiKey: String = "5138c72c4ed19a1cc943e54e2b2ddb86"//as header
        static let baseurl: String = "https://api.openweathermap.org/data/2.5"
        static let defaultCityName : String = "Chennai"
        static var cityName: String = UserDefaults.standard.string(forKey: "CityNameKey") ?? defaultCityName
        static var city : City!
        static var weatherArray : [Welcome] = []
        static var list : [List] = []
        static var url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(ApiKey)&units=imperial")
        static var weatherDesc : [Weather] = []
        static var tempData : MainClass!
    }
    
    // MARK: - getWeatherInfo
    class func getWeatherInfo(completion: @escaping(Bool,Error?)->Void)
    {
        const.cityName = UserDefaults.standard.string(forKey: "CityNameKey") ?? const.defaultCityName
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(WeatherAPI.const.cityName)&appid=\(WeatherAPI.const.ApiKey)&units=imperial")
        const.url = url
        
        let _ = WeatherAPI.taskForGETRequest(url: WeatherAPI.const.url!, responseType: Welcome.self)
            {
                response, error in
            // check for error
                guard let response = response else
                {
                    completion(false,error)
                    print("error ::",error!)
                    return
                }
                const.city = response.city
                const.list = response.list
                const.weatherDesc = response.list[0].weather
                const.weatherArray.append(response)
                completion(true,nil)
            }
    }
    
    // MARK: - taskForGETRequest
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion:  @escaping(ResponseType?,Error?)->Void) -> URLSessionDataTask
    {
        // Create a URLRequest Object
        let urlreq = URLRequest(url: url)
        // Create a data task
        let task = URLSession.shared.dataTask(with: urlreq) { data, response, error in
            // check for error
            guard let data = data else
            {
                DispatchQueue.main.async 
                {
                    completion(nil, error)
                }
                return
            }
            do
            {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async
                {
                    completion(responseObject, nil)
                }
            }
            catch
            {
                print(error)
                completion(nil,error)
            }
        }
        task.resume()
        
        return task
    
    }
    
}

