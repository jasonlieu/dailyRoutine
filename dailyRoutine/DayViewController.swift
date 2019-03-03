//
//  DayViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/23/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class DayViewController: UITableViewController{
    var displayedDay : Day!
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return displayedDay.schedule.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = displayedDay.schedule[indexPath.row]
        cell.nameLabel.text = task.name
        let minute = task.time%100 < 10 ? "0" + String(task.time%100) : String(task.time%100)
        let hour = task.time/100 < 1 ? "12" : String(task.time/100)
        let AMorPM = task.time > 1200 ? " PM" : " AM"
        cell.timeLabel.text = hour + ":" + minute + AMorPM
        
        return cell
    }
    func addTask(task: Task){
        displayedDay.addTask(newTask: task)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        //displayedDay = Day()
    }
}
