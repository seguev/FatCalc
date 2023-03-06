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
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    
    var model = CaliperCalcModel()
    var infoLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        
        addGradient(view: view)
        
//        CoreDataModel.shared.addGradient(view: self.view)
        closeTextFieldsWhenTappedAround()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideLabel)))
//        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:))))
    }
    @objc func hideLabel () {
        view.endEditing(true)
        if let infoLabel {
            infoLabel.removeFromSuperview()
        }
    }
    func changeLabelsToMale () {
        firstLabel.text = "Age"
        secondLabel.text = "Chest"
        thirdLabel.text = "Abdominal"
        fourthLabel.text = "Mid thigh"
        
    }

    func changeLabelsToFemale () {
        firstLabel.text = "Age"
        secondLabel.text = "Triceps"
        thirdLabel.text = "Suprailiac"
        fourthLabel.text = "Mid thigh"
        
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
   
    

  
    private func closeTextFieldsWhenTappedAround () {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." && textField.text!.contains(".") {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                model.age = availableText
            case "2":
                model.genderUniqueFold = availableText
            case "3":
                model.abdominalFold = availableText
            case "4":
                model.thighFold = availableText
                
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
   
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        view.endEditing(true) //end editing for all textfields and save values

        if let safeAge = model.age,
           let safeGenderUniqueFold = model.genderUniqueFold,
           let safeAbdominalFold = model.abdominalFold,
           let safeThighFold = model.thighFold {
            
            if model.gender == .Male {
                model.fatPercentage = Calculator.shared.calcMenBodyFat(age: safeAge,
                                                                       chest: safeGenderUniqueFold,
                                                                       abdominal: safeAbdominalFold,
                                                                       thigh: safeThighFold
                )
            } else if model.gender == .Female {
                model.fatPercentage = Calculator.shared.calcWomenBodyFat(age: safeAge,
                                                                         triceps: safeGenderUniqueFold, suprailiac: safeAbdominalFold,
                                                                         thigh: safeThighFold
                )
            }
        }
        
        if model.fatPercentage != nil {
            performSegue(withIdentifier: "caliperToResult", sender: self)
        } else {
            print("fatPercentage is nil! \(model.fatPercentage ?? "nil")")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = model.fatPercentage!
        destinationVC.gender = model.gender
    }
    

    @IBAction func infoPressed(_ sender: UIButton) {
        let info = Info()
        if let infoLabel {infoLabel.removeFromSuperview()}
        switch sender.tag {
        case 0:
            if model.gender == .Male {
                infoLabel = info.showInfoLabel(view, text: info.caliperMaleInfo.Chest)
            } else if model.gender == .Female {
                infoLabel = info.showInfoLabel(view, text: info.caliperFemaleInfo.Tricep)
            }
        case 1:
            if model.gender == .Male {
                infoLabel = info.showInfoLabel(view, text: info.caliperMaleInfo.Abdominal)
            } else if model.gender == .Female {
                infoLabel = info.showInfoLabel(view, text: info.caliperFemaleInfo.Suprailiac)
            }
        case 2:
            if model.gender == .Male {
                infoLabel = info.showInfoLabel(view, text: info.caliperMaleInfo.Thigh)
            } else if model.gender == .Female {
                infoLabel = info.showInfoLabel(view, text: info.caliperFemaleInfo.Thigh)
            }
        default:
            fatalError()
        }
    }
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    
    
    
}





   
