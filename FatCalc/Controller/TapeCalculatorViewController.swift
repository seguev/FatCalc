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
    
    
    var model = TapeCalcModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CoreDataModel.shared.addGradient(view: self.view)
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }

    
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setMaleLabels()
        } else if sender.selectedSegmentIndex == 1 {
            setFemaleLabels()
        }
    }
    
    func setMaleLabels () {
        print("male has been set")
        secondLabel.text = "Hips"
        thirdLabel.text = "Waist"
        fourthLabel.text = "Forearm"
        fifthLabel.text = "Wrist"
    }
    
    func setFemaleLabels () {
        secondLabel.text = "Hips"
        thirdLabel.text = "Thigh"
        fourthLabel.text = "Calf"
        fifthLabel.text = "Wrist"
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
                model.hips = availableText
            case "3":
                model.waistAndThigh = availableText
            case "4":
                model.forarmAndCalf = availableText
            case "5":
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
        if let safeFirst = model.age,
           let safeSecond = model.hips,
           let safeThird = model.waistAndThigh,
           let safeFourh = model.forarmAndCalf,
           let safeFifth = model.wrist {
            
            if model.gender == .Male {
                model.fatPercentage = Calculator.shared.tapeFatCalcMen(age: safeFirst,
                                                                       hips: safeSecond,
                                                                       waist: safeThird,
                                                                       forearm: safeFourh,
                                                                       wrist: safeFifth
                )
                
            } else if model.gender == .Female {
                model.fatPercentage = Calculator.shared.tapeFatCalcWomen(age: safeFirst,
                                                                         hips: safeSecond,
                                                                         thigh: safeThird,
                                                                         calf: safeFourh,
                                                                         wrist: safeFifth
                )
                
            }
        }
        if model.fatPercentage != nil {
            performSegue(withIdentifier: "tapeToResult", sender: self)
        } 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = model.fatPercentage!
        destinationVC.gender = model.gender
    }
    
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    
    
    

}
