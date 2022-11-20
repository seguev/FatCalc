//
//  Funcs.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import Foundation
import UIKit
import CoreData

class Funcs {
    static let shared = Funcs()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /*var isLoged : Bool?
    
    var userName : String?
    */
    func fetchNameFromCurrent (_ controller:UIViewController) -> String {
        switch controller.tabBarItem.tag {
        case 1:
            return "main"
        case 2:
            return "fat"
        case 3:
            return "weight"
        case 4:
            return "photos"
        default:
            return "mmm I dunno' this one"
        }
    }
    
    
    
    func fechNameFromInt (_ tagNum:Int) -> String {
        switch tagNum {
        case 1:
            return "main"
        case 2:
            return "fat"
        case 3:
            return "weight"
        case 4:
            return "photos"
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
        button.layer.cornerRadius = 4
    }
    
    func addGradient (firstColor:UIColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 1, alpha: 1), secondColor:UIColor =  #colorLiteral(red: 0.05490196078, green: 0.4549019608, blue: 0.9882352941, alpha: 1), view:UIView) {
        let layer = CAGradientLayer()
        let colors = [firstColor.cgColor, secondColor.cgColor]
        layer.colors = colors
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        layer.frame = view.frame
        
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
    func calcMenBodyFat (age:String, chest:String, abdominal:String, thigh: String) -> String? {
        if let pec = Double(chest), let abs = Double(abdominal), let leg = Double(thigh), let doubledAge = Double(age) {
            
            let sumOfFolds = pec+abs+leg
            let a = 1.10938+(-1*(0.0008267*sumOfFolds))
            let b = 0.0000016*pow(sumOfFolds,2)
            let c = 0.0002574*Double(doubledAge)
            let bodyDensity = a+b-c
            
            //bodyDensity = 1.10938–(0.0008267*sumOfFolds) + (0.0000016 x square of the sum of skinfolds) – (0.0002574 x age)
            
            return calcBodyDensity(bodyDensity)
        }
        print(#function+" failed")
        return nil
    }
    
    private func calcBodyDensity(_ density:Double) -> String {
        let a = 495/density
        let b = Double(450)
        let bodyFat = a-b
        let resultString = String(format: "%.1f", bodyFat)
        //BodyFatPercentage = (495 / Body Density) – 450
        return resultString
    }
   
    func calcWomenBodyFat (age:String, triceps:String, suprailiac:String, thigh: String) -> String? {
        if let pec = Double(triceps), let abs = Double(suprailiac), let leg = Double(thigh), let doubledAge = Double(age) {
            
            let sumOfFolds = pec+abs+leg
            let a = 1.0994921+(-1*(0.0009929*sumOfFolds))
            let b = 0.0000023*pow(sumOfFolds,2)
            let c = 0.0001392*Double(doubledAge)
            let bodyDensity = a+b-c
         /*
            Body Density = 1.0994921 – (0.0009929 x sum of skinfolds) + (0.0000023 x square of the sum of skinfolds) – (0.0001392 x age)
          */
            
            return calcBodyDensity(bodyDensity)
        }
        print(#function+" failed")
        return nil
    }
    
    func saveToCoreData (_ weight:Float?, fatPercentage:Float?) {
        //1. check if theres another entry at this date
        //if not, create new entry
        //if available, add to existing entry
        
        
        //create new entry when saving data
        let newEntry = Entry(context: context)
        newEntry.date = Date()
        
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
    
    func loadFromCoreData () -> [Entry]? {
        do {
            return try context.fetch(NSFetchRequest<Entry>(entityName: "Entry"))
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
    
    func tapeFatCalcWomen (age: String, hips:String ,thigh:String ,calf:String ,wrist:String) -> String? {
        print("\(#function)")
        let toInches : Float = 0.393700787
        if var a = Float(age), var b = Float(hips), var c = Float(thigh), var d = Float(calf), var e = Float(wrist) {
            a = a * toInches
            b = b * toInches
            c = c * toInches
            d = d * toInches
            e = e * toInches
            print("success")
            if a <= 30 {
                let bodyFat = b + (0.8*c) - (2*d) - e
                let bodyString = String(format: "%.1f", bodyFat)
                return bodyString
            } else if a > 30 {
                let bodyFat = b + c - (2*d) - e
                let bodyString = String(format: "%.1f", bodyFat)
                return bodyString
            }
        } else {print(#function)}
        print("ERROR \(#function) failed")
        return nil
    }
    
    func tapeFatCalcMen (age:String, hips:String ,waist:String ,forearm:String ,wrist:String) -> String? {
        print("\(#function)")
        let toInches : Float = 0.393700787

        if var a = Float(age), var b = Float(hips), var c = Float(waist), var d = Float(forearm), var e = Float(wrist) {
            a = a * toInches
            b = b * toInches
            c = c * toInches
            d = d * toInches
            e = e * toInches
            print("success")
            if a <= 30 {
                let bodyFat = c + (0.5*b) - (3*d) - e
                let bodyString = String(format: "%.1f", bodyFat)
                return bodyString
                
            } else if a > 30 {
                    let bodyFat = c + (0.5*b) - (2.7*d) - e
                    let bodyString = String(format: "%.1f", bodyFat)
                    return bodyString
                    
                }
        }
        print("ERROR \(#function) failed")
        return nil
    }
    
   
    /*
     Covert Bailey Method
     women
     A) Hips, B) Thigh, C) Calf, D) Wrist
     Fat% = A+0.8B - 2C - D (for women 30 years old or younger)
     Fat% = A+ B - 2C - D (for women over age 30)
     men
     A) Hips, B) Waist, C) Forearm Circumference, and D) Wrist.
     Fat% = B + 0.5A - 3C - D (for men 30 years old or younger)
     Fat% = B + 0.5A - 2.7C - D (for men over age 30)
     
     
     
     All measurements should be taken at their widest points and should be recorded in inches.
     */
}
