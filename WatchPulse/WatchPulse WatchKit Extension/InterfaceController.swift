//
//  InterfaceController.swift
//  WatchPulse WatchKit Extension
//
//  Created by GT on 01.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController
{
    @IBOutlet var l_title: WKInterfaceLabel!
    @IBOutlet var l_current: WKInterfaceLabel!
    @IBOutlet var l_avg: WKInterfaceLabel!
    @IBOutlet var l_max: WKInterfaceLabel!
    @IBOutlet var i_heart: WKInterfaceImage!
    @IBOutlet var l_samplesCount: WKInterfaceLabel!
    @IBOutlet var l_time: WKInterfaceLabel!
    
    private let healthStore = HKHealthStore()
    private let newHKW = WorkoutSession()
    private var heartrateRawSamples: [Int] = []
    
    private var startDate = Date()
    
    var workoutActive = false

    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    var currenQuery : HKQuery?

    var timer: Timer? = nil
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard HKHealthStore.isHealthDataAvailable() == true else
        {
            l_title.setText("Heartrate disabled")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            displayNotAllowed()
            return
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                self.displayNotAllowed()
            }
        }
        
        timerStart()
        workoutActive = false
        startBtnTapped()
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        timer!.invalidate()
    }

    func displayNotAllowed() {
        l_title.setText("Heartrate not allowed")
    }

    
    // MARK: - Actions
    @IBAction func startBtnTapped() {
        if (self.workoutActive) {
            //finish the current workout
            self.workoutActive = false
//            self.startStopButton.setTitle("Start")
            if let workout = self.session {
                healthStore.end(workout)
            }
        } else {
            //start a new workout
            self.workoutActive = true
//            self.startStopButton.setTitle("Stop")
            startWorkout()
        }
        
    }
    
    func startWorkout() {
        
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        healthStore.start(self.session!)
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery?
    {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(_ samples: [HKSample]?)
    {
        guard let heartRateQuantitySamples = samples as? [HKQuantitySample] else {return}
        
        for sample in heartRateQuantitySamples
        {
            print("Sample date: \(sample.startDate)")
            let sampleValue = sample.quantity.doubleValue(for: self.heartRateUnit)
            heartrateRawSamples.append(Int(sampleValue))
        }
        
        DispatchQueue.main.async {
            guard let sample = heartRateQuantitySamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            self.l_current.setText("\(UInt16(value))")
            
            self.l_avg.setText( "\(self.heartrateRawSamples.avg)" )
            self.l_max.setText( "\(self.heartrateRawSamples.max)" )
            
            self.l_samplesCount.setText("Ilość próbek: \(self.heartrateRawSamples.count)")
            
            // retrieve source from sample
            self.animateHeart()
        }
    }
    
    func timerStart()
    {
        if(timer == nil) // init timer
        {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in  // the `[weak self] reference is only needed if you reference `self` in the closure
                self!.timerTick()
            }
        }
        timer?.fire()
    }
    
    func timerTick()
    {
        let secondsSinceStart = Int( Date().timeIntervalSince(self.startDate) )
        let secondsAndMinutes = secondsToHoursMinutesSeconds(seconds: secondsSinceStart)
        let minutesString = String(secondsAndMinutes.minutes)
        let secondsString = String(format: "%02d", secondsAndMinutes.seconds)
        self.l_time.setText( "Czas: \(minutesString):\(secondsString)" )
    }
    
    func animateHeart()
    {
        self.animate(withDuration: 0.5)
        {
            self.i_heart.setWidth(30)
            self.i_heart.setHeight(30)
        }
        
        let when = DispatchTime.now() + Double(Int64(0.5 * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.animate(withDuration: 0.5, animations: {
                    self.i_heart.setWidth(20)
                    self.i_heart.setHeight(22)
                })            }
            
            
        }
    }
    
}

extension InterfaceController: HKWorkoutSessionDelegate
{
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    func workoutDidStart(_ date : Date)
    {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            l_title.setText("Heartrate disabled")
        }
    }
    
    func workoutDidEnd(_ date : Date)
    {
        healthStore.stop(self.currenQuery!)
        l_current.setText("---")
        session = nil
    }
}
