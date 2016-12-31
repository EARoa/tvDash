//
//  ViewController.swift
//  tvDash
//
//  Created by Efrain Ayllon on 12/30/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    var location = [Location]()
    
    @IBOutlet weak var currentTemperature :UILabel!
    @IBOutlet weak var currentSummary :UILabel!
    @IBOutlet weak var currentHumidity :UILabel!
    @IBOutlet weak var currentVisibility :UILabel!
    @IBOutlet weak var currentWindSpeed :UILabel!
    
    var latitude :Double!
    var longitude :Double!
    
    let currentLocation = Location()
    var locationManager  :CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        apiSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func locationSetup(){
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        
        latitude = locationManager.location!.coordinate.latitude
        longitude = locationManager.location!.coordinate.longitude
        
        
        
    }
    
    private func apiSetup() {
        print("Lat:\(self.latitude!), Long: \(self.longitude!)")
        
        let theAPI = "https://api.forecast.io/forecast/ee590865b8cf07d544c96463ae5d47c5/\(self.latitude!),\(self.longitude!)"
        
        guard let url = NSURL(string: theAPI) else {
            fatalError("Invalid URL")
        }
        let session = URLSession.shared
        
        session.dataTask(with: url as URL) { (data :Data?, response :URLResponse?, error :Error?) in
            guard NSString(data: data!, encoding: String.Encoding.utf8.rawValue) != nil else {
                fatalError("Unable to format data")
            }
            let postResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
            
            
            
            let dataArray = postResult["currently"] as! NSDictionary?;
            self.currentLocation.temperature = dataArray!.value(forKey: "temperature") as! Int
//            self.currentLocation.summary = dataArray!.value(forKey: "summary") as! String
//            self.currentLocation.humidity = dataArray!.value(forKey: "humidity") as! Int
//            self.currentLocation.visibility = dataArray!.value(forKey: "visibility") as! Int
//            self.currentLocation.windspeed = dataArray!.value(forKey: "windSpeed") as! Int
            
            self.location.append(self.currentLocation)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                self.currentTemperature.text = "Temperature: \(self.currentLocation.temperature!)℉"
                self.currentTemperature.text = "\(self.currentLocation.temperature!)℉"

                
//                self.currentSummary.text = "Summary: \(self.currentLocation.summary)"
//                self.currentHumidity.text = "Humidity: \(self.currentLocation.humidity)"
//                self.currentVisibility.text = "Visibility: \(self.currentLocation.visibility)"
//                self.currentWindSpeed.text = "Windspeed: \(self.currentLocation.windspeed)"
            }
            }.resume()
    }
    
}
