//
//  ResultViewController.swift
//  FatCalc
//
//  Created by segev perets on 15/11/2022.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    
    var result : String?
    var gender : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard result != nil else {fatalError()}
        resultLabel.text = result!+"%"
        if gender == "male" {
            
        } else if gender == "female" {
            
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
                resultLabel.text?.append(" Essential Fat")
            case 6..<14:
                //add label Typical Athletes
                view.backgroundColor = .blue
                resultLabel.text?.append(" Typical Athletes")
            case 14..<18:
                //add label Fitness
                view.backgroundColor = .yellow
                resultLabel.text?.append(" Fitness")
            case 18..<26:
                //add label Acceptable
                view.backgroundColor = .orange
                resultLabel.text?.append(" Acceptable")
            case 26...:
                //add label Obese
                view.backgroundColor = .red
                resultLabel.text?.append(" Obese")
            default:
                view.backgroundColor = .darkGray
                resultLabel.text?.append(" yeah thats probably wrong, please check again...")

            }
        }
       
    }
    
    func womenHealthFat () {
        if let resultFloat = Float(result!) {
            switch resultFloat{
            case 10..<14:
                view.backgroundColor = .green
                resultLabel.text?.append(" Essential Fat")
            case 14..<21:
                view.backgroundColor = .blue
                resultLabel.text?.append(" Typical Athletes")
            case 21..<25:
                view.backgroundColor = .yellow
                resultLabel.text?.append(" Fitness")
            case 25..<32:
                view.backgroundColor = .orange
                resultLabel.text?.append(" Acceptable")
            case 32...:
                view.backgroundColor = .red
                resultLabel.text?.append(" Obese")
            default:
                view.backgroundColor = .darkGray
                resultLabel.text?.append(" yeah thats probably wrong, please check again...")
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
