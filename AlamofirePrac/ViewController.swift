//
//  ViewController.swift
//  AlamofirePrac
//
//  Created by Chun-Li Cheng on 2023/8/5.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let baseUrl = "https://opendata.cwb.gov.tw/api"
    let urlComponent = "/v1/rest/datastore/"
    let authCode = "CF"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = baseUrl + urlComponent
        
        let headers: HTTPHeaders = [
            .authorization(authCode),
            .accept("application/json")
//            "Authorization": "\(authCode)",
//            "Accept": "application/json"
        ]
        
//        AF.request(url, method: .get, headers: headers).validate().responseJSON {
//            (response: AFDataResponse<Any>) in
//
//            switch response.result {
//            case .success(let value):
//
//                self.decodeUsingSwiftyJSON(value)
////                self.decodeUsingSwiftyJSON(response.data)
//
////                guard let value = value as? [String: AnyObject] else { return }
////                self.decodeUsingDataStructure(value)
//
////                guard let data = response.data else { return }
////                self.decodeUsingJsonSerialization(data)
//
////                guard let value = response.data else { return }
////                self.decodeUsingJsonDecoder(value)
//
////                print("Response: \(value)")
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable {
            (response: DataResponse<JsonData, AFError>) in

            switch response.result {
            case .success(let value):

                for location in value.records.location {
                    for weatherElement in location.weatherElement {
                        for time in weatherElement.time {
                            print("locationName: \(location.locationName)")         // 所在縣市
                            print("parameterName: \(time.parameter.parameterName)") // 天氣狀況
                            print("startTime: \(time.startTime)")                   // 起始時間
                            print("endTime: \(time.endTime)")                       // 結束時間
                            print()
                        }
                    }
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        
    }

    /// 可用 response.data，也可用 respons.result 中取回的 value
    private func decodeUsingSwiftyJSON(_ value: Any?) {
        
        guard let any = value else { return }
        
//        let jsonData = JSON(any)
//        let records = jsonData["records"]   // not Array
//        let locations = records["location"]
//
//        for location in locations {
//            let locationName = location.1["locationName"]   // not Array
//            let weatherElements = location.1["weatherElement"]
//
//            for weatherElement in weatherElements {
//                let times = weatherElement.1["time"]
//
//                for time in times {
//                    let startTime = time.1["startTime"]
//                    let endTime = time.1["endTime"]
//                    let parameter = time.1["parameter"]
//                    let parameterName = parameter["parameterName"]
//
//                    print(location.1["locationName"])
//                    print(time.1["parameter"]["parameterName"])
//                    print(time.1["startTime"])
//                    print(time.1["endTime"])
//                    print()
//                }
//            }
//        }
        
        for location in JSON(any)["records"]["location"] {
            for weatherElement in location.1["weatherElement"] {
                for time in weatherElement.1["time"] {
                    print(location.1["locationName"])
                    print(time.1["parameter"]["parameterName"])
                    print(time.1["startTime"])
                    print(time.1["endTime"])
                    print()
                }
            }
        }
        
    }
    
    /// 用 response.result 中取回的 value
    private func decodeUsingDataStructure(_ value: [String: AnyObject]?) {
        
        if let result = value,
           let locations = result["records"]?["location"] as? [[String: Any]] {
            
            for location in locations {
                if let locationName = location["locationName"] as? String,
                   let weatherElements = location["weatherElement"] as? [[String: Any]] {
                    
                    for weatherElement in weatherElements {
                        if let times = weatherElement["time"] as? [[String: Any]] {
                            
                            for time in times {
                                if let startTime = time["startTime"] as? String,
                                   let endTime = time["endTime"] as? String,
                                   let parameter = time["parameter"] as? [String: Any],
                                   let parameterName = parameter["parameterName"] as? String {
                                    
                                    print("locationName: \(locationName)")   // 所在縣市
                                    print("parameterName: \(parameterName)") // 天氣狀況
                                    print("startTime: \(startTime)")         // 起始時間
                                    print("endTime: \(endTime)")             // 結束時間
                                    print()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /// 用 JSONSerialization 解析 response.data
    private func decodeUsingJsonSerialization(_ value: Data?) {
        
        guard let data = value else { return }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
               let records = jsonObject["records"] as? [String: Any],
               let locations = records["location"] as? [[String: Any]] {

                for location in locations {
                    if let locationName = location["locationName"] as? String,
                       let weatherElements = location["weatherElement"] as? [[String: Any]] {
                        
                        for weatherElement in weatherElements {
                            if let times = weatherElement["time"] as? [[String: Any]] {
                                
                                for time in times {
                                    if let startTime = time["startTime"] as? String,
                                       let endTime = time["endTime"] as? String,
                                       let parameter = time["parameter"] as? [String: Any],
                                       let parameterName = parameter["parameterName"] as? String {
                                            print("locationName: \(locationName)")
                                            print("parameterName: \(parameterName)")
                                            print("startTime: \(startTime)")
                                            print("endTime: \(endTime)")
                                            print()
                                     }
                                }
                            }
                        }
                    }
                }
            }
        } catch { print("JSON parsing error: \(error)") }

    }
    
    /// 用 JSONDecoder 解析 response.data
    private func decodeUsingJsonDecoder(_ value: Data?) {
        
        guard let data = value else { return }
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(JsonData.self, from: data)
            
            for location in jsonData.records.location {
                for weatherElement in location.weatherElement {
                    for time in weatherElement.time {
                        print("locationName: \(location.locationName)")         // 所在縣市
                        print("parameterName: \(time.parameter.parameterName)") // 天氣狀況
                        print("startTime: \(time.startTime)")                   // 起始時間
                        print("endTime: \(time.endTime)")                       // 結束時間
                        print()
                    }
                }
            }
        } catch { print("Can't parse it.") }

    }
    

}

