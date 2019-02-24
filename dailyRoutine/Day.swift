//
//  Day.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit
class Day: NSObject{
    var schedule = [Task]()
    func addTask(task: Task) -> Task{
        for currentTask in schedule{
            if currentTask.time < task.time {
                continue
            }
            schedule.insert(task, at: schedule.index(of: currentTask)!) //add new task
            return task
        }
        schedule.append(task) //latest item, append at end
        return task
    }
    func removeTask(task: Task) -> Task{
        if let index = schedule.index(of: task){
            schedule.remove(at: index)
        }
        return task
    }
}
