//
//  Day.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//

import UIKit
class Day {
    var schedule = [Task]()
    func addTask(newTask: Task){
        for currentTask in schedule{
            if currentTask.time < newTask.time {
                continue
            }
            schedule.insert(newTask, at: schedule.index(of: currentTask)!) //add new task
            return
        }
        schedule.append(newTask) //latest item, append at end
        return
    }
    func removeTask(task: Task) {
        if let index = schedule.index(of: task){
            schedule.remove(at: index)
        }
        return
    }
    
    //init(){
        //let tempTask = Task(name: "test", day: 1, time: 100)
        //schedule.append(tempTask)
    //}
}
