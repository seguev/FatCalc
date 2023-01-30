//
//  GraphModel.swift
//  FatCalc
//
//  Created by segev perets on 28/11/2022.
// https://weeklycoding.com/mpandroidchart-documentation/

import Foundation
import Charts
import UIKit
import CoreData

struct GraphModel {
    
    var sets : [LineChartDataSet] = []
    var entriesArray : [Entry] = []
    weak var delegate : GraphViewController? {
        didSet {
            print("graph delegate has been set")
        }
    }
    

    
    /**
     chart setup
     */
    func chartSetup (_ view:UIView, chart:LineChartView) {
        chart.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height*0.8)
        chart.rightAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.leftAxis.labelPosition = .outsideChart
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.dragEnabled = true
        chart.leftAxis.axisMinimum = 5
        chart.xAxis.labelFont = .systemFont(ofSize: 12)
        chart.center = view.center
        chart.leftAxis.enabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.axisLineColor = .black
        chart.rightAxis.axisLineColor = .black
        chart.leftAxis.drawLabelsEnabled = false
        chart.drawMarkers = false
        chart.drawGridBackgroundEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        chart.drawMarkers = false
                
        view.addSubview(chart) //add chart to view
        
        
    }
    
    /**
     adds data to chartview
     - delete previous ChartData to prevent ovelap
     - load all available data from coreData
     - creates weight (line)set and fatPersentage (line)set
     - add set as a data set to chart
     - calls setData() that sets each line properties
     */
    mutating func updateChart(to chart:LineChartView) {
        sets = []
        entriesArray = []
        chart.leftAxis.axisMaximum = CoreDataModel.shared.fetchMaxWeight() * 1.6 //set graph flexible height


        var weightEntriesArray : [ChartDataEntry] = []
        var fatEntriesArray : [ChartDataEntry] = []
        
        //create safe loaded data if exist
        if let loadedData = CoreDataModel.shared.loadFromCoreData() {
            
            //add data from coreData to global array for us to fetch later if needed
            entriesArray.append(contentsOf: loadedData )
            
            //set starting index
            var entryIndex : Double = 0.0
            
            //for each entry, seperate fat and weight for ChartDataSets
            for entry in entriesArray {
                let fat = Double(entry.fatPercentage)
                let weight = Double(entry.weight)
                entryIndex += 1
                
                //set weightEntry
                let weightChartEntry = ChartDataEntry(x: entryIndex, y: weight)
                weightEntriesArray.append(weightChartEntry) //add to local array
                
                //set fatEntry
                let fatChartEntry = ChartDataEntry(x: entryIndex, y: fat)
                fatEntriesArray.append(fatChartEntry) //add to local array
                //export to local array
            }
            //fetch from local array after beings set
            let weightSet = LineChartDataSet(entries: weightEntriesArray, label: "weight")
            let fatSet = LineChartDataSet(entries: fatEntriesArray, label: "fat%")
            
            //go to next func and setup each line
            setData(weightSet, set2: fatSet,chart: chart)
            
        } else {
            print("Could not load from core data")
        }
    }
    
    
    
    
    //2. being called from fechAllEntries()
    private mutating func setData (_ set1:LineChartDataSet,set2:LineChartDataSet ,chart:LineChartView) {
        //add chart data to a new set everytime func is called
        
        
        //set the set's attributes
        set1.mode = .linear //line style
        set1.circleHoleRadius = 0.02 //circle radius
        set1.drawFilledEnabled = true //add fill
        set1.fillColor = .systemBlue
        set1.colors = [NSUIColor.systemBlue]
        set1.fillAlpha = 0.4 //fill alpha
        
        set1.drawHorizontalHighlightIndicatorEnabled = false

        sets.append(set1) //add to global setsArray, so we can pass several sets to data
        
        //set the set's attributes
        set2.mode = .linear //line style
        set2.circleHoleRadius = 0.02 //circle radius
        set2.drawFilledEnabled = true //add fill
        set2.fillColor = .systemBlue
        set2.colors = [NSUIColor.blue]
        set2.fillAlpha = 0.4 //fill alpha
        set2.drawHorizontalHighlightIndicatorEnabled = false
        
        sets.append(set2) //add to global setsArray, so we can pass several sets to data
        
        
        //make data from global setsArray
        let newData = LineChartData(dataSets: sets)
        
        //attach data to chart
        chart.data = newData
        
    }
    
    /**
     "weight":Float,
     "fat":Float,
     "date":String
     */
    func fetchEntryInfo (_ entry:ChartDataEntry) -> [String:Any] {
        let index = Int(entry.x)
        let selectedEntry = entriesArray[index - 1]
        
        let weight = selectedEntry.weight
        let fat = selectedEntry.fatPercentage
        let date = selectedEntry.date ?? "no date"
        
        return ["weight":weight,"fat":fat,"date":date]
    }
    
    func handleOffScreen(_ view:UIView,_ popUP:UIView) {
        
        if popUP.frame.origin.x < 0 {
            popUP.frame.origin.x = 5
            
        } else if popUP.frame.maxX > view.frame.width {
            popUP.frame.origin.x = view.frame.width - popUP.frame.width - 5            
        }
    }
    
    func popUpConfig(_ popUP:UIView) {
        popUP.backgroundColor = .systemGray6
        popUP.layer.shadowColor = UIColor.darkGray.cgColor
        popUP.layer.shadowOffset = .init(width: 4, height: 4)
        popUP.layer.shadowRadius = 5
        popUP.layer.shadowOpacity = 0.7
        popUP.layer.cornerRadius = 10
    }
    
    func showNoDataPopUp (_ popUp:UIView, blur: UIVisualEffectView,in view:UIView) {
        
        popUp.alpha = 0        
        blur.frame = view.frame
        blur.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        view.addSubview(blur)
        
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            popUp.frame = .init(x: view.center.x, y: 50, width: 200, height: 150)
            popUp.center = .init(x: view.center.x, y: view.center.y - 100 )
            popUp.backgroundColor = .systemGray6
            popUp.layer.cornerRadius = 10
            popUp.layer.shadowColor = UIColor.black.cgColor
            popUp.layer.shadowRadius = 20
            popUp.layer.shadowOffset = .init(width: 4, height: 4)
            popUp.layer.shadowOpacity = 0.5
            popUp.alpha = 1
                        
            view.addSubview(popUp)
        }
    }
    func hideNoDataPopUp (_ popUp:UIView, blur:UIVisualEffectView) {
        popUp.removeFromSuperview()
        blur.removeFromSuperview()
    }
    
    
}
