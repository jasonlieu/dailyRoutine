//
//  DayViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/23/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit
import SQLite3

class DayViewController: UITableViewController{
    var dayOfWeek: String!
    var displayedDay : Day!
    var db: OpaquePointer?
    var queryString : String!
    /*let colors : [UIColor] = [
     //+15
     UIColor(displayP3Red: 225/255, green: 193/255, blue: 193/255, alpha: 1),
     UIColor(displayP3Red: 128/255, green: 233/255, blue: 242/255, alpha: 1),
     UIColor(displayP3Red: 225/255, green: 255/255, blue: 221/255, alpha: 1),
     UIColor(displayP3Red: 225/255, green: 255/255, blue: 221/255, alpha: 1),
     UIColor(displayP3Red: 225/255, green: 255/255, blue: 221/255, alpha: 1),
     UIColor(displayP3Red: 225/255, green: 255/255, blue: 221/255, alpha: 1), //sat
     UIColor(displayP3Red: 283/255, green: 255/255, blue: 233/255, alpha: 1)  //sun
     ]*/
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
        let hour = task.time/100 < 1 ? "12" : task.time/100 > 12 ? String ((task.time/100) - 12): String(task.time/100)
        let AMorPM = task.time > 1200 ? " PM" : " AM"
        cell.timeLabel.text = hour + ":" + minute + AMorPM
        
        return cell
    }
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = displayedDay.schedule[indexPath.row]
            self.displayedDay.removeTask(task: task)
            let weekday = Calendar.current.component(.weekday, from: Date())
            let name = task.name
            let time = task.time
            if ((task.day + 2) % 7) == weekday {
                let deleteToday = "DELETE FROM Today WHERE name = '" + name + "' AND time = '" + String(time) + "'"
                sqlite3_exec(db, deleteToday, nil, nil, nil)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //remove from DB
            var delete : OpaquePointer?
            let deleteQuery = "DELETE FROM " + dayOfWeek + " WHERE name = ? AND time = ?"
            if sqlite3_prepare_v2(db, deleteQuery, -1, &delete, nil) == SQLITE_OK {
                if sqlite3_bind_text(delete, 1, name, -1, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                if sqlite3_bind_int(delete, 2, Int32(time)) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                if sqlite3_step(delete) == SQLITE_DONE {
                    print(task.name + " deleted")
                } else {
                    print("delete failed")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
        }
    }
    func handleDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ScheduleDatabase.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    func loadFromDB(){
        var get : OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &get, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        while sqlite3_step(get) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(get, 1))
            let time = sqlite3_column_int(get, 2)
            let day = dayOfWeek == "Monday" ? 0 : dayOfWeek == "Tuesday" ? 1 : dayOfWeek == "Wednesday" ? 2 : dayOfWeek == "Thursday" ? 3 : dayOfWeek == "Friday" ? 4 : dayOfWeek == "Saturday" ? 5 : 6
            displayedDay.addTask(newTask: Task(name: name, day: day, time: Int(time)))
        }
        tableView.reloadData()
    }
    func addTask(task: Task){
        displayedDay.addTask(newTask: task)
        tableView.reloadData()
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let barHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let sumHeight = barHeight + navHeight
        let insets = UIEdgeInsets(top: sumHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 240/255, alpha: 1)
        tableView.tableFooterView = UIView()
        handleDB()
        loadFromDB()
        setEditing(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let barHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = self.navigationController?.navigationBar.bounds.height
        let sumHeight = barHeight + navHeight!
        let insets = UIEdgeInsets(top: sumHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
}
