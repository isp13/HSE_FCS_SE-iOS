//
//  ViewController.swift
//  InTouchApp
//
//  Created by Никита Казанцев on 25.10.2020.
//

import UIKit
import MessageUI
class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            
            mailVC.setSubject("MySubject")
            mailVC.setToRecipients(["xcode@mattknott.com"])
            mailVC.setMessageBody("<p>Hello!</p>", isHTML: true)
            mailVC.mailComposeDelegate = self;
            
            self.present(mailVC, animated: true, completion: nil) } else {
                print("This device is currently unable to send email") }
    }
    
    @IBAction func sendText(sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            let smsVC : MFMessageComposeViewController = MFMessageComposeViewController()
            
            smsVC.messageComposeDelegate = self
            smsVC.recipients = ["1234500000"]
            smsVC.body = "Please call me back."
            
            self.present(smsVC, animated: true, completion: nil) } else {
                print("This device is currently unable to send text messages") }
    }
    
    @IBAction func openWebsite(sender: AnyObject) {
        UIApplication.shared.open(URL(string: "http://hse.ru")!, options: [:], completionHandler: nil) }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResult.sent:
            print("Result: Email Sent!")
        case MFMailComposeResult.cancelled:
            print("Result: Email Cancelled.") case MFMailComposeResult.failed:
                print("Result: Error, Unable to Send Email.") case MFMailComposeResult.saved:
                    print("Result: Mail Saved as Draft.") }
        self.dismiss(animated: true, completion: nil) }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("Result: Text Message Sent!") case MessageComposeResult.cancelled:
                print("Result: Text Message Cancelled.") case MessageComposeResult.failed:
                    print("Result: Error, Unable to Send Text Message.") }
        self.dismiss(animated:true, completion: nil) }
}
