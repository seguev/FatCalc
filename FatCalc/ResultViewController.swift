//
//  ResultViewController.swift
//  FatCalc
//
//  Created by segev perets on 15/11/2022.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var result : String?
    var gender : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard result != nil else {fatalError()}
        resultLabel.text = result!+"%"
        guard let availableResult = Float(result!) else {fatalError()}
        if Float(availableResult) < 0 {
            resultLabel.text = "this is below 0. check yourself (:"
            categoryLabel.isHidden = true
            return
        }
        if gender == "Male" {
            menHealthFat()
        } else if gender == "Female" {
            womenHealthFat()
        } else {
            present(Funcs.shared.somthingsWrongAlertController(), animated: true)
            print("ERROR, gender = \(gender ?? "nil") ")
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func menHealthFat () {
        if let resultFloat = Float(result!) {
            switch resultFloat{
            case 2..<6:
                //add label Essential Fat
                view.backgroundColor = .green
                categoryLabel.text = "Essential Fat"
            case 6..<14:
                //add label Typical Athletes
                view.backgroundColor = .blue
                categoryLabel.text = "Typical Athletes"
            case 14..<18:
                //add label Fitness
                view.backgroundColor = .yellow
                categoryLabel.text = "Fitness"
            case 18..<26:
                //add label Acceptable
                view.backgroundColor = .orange
                categoryLabel.text = "Acceptable"
            case 26...:
                //add label Obese
                view.backgroundColor = .red
                categoryLabel.text = "Obese"
            default:
                view.backgroundColor = .darkGray
                categoryLabel.text = "yeah thats probably wrong, please check again..."


            }
        }
       
    }
    
    func womenHealthFat () {
        if let resultFloat = Float(result!) {
            switch resultFloat{
            case 10..<14:
                view.backgroundColor = .green
                categoryLabel.text = "Essential Fat"
            case 14..<21:
                view.backgroundColor = .blue
                categoryLabel.text = "Typical Athletes"
               
            case 21..<25:
                view.backgroundColor = .yellow
                categoryLabel.text = "Fitness"
            case 25..<32:
                view.backgroundColor = .orange
                categoryLabel.text = "Acceptable"
            case 32...:
                view.backgroundColor = .red
                categoryLabel.text = "Obese"
            default:
                view.backgroundColor = .darkGray
                categoryLabel.text = "yeah thats probably wrong, please check again..."
            }
        }
       
    }
    
    
    /*
     Essential Fat
    10–13% women
    2–5% men
    Typical Athletes
    14–20% women
    6–13% men
    Fitness (In Shape)
    21–24% women
    14–17% men
    Acceptable
    25–31% women
    18–25% men
    Obese
    32%+ women
    25%+ men
     */

}
