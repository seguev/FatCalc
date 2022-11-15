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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard result != nil else {fatalError()}
        resultLabel.text = result!+"%"
        isHealthy()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func isHealthy () {
        if let resultFloat = Float(result!) {
            switch resultFloat{
            case ..<10:
                view.backgroundColor = .green
                resultLabel.text?.append(" 🤯")
            case 10..<15:
                view.backgroundColor = .blue
                resultLabel.text?.append(" 🥳")
            case 15..<20:
                view.backgroundColor = .yellow
                resultLabel.text?.append(" 😕")
            case 20..<30:
                view.backgroundColor = .orange
                resultLabel.text?.append(" 😨")
            case 30...:
                view.backgroundColor = .red
                resultLabel.text?.append(" 🤢")
                
            default:
                view.backgroundColor = .darkGray
                
            }
        }
    }

}
