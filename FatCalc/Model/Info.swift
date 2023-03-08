//
//  Info.swift
//  FatCalc
//
//  Created by segev perets on 06/03/2023.
//

import UIKit

struct Info {
    
     let tapeInfo = "All measurements should be taken at their widest points and should be recorded in centimeters"
    
    /**
     - Chest: diagonal fold half the distance between anterior axillary line and the nipple.
     - Abdominal: vertical fold 2cm to the right of the navel.
     - Thigh: midpoint of the anterior side of the upper leg between the patella and top of thigh.
     */
     let caliperMaleInfo =
                                (Chest: "diagonal fold half the distance between anterior axillary line and the nipple.",
                                Abdominal: "vertical fold 2cm to the right of the navel.",
                                Thigh: "midpoint of the anterior side of the upper leg between the patella and top of thigh.")
                                
    
    /*(Chest:"diagonal fold half the distance between anterior axillary line and the nipple.",
                                  Abdominal:"vertical fold 2cm to the right of the navel.",
                                  Thigh:"midpoint of the anterior side of the upper leg between the patella and top of thigh.")
     */
    
    
/**
 - Tricep: vertical fold at the midpoint of the posterior side of tricep between shoulder and elbow with arm relaxed at the side.
 - Suprailiac: diagonal fold parallel and superior to the iliac crest.
 - Thigh: midpoint of the anterior side of the upper leg between the patella and top of thigh.
 */
     let caliperFemaleInfo =
                                 (Tricep: "vertical fold at the midpoint of the posterior side of tricep between shoulder and elbow with arm relaxed at the side.",
                                 Suprailiac: "diagonal fold parallel and superior to the iliac crest.",
                                 Thigh: "midpoint of the anterior side of the upper leg between the patella and top of thigh.")
                                
    let weeklyWeightInfo = "You need to log your weight for a minimum of 4 days and measure your fat percentage at least once per week."
    
    func showInfoLabel (_ view:UIView, text:String) -> UILabel {
        let infoLabel = UILabel(frame: .init(origin: .zero, size: .init(width: 300, height: 120)))
        infoLabel.backgroundColor = #colorLiteral(red: 0.9250000119, green: 0.9010000229, blue: 1, alpha: 1)
        infoLabel.numberOfLines = 0
        infoLabel.layer.cornerRadius = 15
        infoLabel.alpha = 1
        infoLabel.textColor = #colorLiteral(red: 0.2431372549, green: 0.3294117647, blue: 0.6745098039, alpha: 1)
        infoLabel.textAlignment = .center
        infoLabel.clipsToBounds = true
        infoLabel.center = .init(x: view.center.x, y: view.center.y + 50)
        infoLabel.text = text
        view.addSubview(infoLabel)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            infoLabel.removeFromSuperview()
        }
        return infoLabel
    }
}
enum InfoType {
    case tapeInfo
    case caliperMaleInfo
    case caliperFemaleInfo
}
