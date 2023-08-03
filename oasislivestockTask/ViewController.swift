//
//  ViewController.swift
//  oasislivestockTask
//
//  Created by An0nymous on 03/08/2023.
//
import CoreMotion
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblTotalStepCount: UILabel!
    
    let pedometer = CMPedometer()
    var lastRecordedDate: Date?
    var totalSteps : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startStepCounting()
    }

    func startStepCounting() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available on this device.")
            return
        }

        // Get the current date for starting the step count tracking
        let now = Date()

        pedometer.startUpdates(from: now) { [weak self] (data: CMPedometerData?, error: Error?) in
            guard let data = data, error == nil else {
                print("Error retrieving step count: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }

            DispatchQueue.main.async {
                if let stepCount = data.numberOfSteps as? Int {
                    print("Step count: \(stepCount)")
                    // Check if the date has changed
                if let lastDate = self?.lastRecordedDate,
                    Calendar.current.isDate(lastDate, inSameDayAs: Date()) == false {
                    // New day, reset totalSteps to 0
                    self?.totalSteps = 0
                   
                }
                    // Update the total steps
                    self?.totalSteps += stepCount
                    print("Total Step count: \(self?.totalSteps ?? 0)")
                    self?.lblTotalStepCount.text = "\(self?.totalSteps ?? 0)"
                    
                    // Update the last recorded date
                    self?.lastRecordedDate = Date()

                    // Check if step count is 20 and send notification
                if self?.totalSteps ?? 0 >= 20 && self?.totalSteps ?? 0 % 20 == 0 {
                        self?.sendNotification()
                    }
                }
            }
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your Step Goal!"
        content.body = "your steps count for today is 40 steps!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "stepGoalNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

