//
//  MainViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit
import SQLite3

class MainViewController: UITableViewController {
    var dailyTasks: Day!
    var db: OpaquePointer?
    var displayDay: String!
    
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
        let hour = task.time/100 < 1 ? "12" : task.time/100 > 12 ? String ((task.time/100) - 12): String(task.time/100)
        let AMorPM = task.time > 1200 ? " PM" : " AM"
        cell.timeLabel.text = hour + ":" + minute + AMorPM

        if task.done == 1 {
            cell.check.image = UIImage(named: "checkMark")
        }
        else {
            cell.check.image = nil
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dailyTasks.schedule[indexPath.row].done == 0 {
            dailyTasks.schedule[indexPath.row].check()
            let name = dailyTasks.schedule[indexPath.row].name
            let time = String(dailyTasks.schedule[indexPath.row].time)
            let updateQuery = "UPDATE Today SET done = '1' WHERE name = '" + name + "' AND time = '" + time + "'"
            sqlite3_exec(db, updateQuery, nil, nil, nil)
            tableView.reloadData()
        }
        else{
            dailyTasks.schedule[indexPath.row].check()
            let name = dailyTasks.schedule[indexPath.row].name
            let time = String(dailyTasks.schedule[indexPath.row].time)
            let updateQuery = "UPDATE Today SET done = '0' WHERE name = '" + name + "' AND time = '" + time + "'"
            sqlite3_exec(db, updateQuery, nil, nil, nil)
            tableView.reloadData()

        }
    }
    func handleDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ScheduleDatabase.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS savedDay (day INTEGER PRIMARY KEY)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Monday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Tuesday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Wednesday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Thursday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Friday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Saturday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Sunday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, rep INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        //check if savedDay has 0 entries, if so add 1
        var numRowsInSavedDay : Int = 0
        let countQuery = "SELECT COUNT(*) FROM savedDay"
        var count: OpaquePointer?
        if sqlite3_prepare(db, countQuery, -1, &count, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing count: \(errmsg)")
            return
        }
        while sqlite3_step(count) == SQLITE_ROW {
            numRowsInSavedDay = Int(sqlite3_column_int(count, 0))
        }
        if numRowsInSavedDay == 0 {
            let insertFirstEntry = "INSERT INTO savedDay (day) VALUES (?)"
            var insert : OpaquePointer?
            let weekday = Calendar.current.component(.weekday, from: Date())
            if sqlite3_prepare(db, insertFirstEntry, -1, &insert, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            if sqlite3_bind_int(insert, 1, Int32(weekday) ) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding weekdayName: \(errmsg)")
                return
            }
            if sqlite3_step(insert) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting savedDay: \(errmsg)")
                return
            }
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Today (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, time INTEGER, done INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    func beginDay(){ //load into dailyTasks and Today table
        var get : OpaquePointer?
        let queryString = "SELECT * FROM " + displayDay
        if sqlite3_prepare(db, queryString, -1, &get, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing get: \(errmsg)")
            return
        }

        while sqlite3_step(get) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(get, 1))
            let time = sqlite3_column_int(get, 2)
            let day = displayDay == "Monday" ? 0 : displayDay == "Tuesday" ? 1 : displayDay == "Wednesday" ? 2 : displayDay == "Thursday" ? 3 : displayDay == "Friday" ? 4 : displayDay == "Saturday" ? 5 : 6
            dailyTasks.addTask(newTask: Task(name: name, day: day, time: Int(time)))
        }
        //handle Today ( drop current, load into current from daily)
        sqlite3_exec(db, "DELETE FROM Today", nil, nil, nil)
        let insertString = "INSERT INTO Today (name, time, done) VALUES (?,?,?)"
        var insert : OpaquePointer?
        
        for task in dailyTasks.schedule {
            if sqlite3_prepare(db, insertString, -1, &insert, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            if sqlite3_bind_text(insert, 1, task.name, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            if sqlite3_bind_int(insert, 2, Int32(task.time)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding time: \(errmsg)")
                return
            }
            if sqlite3_bind_int(insert, 3, 0) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding done: \(errmsg)")
                return
            }
            if sqlite3_step(insert) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting into Today: \(errmsg)")
                return
            }
        }
        tableView.reloadData()
    }
    func removeTempTasks(){
        var deleteDay : Int = -1
        var get : OpaquePointer?
        let queryString = "SELECT * FROM savedDay"
        if sqlite3_prepare(db, queryString, -1, &get, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing get: \(errmsg)")
        }
        while sqlite3_step(get) == SQLITE_ROW {
            deleteDay = Int(sqlite3_column_int(get, 0))
        }
        let updatedDeleteDay = deleteDay == 0  || deleteDay == 7 ? "Saturday" : deleteDay == 1 ? "Sunday" : deleteDay == 2 ? "Monday" : deleteDay == 3 ? "Tuesday" : deleteDay == 4 ? "Wednesday" : deleteDay == 5 ? "Thursday" : "Friday"
        let deleteQuery = "DELETE FROM " + String(updatedDeleteDay) + " WHERE rep = 0"
        sqlite3_exec(db, deleteQuery, nil, nil, nil)
    }
    func loadFromDB(){
        var get : OpaquePointer?
        let queryString = "SELECT * FROM Today"
        if sqlite3_prepare(db, queryString, -1, &get, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while sqlite3_step(get) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(get, 1))
            let time = sqlite3_column_int(get, 2)
            let done = sqlite3_column_int(get, 3)
            let day = displayDay == "Monday" ? 0 : displayDay == "Tuesday" ? 1 : displayDay == "Wednesday" ? 2 : displayDay == "Thursday" ? 3 : displayDay == "Friday" ? 4 : displayDay == "Saturday" ? 5 : 6
            let task = Task(name: name, day: day, time: Int(time))
            if done == 1 {
                task.check()
            }
            dailyTasks.addTask(newTask: task)
        }
        tableView.reloadData()
    }
    func checkNewDay() -> Bool{ //T if NOT new day
        var savedDay : Int = -1
        let weekday = Calendar.current.component(.weekday, from: Date()) == 7 ? 0 : Calendar.current.component(.weekday, from: Date())
        var get : OpaquePointer?
        let queryString = "SELECT * FROM savedDay"
        if sqlite3_prepare(db, queryString, -1, &get, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing get: \(errmsg)")
        }
        while sqlite3_step(get) == SQLITE_ROW {
            savedDay = Int(sqlite3_column_int(get, 0))
        }
        if savedDay == weekday {
            return true
        }
        else{
            return false
        }
    }
    func updateSavedDay(){
        let weekday = Calendar.current.component(.weekday, from: Date()) == 7 ? 0 : Calendar.current.component(.weekday, from: Date())
        sqlite3_exec(db, "UPDATE savedDay SET day = " + String(weekday), nil, nil, nil)
    }
    func wipe(){ //testing purposes
        sqlite3_exec(db, "DROP TABLE Monday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Tuesday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Wednesday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Thursday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Friday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Saturday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Sunday", nil, nil, nil)
        sqlite3_exec(db, "DROP TABLE Today", nil, nil, nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekday = Calendar.current.component(.weekday, from: Date())
        displayDay = weekday == 0  || weekday == 7 ? "Saturday" : weekday == 1 ? "Sunday" : weekday == 2 ? "Monday" : weekday == 3 ? "Tuesday" : weekday == 4 ? "Wednesday" : weekday == 5 ? "Thursday" : "Friday"
        navigationItem.title = displayDay
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 240/255, alpha: 1)
        tableView.tableFooterView = UIView()
        handleDB()
        //wipe()
        if !checkNewDay(){
            beginDay()
            removeTempTasks()
            updateSavedDay()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        dailyTasks = Day()
        let weekday = Calendar.current.component(.weekday, from: Date())
        displayDay = weekday == 0  || weekday == 7 ? "Saturday" : weekday == 1 ? "Sunday" : weekday == 2 ? "Monday" : weekday == 3 ? "Tuesday" : weekday == 4 ? "Wednesday" : weekday == 5 ? "Thursday" : "Friday"
        loadFromDB()
        //tableView.reloadData()
    }
}
