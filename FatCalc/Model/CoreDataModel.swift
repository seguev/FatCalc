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
    
    
    
    /*
     add saving photo function to core data
     */
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /*var isLoged : Bool?
    
    var userName : String?
    */
    func fetchNameFromCurrent (_ controller:UIViewController) -> String {
        switch controller.tabBarItem.tag {
        case 1:
            return "Main"
        case 2:
            return "Graph"
        case 3:
            return "Album"
        default:
            return "mmm I dunno' this one"
        }
    }
    
    
    
    func fetchNameFromInt (_ tagNum:Int) -> String {
        switch tagNum {
        case 1:
            return "Main"
        case 2:
            return "Graph"
        case 3:
            return "Album"
        default:
            return "mmm I dunno' this one"
        }
    }
 
    
     func comingSoonAlertController () -> UIViewController {
       let alert = UIAlertController(title: "Coming Soon!", message: "this content isn't ready yet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(action)
       
        return alert
   }
    
    func somthingsWrongAlertController () -> UIViewController {
      let alert = UIAlertController(title: "oops!", message: "something's went wrong, please fill everything and try again", preferredStyle: .alert)
       let action = UIAlertAction(title: "OK, sorry", style: .cancel)
       alert.addAction(action)
      
       return alert
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
    

    func saveToCoreData (_ weight:Float?, fatPercentage:Float?) {
        //1. check if theres another entry at this date
        //if not, create new entry
        //if available, add to existing entry
        
        
        //create new entry when saving data
        let newEntry = Entry(context: context)
        newEntry.date = Date().formatted(date: .abbreviated, time: .omitted)
        
        //if weight is being saved
        if let weightSaving = weight {
            newEntry.weight = weightSaving //save new weight inside new entry
        } else {print("No weight to save")}
        
        if let fatSaving = fatPercentage {
            newEntry.fatPercentage = fatSaving //save new fat inside new entry
        } else {print("No fat to save")}
        
        do {
            try context.save()
            print("New entry has been saved!")
        } catch {
            print("Saving Failed! : \(error)")
        }
    }
    
    /*func saveImageToCoreData (_ image:UIImage?) {
        if let pngImage = image?.pngData() {
            newEntry.image = pngImage
            let entityName =  NSEntityDescription.entity(forEntityName: "Entry", in: context)!
            let image = NSManagedObject(entity: entityName, insertInto: context)
            image.setValue(pngImage, forKeyPath: "image")
        } else {
            print("could not convert image to png. did not save!")
        }
    }*/
    
    func loadFromCoreData (with predicate:NSPredicate? = nil) -> [Entry]? {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        if let pred = predicate {
            request.predicate = pred
        }
        do {
            return try context.fetch(request)
        } catch {
            print("ERROR while \(#function): \(error)")
        }
        print("no data available, returning nil")
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
    
    func updateWeight(_ entry:Entry, to newWeight:Float) {
        do {
            entry.weight = newWeight
            try context.save()
        } catch {
            print(error)
        }
    }
    
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
    
   }
