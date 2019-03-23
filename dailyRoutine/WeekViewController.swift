//
//  WeekViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/23/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit
import SQLite3

class WeekViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    var newTask: Task!
    var indexOfNextVC: Int!
    var db : OpaquePointer?
    
    lazy var daysViewController: [DayViewController] = {
        return[
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MondayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TuesdayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WednesdayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThursdayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FridayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaturdayViewController") as! DayViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SundayViewController") as! DayViewController
        ]
    }()
    func subViewCount(for weekView: UIPageViewController) -> Int {
        return daysViewController.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = daysViewController.index(of: viewController as! DayViewController)!
        if  currentIndex <= 0{
            return daysViewController[6]
        }
        return daysViewController[currentIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = daysViewController.index(of: viewController as! DayViewController)!
        if  currentIndex >= daysViewController.count - 1 {
            return daysViewController[0]
        }
        return daysViewController[currentIndex + 1]
    }
    func addNewTaskToDay(){
        postToDB(task: newTask)
        daysViewController[newTask.day].addTask()
        newTask.day = -1
    }
    func postToDB(task: Task){
        let weekday = Calendar.current.component(.weekday, from: Date()) == 7 ? 0 : Calendar.current.component(.weekday, from: Date())
        let name = newTask.name
        let time = newTask.time
        if ((task.day + 2) % 7) == weekday { //insert to today table if task is add to current day
            let todayQuery = "INSERT INTO Today (name, time, done) VALUES (?,?,?)"
            var insertToday : OpaquePointer?
            if sqlite3_prepare(db, todayQuery, -1, &insertToday, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insertToday: \(errmsg)")
                return
            }
            if sqlite3_bind_text(insertToday, 1, name, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            if sqlite3_bind_int(insertToday, 2, Int32(time)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding time: \(errmsg)")
                return
            }
            if sqlite3_bind_int(insertToday, 3, 0) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding done: \(errmsg)")
                return
            }
            if sqlite3_step(insertToday) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting today in WeekVC: \(errmsg)")
                return
            }
        }
        let queryString = prepareQuery(task: task)
        
        var insert : OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &insert, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(insert, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_int(insert, 2, Int32(time)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding time: \(errmsg)")
            return
        }
        if sqlite3_bind_int(insert, 3, Int32(task.repeatTask)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding time: \(errmsg)")
            return
        }
        if sqlite3_step(insert) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting WEEKVIEWDB: \(errmsg)")
            return
        }
    }
    func prepareQuery(task: Task) -> String{
        let day: String = task.day == 0 ? "Monday" : task.day == 1 ? "Tuesday" : task.day == 2 ? "Wednesday" : task.day == 3 ? "Thursday" : task.day == 4 ? "Friday" : task.day == 5 ? "Saturday" : "Sunday"
        return "INSERT INTO " + day + " (name, time, rep) VALUES (?,?,?)"
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        indexOfNextVC = daysViewController.index(of: pendingViewControllers[0] as! DayViewController)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed {
            navigationItem.title = daysViewController[indexOfNextVC].dayOfWeek
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showAddTask"?:
            newTask = Task(name: "temp", day: -1, time: 0)
            let addTaskVC = segue.destination as! AddTaskViewController
            addTaskVC.newTask = newTask
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    func handleDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ScheduleDatabase.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let weekday = Calendar.current.component(.weekday, from: Date())
        let updatedWeekday = weekday == 0 ? 5 : weekday == 1 ? 6 : (weekday - 2)
        for days in daysViewController {
            let index = daysViewController.index(of: days)
            days.dayOfWeek = index == 0 ? "Monday" : index == 1 ? "Tuesday" : index == 2 ? "Wednesday" : index == 3 ? "Thursday" : index == 4 ? "Friday" : index == 5 ? "Saturday" : "Sunday"
            days.queryString = "SELECT * FROM " + days.dayOfWeek
            days.displayedDay = Day()
            //days.tableView.backgroundColor = colors[index!]
        }
        self.setViewControllers([daysViewController[updatedWeekday]], direction: .forward, animated: true, completion: nil)
        navigationItem.title = daysViewController[updatedWeekday].dayOfWeek
        handleDB()
        newTask = Task(name: "temp", day: -1, time: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if newTask.day != -1 {
            addNewTaskToDay()
        }
    }
}
