//
//  ViewModelHelper.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Foundation

class ViewModelHelper {
    
    // Load JSON from url string
    func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
                if let error = error {
                    completion(.failure(error))
                }

                if let data = data {
                    completion(.success(data))
                }
            }

            urlSession.resume()
        }
    }

    // Parse data object. Return array of IPC
    func parse(jsonData: Data) -> [IPC]? {
        do {
            let decodedData = try JSONDecoder().decode([IPC].self, from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            return nil
        }
    }
    
    // Format iso date string to human friendly readable date
    func getFormattedDate(isoDate: String) -> String {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: isoDate) {
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: date)
            guard let day = calendarDate.day,
                  let year = calendarDate.year,
                  let month = calendarDate.month,
                  let hour = calendarDate.hour,
                  let minute = calendarDate.minute,
                  let second = calendarDate.second
            else {
                return ""
            }
            return "Date: \(months[month-1])-\(day)-\(year)   Time: \(hour):\(minute):\(second)"
        }
        return ""
    }

}
