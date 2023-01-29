//
//  Calculator.swift
//  FatCalc
//
//  Created by segev perets on 29/01/2023.
//

import Foundation

struct Calculator {
    static let shared = Calculator()
    
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
