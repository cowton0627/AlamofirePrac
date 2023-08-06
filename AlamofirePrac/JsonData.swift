//
//  JsonData.swift
//  AlamofirePrac
//
//  Created by Chun-Li Cheng on 2023/8/5.
//

import Foundation

struct JsonData: Decodable {
    let success: String
    let records: Record
}
 
struct Record: Decodable {
    let location: [Location]
}

struct Location: Decodable {
    let locationName: String
    let weatherElement: [WeatherElement]
}

struct WeatherElement: Decodable {
    let time: [Time]
}

struct Time: Decodable {
    let startTime: String
    let endTime: String
    let parameter: Describe
}

struct Describe: Decodable {
    let parameterName: String
}
