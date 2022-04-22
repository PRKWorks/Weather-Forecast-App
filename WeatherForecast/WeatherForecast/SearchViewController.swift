//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Ram Kumar on 21/09/21.
//

import UIKit
import Foundation

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationDetailTF: UITextField!
    @IBOutlet weak var submitBTN: UIButton!
    
    // MARK: - viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationDetailTF.delegate = self
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backGround")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    // MARK: - submitBTN
    @IBAction func submitBTN(_ sender: Any)
    {
     if (locationDetailTF.text?.count != 0)
        {
            navigationController?.popToRootViewController(animated: true)
            let defaults = UserDefaults.standard
            defaults.setValue(locationDetailTF.text!, forKey: "CityNameKey")
        }
        else
        {
            showAlert(title: "Enter Text", message: "Text Field is Empty")
        }
    }
    
    // MARK: - showAlert
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}



