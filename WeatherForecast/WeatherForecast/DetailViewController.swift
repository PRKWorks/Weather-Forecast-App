//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by Ram Kumar on 12/10/21.
//

import UIKit

class DetailTableViewCell : UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var outlineIV: UIImageView!
}

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var weatherInfoTV: UITableView!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var detailViewIcon: UIImageView!
    
    var weatherArray = [[String:String]]()
    var weatherDesc : String!
    var tempValue : String!
    var iconvalue : String!
    
    // MARK: - viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherInfoTV.dataSource = self;
        weatherInfoTV.delegate = self;
        fetchDataFromPlist()
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backGround")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    // MARK: - fetchDataFromPlist
    func fetchDataFromPlist()
    {
        do
        {
            let url = URL(fileURLWithPath: "/Users/ramkumar/Desktop/Project/WeatherForecast/WeatherForecast/WeatherForecastData.plist")
            let data = try! Data(contentsOf: url)
            weatherArray = try! (PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]])!
            if(weatherArray.count > 0)
            {
                tempValue = weatherArray[0]["TempInfo:"]
                weatherDesc = weatherArray[0]["WeatherDescInfo:"]
                iconvalue = weatherArray[0]["Icon:"]
            }
            displayInfo()
            DispatchQueue.main.async
            {
                self.weatherInfoTV.reloadData()
            }
        }
    }
    
    // MARK: - displayInfo
    func displayInfo()
    {
        DispatchQueue.global().async
        {
            if let tempe = self.tempValue,let weatherInfo = self.weatherDesc,let icon = self.iconvalue
            {
                DispatchQueue.main.async
                {
                    // Declaring Values to Labels
                    self.temperatureLabel.text! = String(format:  "\(tempe)°")
                    self.weatherInfoLabel.text! = String(format: "\(weatherInfo)").capitalized
                    self.detailViewIcon.image = UIImage(named: icon)
                }
            }
        }
    }
    
    // MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 146
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell",for: indexPath) as! DetailTableViewCell
        cell.dateLabel.text = weatherArray[indexPath.row]["Date:"]
        cell.weatherDescriptionLabel.text = weatherArray[indexPath.row]["WeatherDescInfo:"]?.capitalized
        cell.weatherImageView.image = UIImage(named: weatherArray[indexPath.row]["Icon:"]!)
        let maxTemp = String(format:  "\( weatherArray[indexPath.row]["MaxTemp:"]!)°")
        let minTemp = String(format:  "\( weatherArray[indexPath.row]["MinTemp:"]!)°")
        cell.maxTempLabel.text = maxTemp
        cell.minTempLabel.text = minTemp
        tableView.layer.cornerRadius = 30
        return cell
    }
}
