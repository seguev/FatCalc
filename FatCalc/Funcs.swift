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
 
    
    
    
    
    
}
