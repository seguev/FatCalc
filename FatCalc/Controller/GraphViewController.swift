//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit
import AVFoundation
import Charts
/*
add graph cocoapod V
add weight line V
add fat line V
change box color at the bottom V
delete axis information V
add popUp with information when long pressing an entry
one line insted of cross shat shows date
change colors to something more practical
 */



class GraphViewController: UIViewController, ChartViewDelegate {
 
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var noDataPopUp: UIView!
    @IBOutlet var popUP: UIView!
    @IBOutlet weak var popUpFirstLabel: UILabel!
    @IBOutlet weak var popUpSecondLabel: UILabel!
    @IBOutlet weak var popUpThirdLabel: UILabel!
    
    var model = GraphModel()
    let lineChartView = LineChartView()
    var selectedEntry : Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataModel.shared.addGradient(view: self.view)
        lineChartView.delegate = self
        model.chartSetup(self.view, chart: lineChartView)
        model.delegate = self
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let currentControllerName = CoreDataModel.shared.fetchNameFromCurrent(self)
        title = currentControllerName
        model.updateChart(to: lineChartView)
        if model.entriesArray.isEmpty || model.entriesArray.count == 1 {
            model.showNoDataPopUp(noDataPopUp,blur: blurView,in: view)
        } else {
            model.hideNoDataPopUp(noDataPopUp, blur: blurView)
        }
    }


    // MARK: - delegate func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        selectedEntry = model.entriesArray[Int(entry.x - 1)]
        
        let entryInfo = model.fetchEntryInfo(entry)
        
        presentPopUp(highlight, info: entryInfo)
    }
    
    private func presentPopUp (_ hightLight: Highlight, info:[String:Any])  {
        
        //popUp position & size
        let position = CGPoint(x: hightLight.xPx, y: hightLight.yPx-20)
        let size = CGSize(width: 160, height: 120)
        popUP.frame = .init(origin: .zero, size: size)
        popUP.center = position
        
        //label config
        popUpFirstLabel.text = info["date"] as? String
        popUpSecondLabel.text = String(info["weight"] as! Float)+" kg"
        popUpThirdLabel.text = String(info["fat"] as! Float)+"% Body fat"
        
        model.popUpConfig(popUP)
        
        view.addSubview(popUP)

        model.handleOffScreen(view,popUP)
    }
    
    @IBAction func popUpExitPressed(_ sender: UIButton) {
        popUP.removeFromSuperview()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose action", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit weight", style: .default ,handler: { [weak self] _ in
            alert.dismiss(animated: true)
            self?.showEditWeightAlert()
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive ,handler: { _ in
            
            CoreDataModel.shared.deleteFromCoreData(self.selectedEntry!)
            self.model.updateChart(to: self.lineChartView)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showEditWeightAlert (error:Bool? = nil) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit weight", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default ,handler: {[weak self] action in
            action.isEnabled = false
            
            guard let self = self else {return}
            
            if let newWeight = Float(textField.text!), newWeight < 200 {
                
                CoreDataModel.shared.updateWeight(self.selectedEntry!, to: newWeight)
                
                self.model.updateChart(to: self.lineChartView)
            } else {
                self.showEditWeightAlert(error: true)
            }
        }))
        alert.addTextField { alertTextField in
            textField = alertTextField
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        present(alert, animated: true)
        if let error {self.flickerTextField(textField: textField)}
    }
    
    private func flickerTextField (textField:UITextField){
        UIView.animate(withDuration: 1, delay: 2) {
            textField.backgroundColor = .systemRed
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                textField.backgroundColor = .clear
            }
        }

    }

}
extension GraphViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "." && textField.text!.contains(".") {
            return false
        }
        return true
    }
    
    
}
