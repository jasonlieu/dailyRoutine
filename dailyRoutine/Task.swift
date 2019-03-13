//
//  Task.swift
//  dailyRoutine
//
//  Created by Jason Lieu on 2/21/19.
//  Copyright © 2019 JasonApplication. All rights reserved.
//
import UIKit
class Task: NSObject{
    var name: String
    var day: Int
    var time: Int
    var done: Int = 0
    init(name: String, day: Int, time: Int){
        self.name = name
        self.day = day
        self.time = time
        super.init()
    }
    func check(){
        if done == 0 {
            done = 1
        }
        else {
            done = 0
        }
    }
}
