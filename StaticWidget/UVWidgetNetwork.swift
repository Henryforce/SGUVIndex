//
//  UVWidgetNetwork.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 11/10/20.
//

import Foundation

final class UVWidgetNetwork: NSObject, URLSessionDelegate {
    
    static func getData(currentDate: Date, completion: @escaping ([UVWidgetData], Date) -> ()) {
        let validationStatus = timeValidation(date: currentDate)
        guard validationStatus.canUpdate else {
            let widgetData = UVWidgetData(date: currentDate,
                                          uvValue: "-",
                                          uvDescription: "")
            completion([widgetData], validationStatus.nextDate)
            return
        }
        
        let url = "https://api.data.gov.sg/v1/environment/uv-index"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                completion([UVWidgetData.previewData], validationStatus.nextDate)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let jsonData = try decoder.decode(UVData.self, from: data!)
                let uvData = Self.converter(data: jsonData)
                completion(uvData, validationStatus.nextDate)
            } catch{
//                print(error.localizedDescription)
                completion([UVWidgetData.previewData], validationStatus.nextDate)
            }
        }.resume()
    }
    
    static func timeValidation(date: Date) -> (nextDate: Date, canUpdate: Bool) {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "SGT") {
           calendar.timeZone = timeZone
        }
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        
        let nextUpdateTime: Date
        let canUpdate: Bool
        if hour < 7 {
            let today = calendar.startOfDay(for: date)
            let dateComponents = DateComponents(hour: 7, minute: 10)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: today)!
            canUpdate = false
        } else if hour >= 20 {
            let today = calendar.startOfDay(for: date)
            let dateComponents = DateComponents(day: 1, hour: 7, minute: 10)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: today)!
            canUpdate = false
        } else {
            let minutesAddition = 70 - minutes
            let dateComponents = DateComponents(minute: minutesAddition)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: date)!
            canUpdate = true
        }
        
        return (nextUpdateTime, canUpdate)
    }
    
    static func converter(data: UVData) -> [UVWidgetData] {
        guard let firstItem = data.items.first else { return [UVWidgetData.previewData] }
        
        let widgetData: [UVWidgetData] =  firstItem.records.compactMap { record -> UVWidgetData? in
            guard let uvIndex = UVIndex(from: record.value) else { return nil }
            return UVWidgetData(date: record.timestamp,
                                uvValue: String(record.value),
                                uvDescription: uvIndex.name())
        }.sorted { (leftData, rightData) -> Bool in
            leftData.date > rightData.date
        }
        guard widgetData.count > 0 else { return [UVWidgetData.previewData] }
        
        return widgetData
    }
    
}
