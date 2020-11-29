//
//  ViewController.swift
//  Weather-ios2nis
//  Created by HSE  FKN on 13.11.2020.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var myCity: UITextField!
    @IBOutlet weak var myForecast: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCity.delegate = self
    }
    
    @IBAction func getForecast(_ sender: UIButton) {
        var s = myCity.text!.trimmingTrailingSpaces()
        s = s.trimmingLeadingSpaces()
        myCity.text = s
        
        if s == "" {
            myForecast.text = "Enter city and tap 'Get forecast'."
            return
        }
        var weather = ""
        let url = URL(string: "http://www.weather-forecast.com/locations/\(s.replacingOccurrences(of: " ", with: "-"))/forecasts/latest")
        var urlError = false
        
        if url != nil {
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    let urlContentArray = urlContent?.components(separatedBy: "<span class=\"phrase\">")
                    
                    if (urlContentArray?.count)! > 1 {
                        let weatherArray = urlContentArray!.last!.components(separatedBy: "</span>")
                        weather = (weatherArray.first)!
                        weather = weather.replacingOccurrences(of: "&deg", with: "°")
                    } else {
                        urlError = true
                    }
                } else {
                    urlError = true
                }
                
                DispatchQueue.main.async {
                    if urlError == true {
                        self.showError(s)
                    } else {
                        self.myForecast.text = weather
                    }
                }
            }
            task.resume()
        } else {
            showError(s)
        }
    }
    
    
    func showError(_ s: String) {
        myForecast.text = "Was not able to find weather forecast for \(s). Please try again."
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myCity.resignFirstResponder()
        return true
    }

}


extension String {
    func trimmingTrailingSpaces() -> String {
        var s = self
        while s.hasSuffix(" ") {
            s = "" + s.dropLast()
        }
        return s
    }
    
    func trimmingLeadingSpaces() -> String {
        var s = self
        while s.hasPrefix(" ") {
            s = s.dropFirst() + ""
        }
        return s
    }
}
