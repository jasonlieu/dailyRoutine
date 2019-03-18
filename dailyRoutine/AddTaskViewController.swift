//
//  AddTaskViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/22/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController{
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateField: UISegmentedControl!
    @IBOutlet var timeField: UIDatePicker!
    var time: Int!
    var name: String = ""
    var date: Int = 0
    var addTask: Task?
    var repeatTask: Bool!
    var newTask: Task!
    
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
    @IBAction func repeatChange(sender: UISwitch) {
        if sender.isOn{
            repeatTask = true
        }
        else { repeatTask = false }
    }
    @IBAction func done(){
        if nameTextField.text != "" {
            newTask.name = nameTextField.text ?? "default"
            newTask.day = date
            newTask.time = time
            if repeatTask {
                newTask.repeatTask = 1
            }
            else { newTask.repeatTask = 0 }
            _ = navigationController?.popViewController(animated: true)
        } else{
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameTextField.layer.borderWidth = 1
        }
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        timeChanged(sender: timeField)
        timeField?.addTarget(self, action: #selector(AddTaskViewController.timeChanged(sender:)), for: .valueChanged)
        dateField.selectedSegmentIndex = 0
        repeatTask = true
    }
}
