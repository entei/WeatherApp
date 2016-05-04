//
//  ViewController.swift
//  Weather
//
//  Created by expsk on 5/3/16.
//  Copyright © 2016 pavlovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!

    @IBAction func getDataButtonClicked(sender: AnyObject) {
        let base_url = "http://api.openweathermap.org/data/2.5/weather"
        let appid = "8641526d33fa867ef4e56e5794570ba5"
        let celsium = "metric"
        
        if let city = cityNameTextField.text {
            getWeatherData("\(base_url)?q=\(city)&units=\(celsium)&appid=\(appid)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&appid=8641526d33fa867ef4e56e5794570ba5")
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getWeatherData(urlString: String) {
        // http://api.openweathermap.org/data/2.5/weather?q=London,uk
        // appid=8641526d33fa867ef4e56e5794570ba5
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            print("task completed")
            // get back to the main thread
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data!)
            })
        }
        // you have to manually start the data task
        task.resume();
    }
    
    func setLabels(weatherData: NSData) {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! NSDictionary
            
            if let name = json["name"] as? String {
                cityNameLabel.text = name
            }
            
            if let main = json["main"] as? NSDictionary {
                if let temp = main["temp"] as? Double {
                    print("The default temperature is \(temp)°")
                    cityTempLabel.text = String(format: "%.1f°", temp)
                }
            }
        } catch {
            print("Error");
            
        }
    }
}

