//
//  ViewController.swift
//  Aoyama
//
//  Created by Dongri Jin on 5/31/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logView: UITextView!
    
    let aoyama = Aoyama.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //aoyama.baseURL = "https://resters.herokuapp.com"
        aoyama.baseURL = "http://localhost:5000"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func getRequest(sender: AnyObject) {
        aoyama.request(.GET, path: "/users") { (res, data, error) -> Void in
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
            self.logView.text = "\(dict)"
        }
    }
    
    @IBAction func postRequest(sender: AnyObject) {
        let parameters = ["name": "YuanJin",]
        aoyama.request(.POST, path:"/users", parameters: parameters) { (res, data, error) -> Void in
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
            self.logView.text = "\(dict)"
        }
    }
    
    
    @IBAction func putRequest(sender: AnyObject) {
        let parameters = ["name": "Apple",]
        aoyama.request(.PUT, path: "/users/1", parameters: parameters) { (res, data, error) -> Void in
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            self.logView.text = "\(dict)"
        }
    }
    
    @IBAction func deleteRequest(sender: AnyObject) {
        aoyama.request(.DELETE, path: "/users/1") { (res, data, error) -> Void in
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            self.logView.text = "\(dict)"
        }
    }
}

