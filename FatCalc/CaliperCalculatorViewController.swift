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
    
    
    var age : String?
    var genderUniqueFold : String?
    var abdominalFold : String?
    var thighFold : String?
    
    var numberArray = [Int]()
    var fatPercentage: String?
    
    var gender : String = "Male" {
        didSet {
            print("gender setter")
            if gender == "Male" {
                print("male has been set")
                firstLabel.text = "Age"
                secondLabel.text = "Chest"
                thirdLabel.text = "Abdominal"
                fourthLabel.text = "Mid thigh"
            } else if gender == "Female" {
                print("female has been set")
                firstLabel.text = "Age"
                secondLabel.text = "Triceps"
                thirdLabel.text = "Suprailiac"
                fourthLabel.text = "Mid thigh"
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
        Funcs.shared.addGradient(view: self.view)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
   
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
            //decide which textfield.text to save
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                age = availableText
            case "2":
                genderUniqueFold = availableText
            case "3":
                abdominalFold = availableText
            case "4":
                thighFold = availableText
            default:
                print("da fuck did you just do")
            }
        }
        return true
    }
   
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        if let safeFirst = age, let safeSecond = genderUniqueFold, let safeThird = abdominalFold, let safeFourh = thighFold{
            if gender == "Male" {
               fatPercentage = Funcs.shared.calcMenBodyFat(age: safeFirst, chest: safeSecond, abdominal: safeThird, thigh: safeFourh)
            } else if gender == "Female" {
                fatPercentage = Funcs.shared.calcWomenBodyFat(age: safeFirst, triceps: safeSecond, suprailiac: safeThird, thigh: safeFourh)
            }
        }
        
        if fatPercentage != nil {
            performSegue(withIdentifier: "toResult", sender: self)
        } else {
            self.present(Funcs.shared.somthingsWrongAlertController(), animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        print(segue.destination)
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.result = fatPercentage!
    }
    
    
    
    
    
    
    
}




// MARK: - picker
/*extension CaliperCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        for number in stride(from: 20, to: 100, by: 1) {
            numberArray.append(number)
        }
        let StringArray = numberArray.map{"\($0)"}
        return StringArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(numberArray[row])
        age = numberArray[row]
    }
    
    
    
}*/
   
