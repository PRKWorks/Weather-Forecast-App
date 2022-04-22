//
//  WeatherResponse.swift
//  WeatherForecast
//
//  Created by Ram Kumar on 20/10/21.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable
{
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable
{
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable
{
    let lat, lon: Double
}

// MARK: - List
struct List: Codable
{
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?
    let snow: Snow?

    enum CodingKeys: String, CodingKey
    {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct Clouds: Codable
{
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable
{
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey
    {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey
    {
        case the3H = "3h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the13H: Double

    enum CodingKeys: String, CodingKey
    {
        case the13H = "13h"
    }
}

// MARK: - Sys
struct Sys: Codable
{
    let pod: Pod
}

enum Pod: String, Codable
{
    case d = "d"
    case n = "n"
}

   // MARK: - Weather
   struct Weather: Codable
   {
       let id: Int
       let main: MainEnum
       let weatherDescription: Description
       let icon: Icon

       enum CodingKeys: String, CodingKey
       {
           case id, main
           case weatherDescription = "description"
           case icon
       }
   }

   enum Icon: String, Codable
   {
       case the01D = "01d"
       case the01N = "01n"
       case the02D = "02d"
       case the02N = "02n"
       case the03D = "03d"
       case the03N = "03n"
       case the04D = "04d"
       case the04N = "04n"
       case the09D = "09d"
       case the09N = "09n"
       case the10D = "10d"
       case the10N = "10n"
       case the11D = "11D"
       case the11N = "11n"
       case the13D = "13d"
       case the13N = "13n"
       case the50D = "50d"
       case the50N = "50n"
   }

   enum MainEnum: String, Codable
   {
       case clouds = "Clouds"
       case rain = "Rain"
       case thunderStorm = "Thunderstorm"
       case drizzle = "Drizzle"
       case snow = "Snow"
       case atmosphere = "Atmosphere"
       case clear = "Clear"
    }

   enum Description: String, Codable
   {
       case fewClouds = "few clouds"
       case lightRain = "light rain"
       case overcastClouds = "overcast clouds"
       case scatteredClouds = "scattered clouds"
       case thunderstormWithLightRain = "thunderstorm with light rain"
       case thunderstormWithRain = "thunderstorm with rain"
       case thunderstormWithHeavyRain = "thunderstorm with heavy rain"
       case lightThunderStorm = "light thunderstorm"
       case thunderStorm = "thunderstorm"
       case heavyThunderStorm = "heavy thunderstorm"
       case raggedThunderStorm = "ragged thunderstorm"
       case thunderstormWithLightDrizzle = "thunderstorm with light drizzle"
       case thunderstormWithDrizzle = "thunderstorm with drizzle"
       case thunderstormWithHeavyDrizzle = "thunderstorm with heavy drizzle"
       case lightIntensityDrizzle = "light intensity drizzle"
       case drizzle = "drizzle"
       case heavyIntensityDrizzle = "heavy intensity drizzle"
       case lightIntensityDrizzleRain = "light intensity drizzle rain"
       case drizzleRain = "drizzle rain"
       case heavyIntensityDrizzleRain = "heavy intensity drizzle rain"
       case showerRainAndDrizzle = "shower rain and drizzle"
       case heavyShowerRainAndDrizzle = "heavy shower rain and drizzle"
       case showerDrizzle = "shower drizzle"
       case moderateRain = "moderate rain"
       case heavyIntensityRain = "heavy intensity rain"
       case veryHeavyRain = "very heavy rain"
       case extremeRain = "extreme rain"
       case freezingRain = "freezing rain"
       case lightIntensityShowerRain = "light intensity shower rain"
       case showerRain = "shower rain"
       case heavyIntensityShowerRain = "heavy intensity shower rain"
       case raggedShowerRain = "ragged shower rain"
       case lightSnow = "light snow"
       case snow = "Snow"
       case heavySnow = "Heavy snow"
       case sleet = "Sleet"
       case lightShowerSleet = "Light shower sleet"
       case showerSleet = "Shower sleet"
       case lightRainAndSnow = "Light rain and snow"
       case rainAndSnow = "Rain and snow"
       case lightShowerSnow = "Light shower snow"
       case showerSnow = "Shower snow"
       case heavyShowerSnow = "Heavy shower snow"
       case mist = "mist"
       case smoke = "Smoke"
       case haze = "Haze"
       case sandDustWhirls = "sand/ dust whirls"
       case fog = "fog"
       case sand = "sand"
       case dust = "dust"
       case volcanicAsh = "volcanic ash"
       case squalls = "squalls"
       case tornado = "tornado"
       case clearSky = "clear sky"
       case brokenClouds = "broken clouds"
   }

   // MARK: - Wind
   struct Wind: Codable
   {
       let speed: Double
       let deg: Int
       let gust: Double
   }
