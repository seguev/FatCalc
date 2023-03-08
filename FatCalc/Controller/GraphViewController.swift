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
 
    @IBOutlet var backGroundDefaultGraph: UIImageView!
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
//        CoreDataModel.shared.addGradient(view: self.view)
        
        addGradient(view: view)
        
        lineChartView.delegate = self
        
        model.chartSetup(self.view, chart: lineChartView)
        model.delegate = self
  
        if model.entriesArray.count <= 1 {
            model.showNoDataPopUp(noDataPopUp, backGroundDefaultGraph, blurView, in: view)
            lineChartView.isUserInteractionEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        model.updateChart(to: lineChartView)

        if model.entriesArray.count > 1 {
            model.hideNoDataPopUp(noDataPopUp, blur: blurView)
            lineChartView.isUserInteractionEnabled = true
        }
    }


    // MARK: - delegate func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
        
        selectedEntry = model.entriesArray[Int(entry.x - 1)]
        
        let entryInfo = model.fetchEntryInfo(entry)
        
        presentPopUp(highlight, info: entryInfo)
    }

    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        popUP.removeFromSuperview()
    }
    
    private func presentPopUp (_ hightLight: Highlight, info:(avWeight: Float, fatPer: Float, weekNum: Int16))  {
        
        //popUp position & size
        let position = CGPoint(x: hightLight.xPx, y: view.frame.height * 0.2)
        let size = CGSize(width: 160, height: 120)
        popUP.frame = .init(origin: .zero, size: size)
        popUP.center = position
        
        //label config
        popUpFirstLabel.text = "week number: \(info.weekNum)"
        popUpSecondLabel.text = "Average weight: \(Int(info.avWeight))"
        popUpThirdLabel.text = "fat percentage \(info.fatPer)"
        
        model.popUpConfig(popUP)
        
        view.addSubview(popUP)
        
        model.handleOffScreen(view,popUP)
    }



}
