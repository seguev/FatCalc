//
//  CaliperCalculatorViewController.swift
//  FatCalc
//
//  Created by segev perets on 15/11/2022.
//

import UIKit

class CaliperCalculatorViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var fifthTextField: UITextField!
    
    var age : String?
    var genderUniqueFold : String?
    var abdominalFold : String?
    var thighFold : String?
    var weight: String?
    
    var fatPercentage: String?
    
    var gender : String = "Male" {
        didSet {
            print("gender setter")
            if gender == "Male" {
                print("male has been set")
                firstLabel.text = "Age"
                secondLabel.text = "Weight"
                thirdLabel.text = "Chest"
                fourthLabel.text = "Abdominal"
                fifthLabel.text = "Mid thigh"
            } else if gender == "Female" {
                print("female has been set")
                firstLabel.text = "Age"
                secondLabel.text = "Weight"
                thirdLabel.text = "Triceps"
                fourthLabel.text = "Suprailiac"
                fifthLabel.text = "Mid thigh"
            } else {
                print("error while setting gender")
                fatalError()
            }
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        //0=Male, 1=Female
        if sender.selectedSegmentIndex == 0 { //Male
            print("Male selected")
            gender = "Male"
        } else if sender.selectedSegmentIndex == 1 { //Female
            print("female selected")
            gender = "Female"
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        Funcs.shared.addGradient(view: self.view)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
  
   
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        print(textField.restorationIdentifier)
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                age = availableText
            case "2":
                weight = availableText
            case "3":
                genderUniqueFold = availableText
            case "4":
                abdominalFold = availableText
            case "5":
                thighFold = availableText
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
   
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        view.endEditing(true) //end editing for all textfields and save values

        if let safeFirst = age, let safeSecond = weight, let safeThird = genderUniqueFold, let safeFourh = abdominalFold, let safeFifth = thighFold {
            if gender == "Male" {
               fatPercentage = Funcs.shared.calcMenBodyFat(age: safeFirst, chest: safeThird, abdominal: safeFourh, thigh: safeFifth)
            } else if gender == "Female" {
                fatPercentage = Funcs.shared.calcWomenBodyFat(age: safeFirst, triceps: safeThird, suprailiac: safeFourh, thigh: safeFifth)
            }
        }
        
        if fatPercentage != nil {
            performSegue(withIdentifier: "caliperToResult", sender: self)
        } else {
            print("fatPercentage is nil! \(fatPercentage ?? "nil")")
            self.present(Funcs.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = fatPercentage!
        destinationVC.weight = weight!
        destinationVC.gender = gender
    }
    
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        print(#function)
        dismiss(animated: true)
    }
    
    
    
    
    
}





   
