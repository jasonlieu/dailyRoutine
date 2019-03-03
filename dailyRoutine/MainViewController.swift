//
//  MainViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    var dailyTasks: Day!

    @IBOutlet var currentDay: UILabel!

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dailyTasks.schedule.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTaskCell", for: indexPath) as! TodayTaskCell
        let task = dailyTasks.schedule[indexPath.row]
        cell.nameLabel.text = task.name
        let minute = task.time%100 < 10 ? "0" + String(task.time%100) : String(task.time%100)
        let hour = task.time/100 < 1 ? "12" : String(task.time/100)
        let AMorPM = task.time > 1200 ? " PM" : " AM"
        cell.timeLabel.text = hour + ":" + minute + AMorPM
        print(cell.timeLabel.text)
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekday = Calendar.current.component(.weekday, from: Date())
        print(weekday)
        currentDay.text = weekday == 0  || weekday == 7 ? "Saturday" : weekday == 1 ? "Sunday" : weekday == 2 ? "Monday" : weekday == 3 ? "Tuesday" : weekday == 4 ? "Wednesday" : weekday == 5 ? "Thursday" : "Friday"
        tableView.rowHeight = 65
    }
}
