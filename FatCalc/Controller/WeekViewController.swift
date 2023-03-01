//
//  WeekViewController.swift
//  FatCalc
//
//  Created by segev perets on 28/02/2023.
//

import UIKit
import AVFoundation

let weightUpdateNotification = Notification.Name("weightUpdate")
let fatUpdateNotification = Notification.Name("fatUpdate")

class WeekViewController: UIViewController {
    
    @IBOutlet weak var completeButtonOutlet: UIButton!
    @IBOutlet weak var sundayButton : UIButton!
    @IBOutlet weak var mondayButton : UIButton!
    @IBOutlet weak var tuesdayButton : UIButton!
    @IBOutlet weak var wednesdayButton : UIButton!
    @IBOutlet weak var thursdayButton : UIButton!
    @IBOutlet weak var fridayButton : UIButton!
    @IBOutlet weak var saturdayButton : UIButton!
    @IBOutlet weak var fatPercentBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeeklyWeights(_:)), name: weightUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fatUpdate(_:)), name: fatUpdateNotification, object: nil)
    }
    
    var selectedDay = ""
    
    var isFatPercentChecked : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFatPercentChecked")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFatPercentChecked")
        }
    }
    
    var weeklyWeights = [String:Bool]() ;#warning("fetch from memory")
    var isFatChecked = false ;#warning("check memory for fat this week")


    @objc private func updateWeeklyWeights (_ notification:Notification) {
     print(selectedDay+" is updated")
        let i = selectedDay
        weeklyWeights[i] = true
        print(weeklyWeights.forEach({ each in
            print("\(each.key) : \(each.value)")
        }))
        updateCheckmarks()
        checkIfWeekIsComplete()
    }
    
    
    
    private func updateCheckmarks () {
        
        for (day,_) in weeklyWeights {
            let i = Day.allCases.firstIndex(of: Day(rawValue: day)!)
                    
            switch i {
            case 0:
//                sundayButton.configuration?.background.backgroundColor = .blue
                sundayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 1:
//                mondayButton.configuration?.background.backgroundColor = .blue
                mondayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 2:
//                tuesdayButton.configuration?.background.backgroundColor = .blue
                tuesdayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 3:
//                wednesdayButton.configuration?.background.backgroundColor = .blue
                wednesdayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 4:
//                thursdayButton.configuration?.background.backgroundColor = .blue
                thursdayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 5:
//                fridayButton.configuration?.background.backgroundColor = .blue
                fridayButton.configuration?.image = UIImage(systemName: "checkmark")
            case 6:
//                saturdayButton.configuration?.background.backgroundColor = .blue
                saturdayButton.configuration?.image = UIImage(systemName: "checkmark")
            default:
                fatalError("missed one")
            }
            
        }

    }
    
    
    @IBAction func checkmarkPressed(_ sender: UIButton) {
        
//            sender.setImage(UIImage(systemName: "checkmark"), for: .selected)
        
        switch sender.tag {
        case 0:
            selectedDay = Day.allCases[0].rawValue
        case 1:
            selectedDay = Day.allCases[1].rawValue
        case 2:
            selectedDay = Day.allCases[2].rawValue
        case 3:
            selectedDay = Day.allCases[3].rawValue
        case 4:
            selectedDay = Day.allCases[4].rawValue
        case 5:
            selectedDay = Day.allCases[5].rawValue
        case 6:
            selectedDay = Day.allCases[6].rawValue
        default:
            fatalError()
        }
        
        performSegue(withIdentifier: "toWeight", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toWeight" {
            let destinationVC = segue.destination as! WeightViewController
            destinationVC.title = selectedDay
        } else if segue.identifier == "toFat" {
            
        }
    }
    
    @objc private func fatUpdate(_ notification:Notification) {
        let fatPercent = notification.object as! Float
        
        print("\(Int(fatPercent))%")
            
        fatPercentBox.configuration?.background.image = UIImage(systemName: "checkmark")
        isFatPercentChecked = true
        checkIfWeekIsComplete()
    }
    
    private func checkIfWeekIsComplete () {
        
        let isComplete = weeklyWeights.count >= 3 && isFatPercentChecked
        
        if isComplete {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            UIView.animate(withDuration: 0.3) {
                self.completeButtonOutlet.alpha = 1
            }
            
        }
        
        
    }
    
    enum Day : String, CaseIterable {
        case Sunday = "Sunday"
        case Monday = "Monday"
        case Tuesday = "Tuesday"
        case Wednesday = "Wednesday"
        case Thursday = "Thursday"
        case Friday = "Friday"
        case Saturday = "Saturday"
    }
}

