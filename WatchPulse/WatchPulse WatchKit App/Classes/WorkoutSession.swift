//
//  WorkoutSession.swift
//  WatchPulse WatchKit App
//
//  Created by GT on 02.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class WorkoutSession
{
    private (set) var startDate: Date!
    private (set) var endDate: Date!
    
    var state: HKWorkoutSessionState = .notStarted
    
    var intervals = [5]
    
    func start() {
        startDate = Date()
        state = .running
    }
    
    func end() {
        endDate = Date()
//        addNewInterval()
        state = .ended
    }
    
    func clear() {
        startDate = nil
        endDate = nil
        state = .notStarted
        intervals.removeAll()
    }
    
//    private func addNewInterval() {
//        let interval = PrancerciseWorkoutInterval(start: startDate,
//                                                  end: endDate)
//        intervals.append(interval)
//    }
//
//    var completeWorkout: PrancerciseWorkout? {
//
//        get {
//
//            guard state == .ended,
//                intervals.count > 0 else {
//                    return nil
//            }
//
//            return PrancerciseWorkout(with: intervals)
//        }
//    }
}
