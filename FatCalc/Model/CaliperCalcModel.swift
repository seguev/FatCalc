//
//  CaliperCalcModel.swift
//  FatCalc
//
//  Created by segev perets on 28/11/2022.
//

import Foundation

struct CaliperCalcModel {
    
    var age : String?
    var genderUniqueFold : String?
    var abdominalFold : String?
    var thighFold : String?
    var weight: String?
    var fatPercentage: String?
    var gender : Gender = .Male
    enum Gender {
        case Female
        case Male
    }
    
    
}
