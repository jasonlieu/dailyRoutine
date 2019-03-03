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
    var time: Int!
    var name: String = ""
    var date: Int = 0
    var addTask: Task?
    
    @objc func timeChanged(sender: UIDatePicker){
        let dateFromPicker = sender.date
        let timeFromDate = Calendar.current.dateComponents([.hour, .minute],from: dateFromPicker)
        let hour = timeFromDate.hour!
        let minute = timeFromDate.minute!
        time = (hour * 100) + minute        
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        date = dateField.selectedSegmentIndex
    }
    @IBAction func done(){
        if nameTextField.text != "" {
            name = nameTextField.text!
        } else{
            //need name
            print("NO NAME")
        }
        //addTask = Task(name: name, day: date, time: time)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addTask"?:
            let weekView = segue.destination as! WeekViewController
            addTask = Task(name: name, day: date, time: time)
            if addTask != nil {
                weekView.newTask = addTask
                weekView.newTaskWaiting = true
                weekView.addToDay = date
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        timeChanged(sender: timeField)
        timeField?.addTarget(self, action: #selector(AddClassViewController.timeChanged(sender:)), for: .valueChanged)
    }
    
}
