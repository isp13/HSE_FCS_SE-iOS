//
//  ViewController.swift
//  Task-list
//
//  Created by Никита on 08/11/2018.
//  Copyright © 2018 Sinapsic. All rights reserved.
//

import UIKit


class SettingsViewController:UIViewController {
    
    
    @IBOutlet weak var GraySwitch: UISwitch!
    
    @IBOutlet weak var BlueSwitch: UISwitch!
    
    
    @IBOutlet weak var BookSwitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nameobject = UserDefaults.standard.object(forKey: "color1") ?? "graystyle"
        
        if let style = nameobject as? String
        {
            if style == "bookstyle"
            {
                BookSwitch.isOn = true
                GraySwitch.isOn = false
                BlueSwitch.isOn = false
                UIView.animate(withDuration: 1)
                {
                    self.view.backgroundColor = UIColor (red: 218.0/255.0, green: 202.0/255.0, blue: 136.0/255.0, alpha: 1.0)
                    
                }
            }
            if style == "bluestyle"
            {
                BookSwitch.isOn = false
                GraySwitch.isOn = false
                BlueSwitch.isOn = true
                UIView.animate(withDuration: 1)
                {
                    self.view.backgroundColor = UIColor (red: 40.0/255.0, green: 103.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                    
                    
                }
            }
            if style == "graystyle"
            {
                BookSwitch.isOn = false
                GraySwitch.isOn = true
                BlueSwitch.isOn = false
                UIView.animate(withDuration: 1)
                {
                    self.view.backgroundColor = UIColor (red: 134.0/255.0, green: 136.0/255.0, blue: 138.0/255.0, alpha: 1.0)
                    
                    
                }
            }
        }
    }
    

    @IBAction func GraySwitced(_ sender: Any) {
        self.BlueSwitch.isOn=false
        self.BookSwitch.isOn=false
        UIView.animate(withDuration: 1)
        {
            
            
            
        self.view.backgroundColor = UIColor (red: 134.0/255.0, green: 136.0/255.0, blue: 138.0/255.0, alpha: 1.0)
            
        self.navigationController?.navigationBar.barTintColor = UIColor (red: 120.0/255.0, green: 125.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        }
        UserDefaults.standard.set("graystyle", forKey: "color1")
        
    }
    
    
    
    @IBAction func BlueSwitched(_ sender: Any) {
        self.GraySwitch.isOn = false
        self.BookSwitch.isOn = false
        UIView.animate(withDuration: 1)
        {
            self.view.backgroundColor = UIColor (red: 40.0/255.0, green: 103.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            
            self.navigationController?.navigationBar.barTintColor = UIColor (red: 35.0/255.0, green: 95.0/255.0, blue: 175.0/255.0, alpha: 1.0)
            
            
        }
        UserDefaults.standard.set("bluestyle", forKey: "color1")
    }
    
    @IBAction func BookSwitched(_ sender: Any) {
        
        
        self.BlueSwitch.isOn=false
        self.GraySwitch.isOn=false
        UIView.animate(withDuration: 1)
        {
            self.view.backgroundColor = UIColor (red: 218.0/255.0, green: 202.0/255.0, blue: 136.0/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.barTintColor = UIColor (red: 238.0/255.0, green: 202.0/255.0, blue: 100.0/255.0, alpha: 1.0)

        }
        
        
        UserDefaults.standard.set("bookstyle", forKey: "color1")
    }
    
    
}



