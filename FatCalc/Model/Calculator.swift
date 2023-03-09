//
//  Calculator.swift
//  FatCalc
//
//  Created by segev perets on 29/01/2023.
//

import Foundation

struct Calculator {
    static let shared = Calculator()
    

    /**
     % Body Fat = (495 / Body Density) - 450.
     */
    private func bodyDensityToFatPercentage(_ density:Double) -> String {
        
        let r = (495 / density) - 450

        return String(format: "%.1f", r)
    }
    
    /**
     bodyDensity = 1.10938–(0.0008267*sumOfFolds) + (0.0000016 x square of the sum of skinfolds) – (0.0002574 x age)
     */
    func calcMenBodyFat (age:String, chest:String, abdominal:String, thigh: String) -> String? {
        if let chest = Double(chest), let abdominal = Double(abdominal), let thigh = Double(thigh) {
            
            let sus = [chest,abdominal,thigh].reduce(0, +)

            let bd = 1.10938 + (-1*(0.0008267 * sus)) + (0.0000016 * pow(sus, 2)) + ( -1 * (0.0002574 * Double(age)!))

            return bodyDensityToFatPercentage(bd)
        }
        print(#function+" failed")
        return nil
    }
    

    /**
       Body Density = 1.0994921 – (0.0009929 x sum of skinfolds) + (0.0000023 x square of the sum of skinfolds) – (0.0001392 x age)
     */
    func calcWomenBodyFat (age:String, triceps:String, suprailiac:String, thigh: String) -> String? {
        if let triceps = Double(triceps), let suprailiac = Double(suprailiac), let thigh = Double(thigh) {
            
            let sus = [triceps,suprailiac,thigh].reduce(0, +)
            
            let bd = 1.0994921 + (-1*(0.0009929 * sus)) + (0.0000023 * pow(sus, 2)) + ( -1 * (0.0001392 * Double(age)!))

            return bodyDensityToFatPercentage(bd)
        }
        print(#function+" failed")
        return nil
    }
    
    /**
     A) Hips, B) Thigh, C) Calf, and D) Wrist
     Fat% = Hips+(0.8*Thigh) - (2*Calf) - Wrist (for women 30 years old or younger)
     Fat% = Hips+ Thigh - (2*Calf) - Wrist (for women over age 30)
     */
    func tapeFatCalcWomen (age: String, hips:String ,thigh:String ,calf:String ,wrist:String, system:System) -> String? {
        
        guard let age = Double(age),let hips = Double(hips),let thigh = Double(thigh),let calf = Double(calf),let wrist = Double(wrist) else {return "CouldNotConvert"}
        

        if system == .Imperial {
      
            if age <= 30 {
                let bodyFat = hips+(0.8*thigh) - (2*calf) - wrist
                
                return String(format: "%.1f", bodyFat)
                
            } else {
                    let bodyFat = hips + thigh - (2*calf) - wrist
                return String(format: "%.1f", bodyFat)
            }
        } else {
            let metricHips : Measurement<UnitLength> = .init(value: hips, unit: .centimeters).converted(to: .inches)
            let metricThigh : Measurement<UnitLength> = .init(value: thigh, unit: .centimeters).converted(to: .inches)
            let metricCalf : Measurement<UnitLength> = .init(value: calf, unit: .centimeters).converted(to: .inches)
            let metricWrist : Measurement<UnitLength> = .init(value: wrist, unit: .centimeters).converted(to: .inches)
            
            return tapeFatCalcWomen(age: age.description, hips: metricHips.value.description, thigh: metricThigh.value.description, calf: metricCalf.value.description, wrist: metricWrist.value.description, system: .Imperial)
            
        }
        
    }
    /**
     A) Hips, B) Waist, C) Forearm Circumference, and D) Wrist.
     Fat% = Waist + (0.5*Hips) - (3*Forearm) - Wrist (for men 30 years old or younger)
     Fat% = Waist + (0.5*Hips) - (2.7*Forearm) - Wrist (for men over age 30)
     */
    func tapeFatCalcMen (age:String, hips:String ,waist:String ,forearm:String ,wrist:String, system:System) -> String {
        
        guard let age = Double(age),let hips = Double(hips),let waist = Double(waist),let forearm = Double(forearm),let wrist = Double(wrist) else {return "CouldNotConvert"}
        
        if system == .Imperial {
      
            if age <= 30 {
                let bodyFat = waist + (0.5*hips) - (3*forearm) - wrist
                
                return String(format: "%.1f", bodyFat)
                
            } else {
                    let bodyFat = waist + (0.5*hips) - (2.7*forearm) - wrist
                return String(format: "%.1f", bodyFat)
            }
        } else {
            let metricHips : Measurement<UnitLength> = .init(value: hips, unit: .centimeters).converted(to: .inches)
            let metricWaist : Measurement<UnitLength> = .init(value: waist, unit: .centimeters).converted(to: .inches)
            let metricForearm : Measurement<UnitLength> = .init(value: forearm, unit: .centimeters).converted(to: .inches)
            let metricWrist : Measurement<UnitLength> = .init(value: wrist, unit: .centimeters).converted(to: .inches)
            
            return tapeFatCalcMen(age: age.description, hips: metricHips.value.description, waist: metricWaist.value.description, forearm: metricForearm.value.description, wrist: metricWrist.value.description, system: .Imperial)
            
        }
            
 
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

enum System  {
    case Metric
    case Imperial
}
