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
    
    var model = CaliperCalcModel()
    
    
    func changeLabelsToMale () {
        firstLabel.text = "Age"
        secondLabel.text = "Weight"
        thirdLabel.text = "Chest"
        fourthLabel.text = "Abdominal"
        fifthLabel.text = "Mid thigh"
    }
    
    func changeLabelsToFemale () {
        firstLabel.text = "Age"
        secondLabel.text = "Weight"
        thirdLabel.text = "Triceps"
        fourthLabel.text = "Suprailiac"
        fifthLabel.text = "Mid thigh"
    }
    
    
    /**
     toggle male and female
     - male index is 0
     - female index is 1
     */
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            changeLabelsToMale()
            model.gender = .Male
        } else if sender.selectedSegmentIndex == 1 {
            changeLabelsToFemale()
            model.gender = .Female
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
        closeTextFieldsWhenTappedAround()
    }
  
    private func closeTextFieldsWhenTappedAround () {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                model.age = availableText
            case "2":
                model.weight = availableText
            case "3":
                model.genderUniqueFold = availableText
            case "4":
                model.abdominalFold = availableText
            case "5":
                model.thighFold = availableText
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
   
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        view.endEditing(true) //end editing for all textfields and save values

        if let safeFirst = model.age, let safeSecond = model.weight, let safeThird = model.genderUniqueFold, let safeFourh = model.abdominalFold, let safeFifth = model.thighFold {
            if model.gender == .Male {
                model.fatPercentage = Funcs.shared.calcMenBodyFat(age: safeFirst, chest: safeThird, abdominal: safeFourh, thigh: safeFifth)
                model.weight = safeSecond
            } else if model.gender == .Female {
                model.fatPercentage = Funcs.shared.calcWomenBodyFat(age: safeFirst, triceps: safeThird, suprailiac: safeFourh, thigh: safeFifth)
                model.weight = safeSecond
            }
        }
        
        if model.fatPercentage != nil {
            performSegue(withIdentifier: "caliperToResult", sender: self)
        } else {
            print("fatPercentage is nil! \(model.fatPercentage ?? "nil")")
            self.present(Funcs.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = model.fatPercentage!
        destinationVC.weight = model.weight!
        destinationVC.gender = model.gender
    }
    
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        print(#function)
        dismiss(animated: true)
    }
    
    
    
    
    
}





   
