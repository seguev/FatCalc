//
//  Funcs.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataModel {
    static let shared = CoreDataModel()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveToCoreData (_ weightAverage:Float?, fatPercentage:Float?, weekNum:Int) {
        //fech all objects with current weekNum, if available update them
        //if no objects has been found, initialize new one
        let weekNum = Int16(weekNum)
        
        if let currentWeekEntry = fetchCurrentWeekEntry(weekNum) {
            if let fatPercentage {
                currentWeekEntry.fatPercentage = fatPercentage
            }
            if let weightAverage {
                currentWeekEntry.weightAverage = weightAverage
            }
            do {
                try context.save()
            } catch {
                print("Error while \(#function) : \(error). *AKA :\(error.localizedDescription)")
            }
        } else {
            //current week does not have any corresponding entries
            let newEntry = Entry(context: context)
            newEntry.weekNum = weekNum
            if let fatPercentage {
                newEntry.fatPercentage = fatPercentage
            }
            if let weightAverage {
                newEntry.weightAverage = weightAverage
            }
            do {
                try context.save()
            } catch {
                print("Error while \(#function) : \(error). *AKA :\(error.localizedDescription)")
            }        }
    }

    func fetchCurrentWeekEntry (_ weekNum:Int16) -> Entry? {
        let predicate = NSPredicate(format: "weekNum == %i", weekNum)
        guard let matchingEntries = loadFromCoreData(with: predicate), matchingEntries.count != 0 else {return nil}
        if matchingEntries.count > 1 {fatalError("(!!!) Found \(matchingEntries.count) weeks with n:\(weekNum)")}
        return matchingEntries[0]
    }
    
    func loadFromCoreData (with predicate:NSPredicate? = nil) -> [Entry]? {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        
        if let pred = predicate {
            request.predicate = pred
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while \(#function) : \(error). *AKA :\(error.localizedDescription)")        }
        return nil
    }
    
    func deleteFromCoreData (_ entry:Entry) {
        do {
            context.delete(entry)
            try context.save()
            print("New entry has been saved!")
        } catch {
            print("Saving Failed! : \(error)")
        }
    }

    
    /*
    func fetchMaxWeight () -> Double {
        let predicate = NSPredicate(format: "weight LIKE %@", "*")
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.predicate = predicate
        var weightDoubles : [Double] = []
        do {
            let weights = try context.fetch(request)
            for weight in weights {
                weightDoubles.append(Double(weight.weight))
            }
            guard let maxResult = weightDoubles.max() else {
                print(#function+"FAILED")
                return 0.0
            }
            return maxResult
        } catch {
            print(error)
        }
        print(#function+"FAILED")
        return 0.0
    }
    */
    
    
    
    
   }


func makeButtonRound (_ button:UIButton) {
    button.layer.cornerRadius = 10
    button.clipsToBounds = true
    let layer = CAGradientLayer()
    layer.frame = button.bounds
    let colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
    layer.colors = colors
    button.layer.insertSublayer(layer, at: 0)
}

func addGradient (firstColor:UIColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 1, alpha: 1), secondColor:UIColor =  #colorLiteral(red: 0.05490196078, green: 0.4549019608, blue: 0.9882352941, alpha: 1), view:UIView) {
    let layer = CAGradientLayer()
    let colors = [firstColor.cgColor, secondColor.cgColor]
    layer.colors = colors
    layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
    layer.frame = view.frame
    view.layer.insertSublayer(layer, at: 0)
    
}
