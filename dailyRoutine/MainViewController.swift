//
//  MainViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{
    @IBOutlet var currentDay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekday = Calendar.current.component(.weekday, from: Date())
        currentDay.text = weekday == 0 ? "Saturday" : weekday == 1 ? "Sunday" : weekday == 2 ? "Monday" : weekday == 3 ? "Tuesday" : weekday == 4 ? "Wednesday" : weekday == 5 ? "Thursday" : "Friday"
        
    }
}
