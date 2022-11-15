//
//  CaliperCalculatorViewController.swift
//  FatCalc
//
//  Created by segev perets on 15/11/2022.
//

import UIKit

class MenCaliperCalculatorViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!

    var firstText : String?
    var secondText : String?
    var thirdText : String?
    var numberArray = [Int]()
    var age : Int = 20
    var fatPercentage: String?
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        //0=Male, 1=Female
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 { //male
            print("male selected")
            firstLabel.text = "pecs"
            secondLabel.text = "abs"
            thirdLabel.text = "thigh"
            
        } else if sender.selectedSegmentIndex == 1 { //female
            print("female selected")
            firstLabel.text = "suprailiac"
            secondLabel.text = "thigh"
            thirdLabel.text = "triceps"
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        agePicker.delegate = self
        agePicker.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
   
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        
        if let availableText = textField.text{
            switch textField.restorationIdentifier{
            case "1":
                firstText = availableText
                print("\(firstText!) text saved")
            case "2":
                secondText = availableText
                print("\(secondText!) text saved")
            case "3":
                thirdText = availableText
                print("\(thirdText!) text saved")
            default:
                print("da fuck did you just do")
            }
        }
        
        return true
    }
   
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        if let safeFirst = firstText, let safeSecond = secondText, let safeThird = thirdText{
            fatPercentage = Funcs.shared.calcMenBodyFat(chest: safeFirst, abdominal: safeSecond, thigh: safeThird, age: age)
        }
        
        if fatPercentage != nil {
            performSegue(withIdentifier: "toResult", sender: self)
        
        #warning("dont forget to check gender!")
           
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
extension MenCaliperCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    
}
   
