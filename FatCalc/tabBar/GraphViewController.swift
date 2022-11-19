//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate {

  
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.leftAxis.axisLineColor = .black
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)
        lineChartView.delegate = self
        
       
        chartSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        //title = currentControllerName
        print("current controller is \(currentControllerName)")
        
        //set chartData when loading
        setData()
    }

    func chartSetup () {
        lineChartView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height*0.8)
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.leftAxis.labelPosition = .outsideChart
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.center = view.center

        view.addSubview(lineChartView) //add chart to view
        
        
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.y)
    }
    
    func loadData () {
        //1.get entries from core data and make in [ChartdataEntriy]
        //2.make lineChartDataSet from it
        //3.make lineChartData from dataSet
        //4.add new data to lineChartView
    }
    //1. set chart data entries
        let weightValue : [ChartDataEntry] = [
            ChartDataEntry(x: 1, y: 65.4),
            ChartDataEntry(x: 2, y: 64.2),
            ChartDataEntry(x: 3, y: 62.9),
            ChartDataEntry(x: 4, y: 61.1),
            ChartDataEntry(x: 5, y: 60)
        ]
    
    //2. set data to chart
    func setData () {
        //take the entries and insert into a data set and name it.
        let weightSet = LineChartDataSet(entries: weightValue, label: "Weight")
        weightSet.mode = .cubicBezier
        weightSet.circleHoleRadius = 0.08
        weightSet.fillColor = .white
        weightSet.drawFilledEnabled = true
        weightSet.fillAlpha = 0.4
        //make data from the data set
        let data = LineChartData(dataSet: weightSet)
        
        //attach data to chart
        lineChartView.data = data
    }
    
    
    
}

