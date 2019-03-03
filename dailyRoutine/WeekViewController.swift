//
//  WeekViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/23/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class WeekViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    var newTaskWaiting: Bool = false
    var newTask: Task!
    var addToDay: Int = 0
    
    
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
        print("WeekView addTask")
        //let newTaskTest = Task(name: newTaskName, day: addToDay, time: newTaskTime)
        daysViewController[addToDay].addTask(task: newTask)
        newTaskWaiting = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let weekday = Calendar.current.component(.weekday, from: Date())
        let updatedWeekday = weekday == 0 ? 5 : weekday == 1 ? 6 : (weekday - 2)
        self.setViewControllers([daysViewController[updatedWeekday]], direction: .forward, animated: true, completion: nil)
        for days in daysViewController {
            days.displayedDay = Day()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if newTaskWaiting {
            addNewTaskToDay()
        }
    }
}
