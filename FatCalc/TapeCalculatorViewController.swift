//
//  TapeMeasureViewController.swift
//  FatCalc
//
//  Created by segev perets on 18/11/2022.
//

import UIKit

class TapeCalculatorViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ageLable: UILabel!
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
    var hips : String?
    var waistAndThigh : String?
    var forarmAndCalf : String?
    var wrist: String?
    var fatPercentage: String?
    
    var gender : String = "Male" {
        didSet {
            print("gender setter")
            if gender == "Male" {
                print("male has been set")
                secondLabel.text = "Hips"
                thirdLabel.text = "Waist"
                fourthLabel.text = "Forearm"
                fifthLabel.text = "Wrist"
            } else if gender == "Female" {
                print("female has been set")
                secondLabel.text = "Hips"
                thirdLabel.text = "Thigh"
                fourthLabel.text = "Calf"
                fifthLabel.text = "Wrist"
            } else {
                print("error while setting gender")
                fatalError()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstTextField.text = ""
        secondTextField.text = ""
        thirdTextField.text = ""
        fourthTextField.text = ""
        fifthTextField.text = ""
    }
   
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gender = "Male"
        } else if sender.selectedSegmentIndex == 1 {
            gender = "Female"
        } else {
            present(Funcs.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
            //decide which textfield.text to save
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                print("typing age")
                age = availableText
            case "2":
                print("typing hips")
                hips = availableText
            case "3":
                print("typing thigh")
                waistAndThigh = availableText
            case "4":
                print("typing typing calf")
                forarmAndCalf = availableText
            case "5":
                print("typing typing wrist")
                wrist = availableText
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
   

    @IBAction func calculatePressed(_ sender: UIButton) {
        view.endEditing(true)
        if let safeFirst = age, let safeSecond = hips, let safeThird = waistAndThigh, let safeFourh = forarmAndCalf, let safeFifth = wrist{
            if gender == "Male" {
                print("gender is male")
               fatPercentage = Funcs.shared.tapeFatCalcMen(age: safeFirst, hips: safeSecond, waist: safeThird, forearm: safeFourh, wrist: safeFifth)
            } else if gender == "Female" {
                print("gender is female")
                fatPercentage = Funcs.shared.tapeFatCalcWomen(age: safeFirst, hips: safeSecond, thigh: safeThird, calf: safeFourh, wrist: safeFifth)
                
            }
        }

        if fatPercentage != nil {
            print("fatPercentage isn't nil!")
            performSegue(withIdentifier: "tapeToResult", sender: self)
        } else {
            print("fatPercentage is nil! : \(fatPercentage ?? "nil")")
            self.present(Funcs.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier ?? "nil")
        print(segue.destination)
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = fatPercentage!
        destinationVC.gender = gender
    }
    
    
    
    
    
    
    

}
