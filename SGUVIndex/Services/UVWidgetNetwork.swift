//
//  UVWidgetNetwork.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 11/10/20.
//

import Foundation

final class UVWidgetNetwork: NSObject, URLSessionDelegate {
    
    private static let urlString = "https://api.data.gov.sg/v1/environment/uv-index"
    private static let dateDaysOffset: Int = 1
    private static let dateHoursOffset: Int = 7
    private static let dateMinutesOffset: Int = 10
    private static let startingHourThreshold: Int = 7
    private static let endingHourThreshold: Int = 20
    
    static func getData(
        currentDate: Date,
        userDefaults: UserDefaultsManager,
        urlSession: URLSessionWrapper = StandardURLSessionWrapper(),
        completion: @escaping ([UVWidgetData], Date) -> ()
    ) {
        let validationStatus = timeValidation(date: currentDate)
        guard validationStatus.canUpdate else {
            let widgetData = UVWidgetData(date: currentDate,
                                          uvValue: "-",
                                          uvDescription: "")
            completion([widgetData], validationStatus.nextDate)
            return
        }
        let decoder = JSONDecoder.iso8601Decoder
        
//        if let userDefaultsData = userDefaults.object(forKey: "LastUVData") as? Data,
//           let decodedData = try? decoder.decode(UVData.self, from: userDefaultsData),
//           let firstItem = decodedData.items.first,
//           timeValidation(date: firstItem.timestamp).canUpdate {
//            let uvData = converter(data: decodedData)
//            completion(uvData, validationStatus.nextDate)
//            return
//        }
        
        urlSession.dataTask(with: URL(string: urlString)!) { (data, _, err) in
            guard err == nil else {
//                print(err!.localizedDescription)
                completion([UVWidgetData.previewData], validationStatus.nextDate)
                return
            }

            do{
                let jsonData = try decoder.decode(UVData.self, from: data!)
                let uvData = try converter(data: jsonData)
                completion(uvData, validationStatus.nextDate)
            } catch {
                completion([UVWidgetData.previewData], validationStatus.nextDate)
            }
        }.resume()
    }
    
    static func timeValidation(date: Date) -> (nextDate: Date, canUpdate: Bool) {
        let calendar = Calendar.singapore
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let nextUpdateTime: Date
        let canUpdate: Bool
        if hour < startingHourThreshold {
            let today = calendar.startOfDay(for: date)
            let dateComponents = DateComponents(hour: dateHoursOffset, minute: dateMinutesOffset)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: today)!
            canUpdate = false
        } else if hour >= endingHourThreshold {
            let today = calendar.startOfDay(for: date)
            let dateComponents = DateComponents(day: dateDaysOffset, hour: dateHoursOffset, minute: dateMinutesOffset)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: today)!
            canUpdate = false
        } else {
            let minutesAddition = 60 + dateMinutesOffset - minutes
            let dateComponents = DateComponents(minute: minutesAddition)
            nextUpdateTime = calendar.date(byAdding: dateComponents, to: date)!
            canUpdate = true
        }
        
        return (nextUpdateTime, canUpdate)
    }
    
//    static func isUserDefaultTimeValid(date: Date, currentDate: Date = Date()) -> Bool {
//        let calendar = Calendar.singapore
//        guard date < currentDate,
//              calendar.isDateInToday(date) else { return false }
//
//        let currentHour = calendar.component(.hour, from: currentDate)
//        let hour = calendar.component(.hour, from: date)
//
//        return currentHour - hour > 0
//    }
    
    static func converter(data: UVData) throws -> [UVWidgetData] {
        guard let firstItem = data.items.first else { throw APIError.empty }
        
        let widgetData: [UVWidgetData] =  firstItem.records.compactMap { record -> UVWidgetData? in
            guard let uvIndex = UVIndex(from: record.value) else { return nil }
            return UVWidgetData(date: record.timestamp,
                                uvValue: String(record.value),
                                uvDescription: uvIndex.name())
        }.sorted { (leftData, rightData) -> Bool in
            leftData.date > rightData.date
        }
        
        guard widgetData.count > 0 else { throw APIError.empty }
        
        return widgetData
    }
    
}
