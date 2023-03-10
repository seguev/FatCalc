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
        chart.leftAxis.axisMinimum = 0
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
        chart.minOffset = 0
        chart.extraTopOffset = 200
        chart.noDataText = "Not enough entries"
        chart.noDataFont = .systemFont(ofSize: 30)
        
//        chart.textInputContextIdentifier
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
//        chart.leftAxis.axisMaximum = CoreDataModel.shared.fetchMaxWeight() * 1.6 //set graph flexible height


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
                let weight = Double(entry.weightAverage)
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
        
        set1.fillColor = #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1)
        set1.colors = [NSUIColor(cgColor: #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1).cgColor)]
        set1.circleColors = [NSUIColor(cgColor: #colorLiteral(red: 0.7490196078, green: 0.6745098039, blue: 0.8862745098, alpha: 1).cgColor)]
        
        let fM = DefaultValueFormatter()
//        fM.decimals = 1
        fM.decimals = 6
        set1.valueFormatter = fM
        
        sets.append(set1) //add to global setsArray, so we can pass several sets to data
        
        set2.fillColor = #colorLiteral(red: 0.2431372549, green: 0.3294117647, blue: 0.6745098039, alpha: 1)
        set2.colors = [NSUIColor(cgColor: #colorLiteral(red: 0.2431372549, green: 0.3294117647, blue: 0.6745098039, alpha: 1).cgColor)]
        set2.circleColors = [NSUIColor(cgColor: #colorLiteral(red: 0.2431372549, green: 0.3294117647, blue: 0.6745098039, alpha: 1).cgColor)]
        

        
        sets.append(set2) //add to global setsArray, so we can pass several sets to data
        
        sets.forEach { uniSet in
            uniSet.highlightColor = #colorLiteral(red: 0.9254901961, green: 0.901304543, blue: 1, alpha: 1)
            uniSet.mode = .linear
            uniSet.circleRadius = 4
            uniSet.drawFilledEnabled = true
            uniSet.fillAlpha = 0.4
//            uniSet.valueFont = .systemFont(ofSize: 10)
            uniSet.valueTextColor = .clear
            uniSet.valueFont = .systemFont(ofSize: 15)
            
            uniSet.drawHorizontalHighlightIndicatorEnabled = false
            
        }
        //make data from global setsArray
        let newData = LineChartData(dataSets: sets)
        
        //attach data to chart
        chart.data = newData
        
    }
    

    func fetchEntryInfo (_ entry:ChartDataEntry) -> (avWeight:Float,fatPer:Float,weekNum:Int16) {
        let index = Int(entry.x)
        let selectedEntry = entriesArray[index - 1]
        
        let entry = (avWeight:selectedEntry.weightAverage,fatPer:selectedEntry.fatPercentage,weekNum:selectedEntry.weekNum)
        return entry
    }
    
    func handleOffScreen(_ view:UIView,_ popUP:UIView) {
        
        if popUP.frame.origin.x < 0 {
            popUP.frame.origin.x = 5
            
        } else if popUP.frame.maxX > view.frame.width {
            popUP.frame.origin.x = view.frame.width - popUP.frame.width - 5            
        }
    }
    
    func popUpConfig(_ popUP:UIView) {
        popUP.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9490196078, blue: 1, alpha: 1)
        popUP.layer.shadowColor = UIColor.darkGray.cgColor
        popUP.layer.shadowOffset = .init(width: 4, height: 4)
        popUP.layer.shadowRadius = 5
        popUP.layer.shadowOpacity = 0.7
        popUP.layer.cornerRadius = 10
    }
    
    func showNoDataPopUp (_ popUp:UIView,_ backgroundGraphView:UIImageView ,_ blur: UIVisualEffectView, in view:UIView) {
        
        backgroundGraphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundGraphView)
        NSLayoutConstraint.activate([
            backgroundGraphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundGraphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundGraphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundGraphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        

        blur.frame = view.frame
        blur.effect = UIBlurEffect(style: .systemMaterialDark)
        blur.alpha = 0.9
        popUp.alpha = 0
        view.addSubview(blur)
        view.addSubview(popUp)
        popUp.frame = .init(x: view.center.x, y: 50, width: 200, height: 150)
        popUp.center = .init(x: view.center.x, y: view.center.y - 100 )
        
        UIView.animate(withDuration: 0.5,delay: 0.2) {
            
            popUp.alpha = 1

            popUp.backgroundColor = .systemGray6
            popUp.layer.cornerRadius = 10
            popUp.layer.shadowColor = UIColor.black.cgColor
            popUp.layer.shadowRadius = 20
            popUp.layer.shadowOffset = .init(width: 4, height: 4)
            popUp.layer.shadowOpacity = 0.5
        }

    }
    func hideNoDataPopUp (_ popUp:UIView, blur:UIVisualEffectView) {
        popUp.removeFromSuperview()
        blur.removeFromSuperview()
    }
    
    
}
