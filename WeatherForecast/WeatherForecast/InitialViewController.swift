//
//  InitialViewController.swift
//  WeatherForecast
//
//  Created by Ram Kumar on 27/09/21.
//

import UIKit
import Foundation

class weatherForecastCell : UICollectionViewCell {
    
    @IBOutlet weak var tempInfoLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateInfoLabel: UILabel!
}

class InitialViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var cityInfoLabel: UILabel!
    @IBOutlet weak var weatherDetailedInfoLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLevelLabel: UILabel!
    @IBOutlet weak var feelingTempLabel: UILabel!
    @IBOutlet weak var seeMoreBTN: UIButton!
    @IBOutlet weak var weatherForecastCV: UICollectionView!
    @IBOutlet weak var weathericonIV: UIImageView!
    
    @IBOutlet weak var searchLocationBTN: UIBarButtonItem!
    var weatherArray : [List] = []
    var weatherArrayShow : [[String:String]] = []
    var temp : String!
    var icon : String!
    var cityData : String!
    var weatherDescData : String!
    var windSpeedData : String!
    var humidityData :  String!
    var feelsLikeData : String!
    var dateCollectionArray : [String] = []
    var iconCollectionArray : [String] = []
    var tempCollectionArray : [String] = []
    var currentCityName = String()
    var weatherDataArray : [Welcome] = []
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let cityName = UserDefaults.standard.string(forKey: "CityNameKey")
        if(currentCityName != cityName){
             WeatherAPI.getWeatherInfo(completion: weatherResponseHandler(success:error:))
        }
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.weatherForecastCV.delegate = self
        self.weatherForecastCV.dataSource = self
        self.weatherForecastCV.alwaysBounceHorizontal = true
        //set navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.view.layer.cornerRadius = 10
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backGround")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        WeatherAPI.getWeatherInfo(completion: weatherResponseHandler(success:error:))
    }
    
    // MARK: - weatherResponseHandler
    func weatherResponseHandler(success:Bool,error: Error?) -> Void
    {
        if success
        {
            weatherArray = WeatherAPI.const.list
            weatherDataArray = WeatherAPI.const.weatherArray
            currentCityName = WeatherAPI.const.city.name
            filterDataFromResponse()
        } else
            {
                showAlert(title: "Error", message: "Enter some other Location")
                print("error :", error as Any)
            }
    }
    
    // MARK: - showAlert
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ action in
            self.undoCityName()
        } ))
        self.present(alert, animated: true)
    }
    
    // MARK: - undoCityName
    func undoCityName()
    {
        let defaults = UserDefaults.standard
        defaults.setValue(cityInfoLabel.text!, forKey: "CityNameKey")
    }
    
    // MARK: - searchLocationBTN
    @IBAction func searchLocationBTN(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(identifier: "searchIdentifier") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - filterDataFromResponse
    func filterDataFromResponse()
    {
        var dateArray : [String] = []
        var minTempArray : [String] = []
        var maxTempArray : [String] = []
        var weatherDescArray : [String] = []
        var iconArray : [String] = []
        var windSpeedArray : [String] = []
        var humidityArray : [String] = []
        var feelingArray : [String] = []
        var tempArray : [String] = []

        for index in 0..<weatherArray.count
        {
            dateArray.append(weatherArray[index].dtTxt)
            weatherDescArray.append(weatherArray[index].weather[0].weatherDescription.rawValue)
            iconArray.append(weatherArray[index].weather[0].icon.rawValue)
            windSpeedArray.append(String(weatherArray[index].wind.speed))
            humidityArray.append(String(weatherArray[index].main.humidity))
            
            // Convert temperature from fahrenheit to Celsius
            var convertedTemp = calculateCelsius(fahrenheit: (String(weatherArray[index].main.temp)))
            convertedTemp = String(format: "%.0f", round(Double(convertedTemp)!))
            tempArray.append(convertedTemp)

            // Convert Minimum temperature from fahrenheit to Celsius
            var convertedMinTemp = calculateCelsius(fahrenheit: (String(weatherArray[index].main.tempMin)))
            convertedMinTemp = String(format: "%.0f", round(Double(convertedMinTemp)!))
            minTempArray.append(convertedMinTemp)

            // Convert Maximum temperature from fahrenheit to Celsius
            var convertedMaxTemp = calculateCelsius(fahrenheit: (String(weatherArray[index].main.tempMax)))
            convertedMaxTemp = String(format: "%.0f", round(Double(convertedMaxTemp)!))
            maxTempArray.append(convertedMaxTemp)
                    
            // Convert Feeling temperature from fahrenheit to Celsius
            var convertedFeelingTemp = calculateCelsius(fahrenheit: (String(weatherArray[index].main.feelsLike)))
            convertedFeelingTemp = String(format: "%.0f", round(Double(convertedFeelingTemp)!))
            feelingArray.append(convertedFeelingTemp)
            
        }
        //Clear Array to avoid duplicates
        dateCollectionArray.removeAll()
        iconCollectionArray.removeAll()
        tempCollectionArray.removeAll()
        
        let hourlyForecastLimit = 10
        if(tempArray.count >= hourlyForecastLimit )
        {
            for index in 0..<hourlyForecastLimit
            {
                dateCollectionArray.append(weatherArray[index].dtTxt)
                iconCollectionArray.append(weatherArray[index].weather[0].icon.rawValue)
                tempCollectionArray.append(tempArray[index])
            }
        }
        
        // Convert Date Format
        var convertedDateArray = [String]()
        for i in 0..<dateArray.count
        {
            let convertedDate = convertDateFormater(String(dateArray[i]))
            convertedDateArray.append(convertedDate)
        }
        
        var resultDateArray = [String]()
        var resultMinArray = [String]()
        var resultMaxArray = [String]()
        var resultDescArray = [String]()
        var resultIconArray = [String]()
        var resultWindSpeedArray = [String]()
        var resultHumidityArray = [String]()
        var resultFeelingArray = [String]()
        var resultTempArray = [String]()

        var index = 0
        for value in convertedDateArray
        {
            if !resultDateArray.contains(value)
            {
                resultDateArray.append(value)
                resultMinArray.append(minTempArray[index])
                resultMaxArray.append(maxTempArray[index])
                resultDescArray.append(weatherDescArray[index])
                resultTempArray.append(tempArray[index])
                resultIconArray.append(iconArray[index])
                resultWindSpeedArray.append(windSpeedArray[index])
                resultHumidityArray.append(humidityArray[index])
                resultFeelingArray.append(feelingArray[index])
            }
            index += 1
        }
        
        var weatherInfoDict : [String:String] = [:]
        var weatherForecastArray = [[String:String]]()
        let cityNameInfo = currentCityName

        for index in 0..<resultDateArray.count
        {
            weatherInfoDict["Date:"] = resultDateArray[index]
            weatherInfoDict["MinTemp:"] = resultMinArray[index]
            weatherInfoDict["MaxTemp:"] = resultMaxArray[index]
            weatherInfoDict["WeatherDescInfo:"] = resultDescArray[index]
            weatherInfoDict["TempInfo:"] = resultTempArray[index]
            weatherInfoDict["Icon:"] = resultIconArray[index]
            weatherInfoDict["CityName: "] = cityNameInfo
            weatherInfoDict["Wind Speed: "] = resultWindSpeedArray[index]
            weatherInfoDict["Humidity: "] = resultHumidityArray[index]
            weatherInfoDict["Feeling: "] = resultFeelingArray[index]
            weatherForecastArray.append(weatherInfoDict)
        }
        
        saveDataToPlist(dataArray: weatherForecastArray)
        fetchDataFromPlist()
        displayInfo()
    }
    
    // MARK: - saveDataToPlist
    func saveDataToPlist( dataArray: [[String:String]])
    {
        do
        {
            let url = URL(fileURLWithPath: "/Users/ramkumar/Desktop/Project/WeatherForecast/WeatherForecast/WeatherForecastData.plist")
            try! PropertyListEncoder().encode(dataArray).write(to: url)
        }
    }
    
    // MARK: - fetchDataFromPlist
    func fetchDataFromPlist()
    {
        do
        {
            let url = URL(fileURLWithPath: "/Users/ramkumar/Desktop/Project/WeatherForecast/WeatherForecast/WeatherForecastData.plist")
            let data = try! Data(contentsOf: url)
            let weatherArray2 = try! (PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]])!

            if(self.weatherArray.count >= 0)
            {
                temp = weatherArray2[0]["TempInfo:"]
                icon = weatherArray2[0]["Icon:"]
                cityData = weatherArray2[0]["CityName: "]
                weatherDescData = weatherArray2[0]["WeatherDescInfo:"]
                humidityData = weatherArray2[0]["Humidity: "]
                windSpeedData = weatherArray2[0]["Wind Speed: "]
                feelsLikeData = weatherArray2[0]["Feeling: "]
            }
            
            weatherArrayShow = weatherArray2
            DispatchQueue.main.async
            {
                self.weatherForecastCV.reloadData()
            }
        }
    }
        
    // MARK: - displayInfo
    func displayInfo()
    {
        DispatchQueue.global().async
        {
            if let tempe = self.temp, let cityInfo = self.cityData, let weatherInfo = self.weatherDescData, let humidityContent = self.humidityData, let windSpeed = self.windSpeedData, let feelLike = self.feelsLikeData, let icon = self.icon
            {
        DispatchQueue.main.async
            {
            self.temperatureLabel.text! = String(format:  "\(tempe)°")
            self.cityInfoLabel.text! = String(format: "\(cityInfo)").capitalized
            self.weatherDetailedInfoLabel.text! = String(format: "\(weatherInfo)").capitalized
            self.windSpeedLabel.text! = String(format: "\(windSpeed)mph")
            self.humidityLevelLabel.text! = String(format: "\(humidityContent)%")
            self.feelingTempLabel.text! = String(format: "\(feelLike)°")
            self.weathericonIV.image = UIImage(named: icon)
                }
            }
        }
    }
    
    // MARK: - collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dateCollectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherForecastCell", for: indexPath) as! weatherForecastCell
        cell.tempInfoLabel.text = String(format: "\(tempCollectionArray[indexPath.row])°")
        cell.iconImageView.image = UIImage(named: iconCollectionArray[indexPath.row])
        
        let convertedDate = convertDateFormatToDisplayInCV(String(dateCollectionArray[indexPath.row]))
        cell.dateInfoLabel.text = convertedDate
        cell.layer.cornerRadius = 20
        return cell
    }

    // MARK: - seeMoreBTN
    @IBAction func seeMoreBTN(_ sender: Any)
    {
    }
    
    // MARK: - convertDateFormater
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "E,dd MMM yy"
        return  dateFormatter.string(from: date!)
    }
    
    // MARK: - convertDateFormatToDisplayInCV
    func convertDateFormatToDisplayInCV(_ date : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "h:mm a"
        return  dateFormatter.string(from: date!)
    }
     
    // MARK: - calculateCelsius
    func calculateCelsius(fahrenheit: String) -> String
    {
        let fahrenheitDouble = Double(fahrenheit)
        var celsius : Double
        celsius = (fahrenheitDouble! - 32) * 5 / 9
        return String(celsius)
    }
    
    // MARK: - dummieAlert
    func dummieAlert()
    {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter City", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField
        {   (textField) in textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField!.text))")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}



