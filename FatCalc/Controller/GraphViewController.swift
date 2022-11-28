//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit
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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoPopUp: UIView!

    var model = GraphModel()
    let lineChartView = LineChartView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)
        lineChartView.delegate = self
        model.chartSetup(self.view, chart: lineChartView)
        
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        //title = currentControllerName
        print("current controller is \(currentControllerName)")
        model.fetchAllEntries(to: lineChartView)
    }

    // MARK: - delegate func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let index = Int(entry.x)
        let selectedEntry = model.globalArray[index - 1]
        
        let info = """
            weight: \(selectedEntry.weight)
            fat: \(selectedEntry.fatPercentage)
            date: \(selectedEntry.date ?? "no date")
            """
        let xPosition = highlight.xPx
        let yPosition = highlight.yPx
        
        model.createInfoLabel(for: 5, x: xPosition, y: yPosition, text: info, view: view)
    }
    
    
    

    
}

