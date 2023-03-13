//
//  WeeklyWeightModel.swift
//  FatCalc
//
//  Created by segev perets on 28/11/2022.
//

import UIKit

protocol WeeklyWeightModelDelegate : UIViewController {

    func updateTitleLabel()
}

class WeeklyWeightModel {

    weak var delegate : WeeklyWeightModelDelegate?

    var isFatChecked : Bool {
        get {
            return StorageModel.shared.weeklyData.fatPercentage != nil
        }
    }
    
    var today : Day {
        let df = DateFormatter()
        df.locale = .init(components: .init(languageCode: .english))
        df.dateFormat = "EEEE"
        let today = df.string(from: Date())
        guard let todayDay = Day(rawValue: today) else {fatalError()}
        return todayDay
    }
    


    func checkIfEnoughForGraphUpdate () {
        let updatedStorageData = StorageModel.shared.weeklyData!
        let entriesCount = updatedStorageData.weights.count
        let isFatAvailable = updatedStorageData.fatPercentage != nil
        
        let isEnough = entriesCount >= 4 && isFatAvailable
        
        if isEnough {
            let newAverage = (updatedStorageData.weights.map{$0.value}.reduce(0, +))/Float(entriesCount)
            let currentWeekNum = StorageModel.shared.currentDateComponents().weekNum
            
            CoreDataModel.shared.saveToCoreData(newAverage, fatPercentage: updatedStorageData.fatPercentage, weekNum: currentWeekNum)
        }
        
        
    }
    
    
    func fetchPlaceHolder (_ day:String) -> String {
         
        if let lastWeight = StorageModel.shared.weeklyData.weights[day] {
            return String(format: "%.0f", lastWeight)+"kg"
        } else {
            return "Enter your current weight"
        }
    }
    
    

    
    func clickAnimation (_ button:UIButton, complition: @escaping () -> Void = {}) {
        guard !button.isHidden else {return}
        
        let currentShadowOffset = button.layer.shadowOffset
        UIView.animate(withDuration: 0.1) {
            button.layer.shadowOffset = .init(width: 0, height: 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.layer.shadowOffset = currentShadowOffset
            } completion: { _ in
                complition()
            }
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
