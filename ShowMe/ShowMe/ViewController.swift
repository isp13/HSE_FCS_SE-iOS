//
//  ViewController.swift
//  ShowMe
//
//  Created by Никита Казанцев on 14.10.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textToSendField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func showMe(_ sender: Any) {
        NSLog("User Wrote: %@", textToSendField.text!)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let messageController = segue.destination as! MessageViewController
        messageController.messageData = textToSendField.text
    }
}

