//
//  AddTaskViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/22/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController{
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateField: UISegmentedControl!
    
    @IBOutlet var timeField: UIDatePicker!
    var time:Int = 0
    var name:String = ""
    var date:Int = 0
    
    @objc func timeChanged(sender: UIDatePicker){
        let dateFromPicker = sender.date
        let timeFromDate = Calendar.current.dateComponents([.hour, .minute],from: dateFromPicker)
        let hour = timeFromDate.hour!
        let minute = timeFromDate.minute!
        time = (hour * 100) + minute
        
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        date = dateField.selectedSegmentIndex == 5 ? 0 : dateField.selectedSegmentIndex == 6 ? 1 : (dateField.selectedSegmentIndex + 2)
    }
    @IBAction func done(){
        if nameTextField.text != "" {
            name = nameTextField.text!
        } else{
            //need name
            print("NO NAME")
        }
        //create segue and item 
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //timeField = UIDatePicker()
        timeField?.addTarget(self, action: #selector(AddClassViewController.timeChanged(sender:)), for: .valueChanged)
    }
    
}
