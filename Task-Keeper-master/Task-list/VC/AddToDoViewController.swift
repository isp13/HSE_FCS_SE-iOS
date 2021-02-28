//
//  AddToDoViewController.swift
//  Task-list
//
//  Created by Никита on 08/11/2018.
//  Copyright © 2018 Sinapsic. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
class AddToDoViewController: UIViewController {
    
    
    
    var managedContext: NSManagedObjectContext!
    var todo:Todo?
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var bottomConstraint:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        if let todo = todo{
            TextView.text = todo.title
            datePicker.date = todo.date ?? Date()
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }

        TextView.layer.cornerRadius = 10

        setupStyle()
        
        TextView.becomeFirstResponder()
    }
    
    
    fileprivate func setupStyle() {
        let nameobject = UserDefaults.standard.object(forKey: "color1") ?? "graystyle"
        
        if let style = nameobject as? String
        {
            if style == "bookstyle"
            {
                self.view.backgroundColor = UIColor (red: 218.0/255.0, green: 202.0/255.0, blue: 136.0/255.0, alpha: 1.0)
                TextView.backgroundColor = UIColor (red: 225.0/255.0, green: 210.0/255.0, blue: 145.0/255.0, alpha: 1.0)
                
            }
            if style == "bluestyle"
            {
                self.view.backgroundColor = UIColor (red: 40.0/255.0, green: 103.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                
                TextView.backgroundColor = UIColor (red: 35.0/255.0, green: 95.0/255.0, blue: 175.0/255.0, alpha: 1.0)
            }
            if style == "graystyle"
            {
                self.view.backgroundColor = UIColor (red: 134.0/255.0, green: 136.0/255.0, blue: 138.0/255.0, alpha: 1.0)
                
                TextView.backgroundColor = UIColor (red: 120.0/255.0, green: 125.0/255.0, blue: 135.0/255.0, alpha: 1.0)
            }
        }
    }
    
    
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let  keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func DismissAndResign() {
        navigationController?.popViewController(animated: true)
        TextView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        DismissAndResign()
        
    }
    
    @IBAction func done(_ sender: UIButton) {
        guard let title = TextView.text , !title.isEmpty else {
            return
        }
        
        if let todo = self.todo{
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = datePicker.date
            
        }
        else{
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = datePicker.date
        }
        
        do{
            try managedContext.save()
            DismissAndResign()
        } catch{
            print("error \(error)")
        }
    }
    

}

extension AddToDoViewController: UITextViewDelegate{
    
    func textViewDidChangeSelection(_ textView:UITextView){
        if donebutton.isHidden {
            //TextView.text.removeAll()
            TextView.textColor = .white
            
            donebutton.isHidden = false
            
            UIView.animate(withDuration: 0.3)
            {
                self.view.layoutIfNeeded()
            }
        }
    }
}
