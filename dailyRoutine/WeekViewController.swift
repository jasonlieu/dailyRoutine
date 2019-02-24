//
//  WeekViewController.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/23/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit

class WeekViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    lazy var daysViewController: [UIViewController] = {
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
        let currentIndex = daysViewController.index(of: viewController)!
        if  currentIndex <= 0{
            return nil
        }
        return daysViewController[currentIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = daysViewController.index(of: viewController)!
        if  currentIndex >= daysViewController.count - 1 {
            return nil
        }
        return daysViewController[currentIndex + 1]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let weekday = Calendar.current.component(.weekday, from: Date())
        let updatedWeekday = weekday == 0 ? 5 : weekday == 1 ? 6 : (weekday - 2)
        self.setViewControllers([daysViewController[updatedWeekday]], direction: .forward, animated: true, completion: nil)
    }
}
