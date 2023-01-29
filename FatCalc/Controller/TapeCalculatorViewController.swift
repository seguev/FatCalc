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
    @IBOutlet weak var sixthLabel: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var fifthTextField: UITextField!
    
    @IBOutlet weak var sixthTextField: UITextField!
    
    var model = TapeCalcModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataModel.shared.addGradient(view: self.view)
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        sixthTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }

    
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setMaleLabels()
        } else if sender.selectedSegmentIndex == 1 {
            setFemaleLabels()
        } else {
            present(CoreDataModel.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    
    func setMaleLabels () {
        print("male has been set")
        thirdLabel.text = "Hips"
        fourthLabel.text = "Waist"
        fifthLabel.text = "Forearm"
        sixthLabel.text = "Wrist"
    }
    
    func setFemaleLabels () {
        thirdLabel.text = "Hips"
        fourthLabel.text = "Thigh"
        fifthLabel.text = "Calf"
        sixthLabel.text = "Wrist"
    }
    
    // MARK: - textField delegate funcs
    /**
     when end editing, saves data as the appropriate variable
     */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                model.age = availableText
            case "2":
                model.weight = availableText
            case "3":
                model.hips = availableText
            case "4":
                model.waistAndThigh = availableText
            case "5":
                model.forarmAndCalf = availableText
            case "6":
                model.wrist = availableText
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." && textField.text!.contains(".") {
            return false
        }
        return true
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        view.endEditing(true)
        if let safeFirst = model.age, let safeSecond = model.weight, let safeThird = model.hips, let safeFourh = model.waistAndThigh, let safeFifth = model.forarmAndCalf, let safeSixth = model.wrist{
            if model.gender == .Male {
                model.fatPercentage = Calculator.shared.tapeFatCalcMen(age: safeFirst, hips: safeThird, waist: safeFourh, forearm: safeFifth, wrist: safeSixth)
                model.weight = safeSecond
            } else if model.gender == .Female {
                model.fatPercentage = Calculator.shared.tapeFatCalcWomen(age: safeFirst, hips: safeThird, thigh: safeThird, calf: safeFourh, wrist: safeSixth)
                model.weight = safeSecond
            }
        }
        if model.fatPercentage != nil {
            performSegue(withIdentifier: "tapeToResult", sender: self)
        } else {
            self.present(CoreDataModel.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = model.fatPercentage!
        destinationVC.gender = model.gender
        destinationVC.weight = model.weight!
    }
    
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    
    
    

}
