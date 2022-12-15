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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoPopUp: UIView!

    var model = GraphModel()
    let lineChartView = LineChartView()
    
    var label = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)
        lineChartView.delegate = self
        model.chartSetup(self.view, chart: lineChartView)
        model.delegate = self
  
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
        let info = model.fetchEntryInfo(entry, highlight: highlight)
        label.isHidden = true
        model.globalLabelSetup(for: 2, hightLight: highlight, text: info, view: view)
    }
    
    
    

    
}

