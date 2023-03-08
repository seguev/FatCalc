//
//  WeekViewController.swift
//  FatCalc
//
//  Created by segev perets on 28/02/2023.
//

import UIKit
import AVFoundation

let weightUpdateNotification = Notification.Name("weightUpdate")
let fatUpdateNotification = Notification.Name("fatUpdate")

class WeekViewController: UIViewController , WeeklyWeightModelDelegate {
    
    @IBOutlet var todayArrow: UIImageView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var completeButtonOutlet: UIButton!
    @IBOutlet weak var sundayButton : UIButton!
    @IBOutlet weak var mondayButton : UIButton!
    @IBOutlet weak var tuesdayButton : UIButton!
    @IBOutlet weak var wednesdayButton : UIButton!
    @IBOutlet weak var thursdayButton : UIButton!
    @IBOutlet weak var fridayButton : UIButton!
    @IBOutlet weak var saturdayButton : UIButton!
    @IBOutlet weak var fatPercentBox: UIButton!
    var infoLabel : UILabel?
    
    let model = WeeklyWeightModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addGradient(view: view)

        updateTitleLabel(isDone: false)
        
        model.delegate = self
        
        observersSetup()
        
        model.checkSavedWeightBoxes()
        
        todayArraySetup()
    }
    
    private func observersSetup () {
        NotificationCenter.default.addObserver(self, selector: #selector(saveNewWeight(_:)), name: weightUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fatUpdate(_:)), name: fatUpdateNotification, object: nil)
        
    }
    
    private func todayArraySetup () {
        
        todayArrow.tintColor =  #colorLiteral(red: 0.3960784314, green: 0.3647058824, blue: 0.7333333333, alpha: 1)
        todayArrow.frame = .init(origin: .zero, size: .init(width: 25, height: 25))
        todayArrow.transform = .init(rotationAngle: .pi / 2)
        view.addSubview(todayArrow)

        let buttonsSuperView = sundayButton.superview
        let halfButtonHeight = sundayButton.frame.height / 2
        
        var f : CGRect?
        
        switch model.today {
        case .Sunday:
            f = view.convert(sundayButton.frame, from: buttonsSuperView)
        case .Monday:
            f = view.convert(mondayButton.frame, from: buttonsSuperView)
        case .Tuesday:
            f = view.convert(tuesdayButton.frame, from: buttonsSuperView)
        case .Wednesday:
            f = view.convert(wednesdayButton.frame, from: buttonsSuperView)
        case .Thursday:
            f = view.convert(thursdayButton.frame, from: buttonsSuperView)
        case .Friday:
            f = view.convert(fridayButton.frame, from: buttonsSuperView)
        case .Saturday:
            f = view.convert(saturdayButton.frame, from: buttonsSuperView)
        }
        
        todayArrow.center.y = f!.maxY + halfButtonHeight
        todayArrow.center.x = f!.maxX - halfButtonHeight
    }
    
    /**
     Being called when user sets weight .
     */
    @objc private func saveNewWeight (_ notification:Notification) {
        guard let updatedWeight = notification.object as? Float else {fatalError()}
        
        model.updateWeightEntry (updatedWeight)
    }
    
    /**
     Being called from model after saveNewWeight()
     */
    func updateCheckmarks (_ day:Day) {
        
            switch day {
            case .Sunday:
                sundayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
            case .Monday:
                mondayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
                
            case .Tuesday:
                tuesdayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
                
            case .Wednesday:
                wednesdayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
                
            case .Thursday:
                thursdayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
                
            case .Friday:
                fridayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
                
            case .Saturday:
                saturdayButton.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
            }


    }
    
    /**
     Being called from model when theres 4 weight entries and 1 fat entry .
     */
    func showButton () {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        UIView.animate(withDuration: 0.3) {
            self.completeButtonOutlet.alpha = 1
        }
    }
    
    
    @IBAction func checkmarkPressed(_ sender: UIButton) {
        
//            sender.setImage(UIImage(systemName: "checkmark"), for: .selected)
        
        switch sender.tag {
        case 0:
            model.selectedDay = Day.allCases[0].rawValue
        case 1:
            model.selectedDay = Day.allCases[1].rawValue
        case 2:
            model.selectedDay = Day.allCases[2].rawValue
        case 3:
            model.selectedDay = Day.allCases[3].rawValue
        case 4:
            model.selectedDay = Day.allCases[4].rawValue
        case 5:
            model.selectedDay = Day.allCases[5].rawValue
        case 6:
            model.selectedDay = Day.allCases[6].rawValue
        default:
            fatalError()
        }
        
        performSegue(withIdentifier: "toWeight", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toWeight" {
            let destinationVC = segue.destination as! WeightViewController
            destinationVC.title = model.selectedDay
        } else if segue.identifier == "toFat" {
            //prepare fat segue if needed..
        }
    }
    
    @objc private func fatUpdate(_ notification:Notification) {
        let fatPercent = notification.object as! Float
        
        StorageModel.shared.save(fat: fatPercent)
        
        checkFatBox()
        
        model.checkEnoughDataToSave()
    }
    
    func checkFatBox () {
        fatPercentBox.configuration?.background.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
    }

    func updateTitleLabel (isDone:Bool) {
        let weekNum = StorageModel.shared.currentDateComponents().weekNum
        
        if isDone {
            weekNumberLabel.text = "Week number : \(weekNum) ✔"
        } else {
            weekNumberLabel.text = "Week number : \(weekNum)"
        }
    }
    
    @IBAction func infoPressed(_ sender: UIBarButtonItem) {
        infoLabel?.removeFromSuperview()
        let i = Info()
        infoLabel = i.showInfoLabel(view, text: i.weeklyWeightInfo)
    }
    
}

