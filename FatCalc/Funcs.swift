//
//  Funcs.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import Foundation
import UIKit

class Funcs {
    static let shared = Funcs()
    
    var isLoged : Bool?
    
    var userName : String?
    
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
    
    func makeButtonRound (_ button:UIButton) {
        button.layer.cornerRadius = button.frame.height/2
    }
    
    func addGradient (firstColor:UIColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 1, alpha: 1), secondColor:UIColor =  #colorLiteral(red: 0.05490196078, green: 0.4549019608, blue: 0.9882352941, alpha: 1), view:UIView) {
        let layer = CAGradientLayer()
        let colors = [firstColor.cgColor, secondColor.cgColor]
        layer.colors = colors
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
    func calcMenBodyFat (chest:String, abdominal:String, thigh: String, age:Int) -> String? {
        if let pec = Double(chest), let abs = Double(abdominal), let leg = Double(thigh) {
            
            let sumOfFolds = pec+abs+leg
            let a = 1.10938+(-1*(0.0008267*sumOfFolds))
            let b = 0.0000016*pow(sumOfFolds,2)
            let c = 0.0002574*Double(age)
            let bodyDensity = a+b-c
            
            //bodyDensity = 1.10938–(0.0008267*sumOfFolds) + (0.0000016 x square of the sum of skinfolds) – (0.0002574 x age)
            
            return menBodyFat(bodyDensity)
        }
        return nil
    }
    
    private func menBodyFat(_ density:Double) -> String {
        let a = 495/density
        let b = Double(450)
        let bodyFat = a-b
        let resultString = String(format: "%.1f", bodyFat)
        //BodyFatPercentage = (495 / Body Density) – 450
        return resultString
    }
    
    func calcWomenBodyFat (chest:String, suprailiac:String, thigh: String, age:Int) -> String? {
        if let pec = Double(chest), let abs = Double(suprailiac), let leg = Double(thigh) {
            
            let sumOfFolds = pec+abs+leg
            let a = 1.0994921+(-1*(0.0009929*sumOfFolds))
            let b = 0.0000023*pow(sumOfFolds,2)
            let c = 0.0001392*Double(age)
            let bodyDensity = a+b-c
         /*
            Body Density = 1.0994921 – (0.0009929 x sum of skinfolds) + (0.0000023 x square of the sum of skinfolds) – (0.0001392 x age)
          */
            
            return womenBodyFat(bodyDensity)
        }
        return nil
    }
    
    private func womenBodyFat(_ density:Double) -> String {
        let a = 495/density
        let b = Double(450)
        let bodyFat = a-b
        let resultString = String(format: "%.1f", bodyFat)
        //BodyFatPercentage = (495 / Body Density) – 450
        return resultString
    }
    
    
    
}
