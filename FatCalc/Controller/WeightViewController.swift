//
//  WeightViewController.swift
//  LeanInsight
//
//  Created by segev perets on 08/02/2023.
//

import UIKit

let newEntryNotification = Notification.Name("newEntry")

class WeightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    
    let model = WeeklyWeightModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient(view: view)

        dayLabel.text = title
        
        setObservers()
        
        guard let currentDayString = title else {fatalError()}
        weightTextField.placeholder = model.fetchPlaceHolder(currentDayString)

    }
    
    private func setObservers () {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:))))
    }
    
    var counter = 0
    var afterDot : Int?
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        
        if text.contains(Character(".")), string == "." {
            return false
        }
        
        let isFirstLetter = text.isEmpty
        let isDeleting = string == ""
        
         if isFirstLetter {
             counter = 1
         } else if isDeleting {
             counter -= 1
         } else {
             if counter > 4 {return false}
            counter += 1
         }
             
        print("counter: "+counter.description)
        
        return true
        
    }
    
 
    @IBAction func savePressed(_ sender: UIButton) {

        if let text = weightTextField.text, !text.isEmpty, (Float(text)) != nil {
            let n = Float(text)!
            let isValid = n > 30 && n < 200
            
            NotificationCenter.default.post(name: weightUpdateNotification, object: n)

            guard isValid else {
                weightTextField.placeholder = "real weight please.. :)"
                weightTextField.text = ""
                return
            }

            weightTextField.text = ""
            weightTextField.resignFirstResponder()
            self.dismiss(animated: true)
        }
    }

    
}

