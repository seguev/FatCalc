//
//  WeeklyWeightModel.swift
//  FatCalc
//
//  Created by segev perets on 28/11/2022.
//

import UIKit

protocol WeeklyWeightModelDelegate : UIViewController {
    func showButton ()
    func updateCheckmarks(_ day:Day)
    func checkFatBox()
    func updateTitleLabel(isDone:Bool)
}

class WeeklyWeightModel {

    weak var delegate : WeeklyWeightModelDelegate?
    
    var selectedDay = "" {didSet {print("selectedDay = \(selectedDay)")}}
        
    var isFatChecked : Bool {
        get {
            return StorageModel.shared.weeklyData.fatPercentage != nil
        }
    }
    

    
    func updateWeightEntry (_ weight:Float) {
        
        guard let day = Day(rawValue: selectedDay) else {fatalError("selected day is not updated")}
                
        StorageModel.shared.save(weightEntry: (day: selectedDay, weight: weight))
        
        delegate?.updateCheckmarks(day)
        
        checkEnoughDataToSave()
         
    }

    func checkEnoughDataToSave () {
        let updatedStorageData = StorageModel.shared.weeklyData!
        let entriesCount = updatedStorageData.weights.count
        let isFatAvailable = updatedStorageData.fatPercentage != nil
        
        let isEnough = entriesCount >= 4 && isFatAvailable
        
        if isEnough {
            let newAverage = (updatedStorageData.weights.map{$0.value}.reduce(0, +))/Float(entriesCount)
            let currentWeekNum = StorageModel.shared.currentDateComponents().weekNum
            
            CoreDataModel.shared.saveToCoreData(newAverage, fatPercentage: updatedStorageData.fatPercentage, weekNum: currentWeekNum)
            delegate?.updateTitleLabel(isDone: true)
        }
        
        
    }
    
    
    func fetchPlaceHolder (_ day:String) -> String {
         
        if let lastWeight = StorageModel.shared.weeklyData.weights[day] {
            return String(format: "%.0f", lastWeight)+"kg"
        } else {
            return "Enter your current weight"
        }
    }
    
    
    func checkSavedWeightBoxes () {
        for entry in StorageModel.shared.weeklyData.weights {
            let key = entry.key
            let day = Day(rawValue: key)!
            delegate?.updateCheckmarks(day)
        }
        
        if StorageModel.shared.weeklyData.fatPercentage != nil {
            delegate?.checkFatBox()
        }
        
        checkEnoughDataToSave()
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
