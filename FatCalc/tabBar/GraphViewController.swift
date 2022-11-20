//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate {

    var sets : [LineChartDataSet] = [] //global var for lines

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
        
        loadWeight()
        loadFats()
    }

    private func chartSetup () {
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
    
    func loadWeight () {
        var chartEntries : [ChartDataEntry] = []
        var entryIndex : Double = 0.0
        if let loadedData = Funcs.shared.loadFromCoreData() {
            for i in loadedData {
                entryIndex += 1
                let weight = Double(i.weight)
                let weightChartEntry = ChartDataEntry(x: entryIndex, y: weight)
                chartEntries.append(weightChartEntry)
            }
            #warning("specify set")
            setData(chartEntries, name: "weight", color: .white)
        } else {print("No weight data")}
    }
    
    func loadFats () {
        var chartEntries : [ChartDataEntry] = []
        var entryIndex : Double = 0.0
        if let loadedData = Funcs.shared.loadFromCoreData() {
            for i in loadedData {
                entryIndex += 1
                let fat = Double(i.fatPercentage)
                let fatsChartEntry = ChartDataEntry(x: entryIndex, y: fat)
                chartEntries.append(fatsChartEntry)
            }
            #warning("specify set")
            setData(chartEntries, name: "Fat %", color: .gray)

        } else {print("No fats data")}
    }
   
    /*private func loadAll () {
        //1. "everytime theres value in [Entry], it also load all weights"
        //2. "show dates insted of numbers at bottom axis"
        //3. "attach weight to fats if on the same date"
        //4. "set different line for weights and fats"
        //5. "hide chart net"
        //6. "set bottom values to Intergers"
        //7. "hide left axis"
        
        //load all entries
        if let loadedEntries = Funcs.shared.loadFromCoreData() {
            
            //every load, let an index for each (later will be used for x value)
            var entryIndex : Double = 0.0
            
            //init empty chartDataEntry array
            var fatsArray : [ChartDataEntry] = []
            
            //for each entry from array
            for entry in loadedEntries {
                
                //set + 1 index from previous
                entryIndex += 1
                
                //isolate the weight from the intire Entry
                let weightEntry = Double(entry.fatPercentage)
                
                //create new ChartDataEntry from index and weight
                let newEntry = ChartDataEntry(x: entryIndex, y: weightEntry)
                
                //append to an array of ChartDataEntries
                fatsArray.append(newEntry)
            }
            
            //procied to next func
            setData(fatsArray)
        } else {
            print("Chart has no entries to load!")
        }
    }*/
    
   
    //2. set data to chart
    private func setData (_ chartDataEntryArray: [ChartDataEntry], name: String, color:UIColor) {
        //add chart data to a new set everytime func is called
        
        //take the entries and insert into a data set and name it.
        let newSet = LineChartDataSet(entries: chartDataEntryArray, label: name)
        
        //set the set's attributes
        newSet.mode = .horizontalBezier //line style
        newSet.circleHoleRadius = 0.03 //circle radius
        newSet.drawFilledEnabled = true //add fill
        newSet.fillColor = color //fill color
        newSet.fillAlpha = 0.4 //fill alpha
        
        sets.append(newSet)
        
        //make LineChartData from the data set. (LineData specificly)
        let newData = LineChartData(dataSets: sets)
        
        //attach data to chart
        lineChartView.data = newData
    
     
    }
    
    
    
}

