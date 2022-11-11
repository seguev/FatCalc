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
    
    func addGradient (firstColor:UIColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 1, alpha: 1), secondColor:UIColor =  #colorLiteral(red: 0.05490196078, green: 0.4549019608, blue: 0.9882352941, alpha: 1), view:UIView) {
        let layer = CAGradientLayer()
        let colors = [firstColor.cgColor, secondColor.cgColor]
        layer.colors = colors
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
    
}
