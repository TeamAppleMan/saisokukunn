//
//  CreateAllDay.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/09/12.
//

import Foundation
import Firebase

class CreateAllDay {
    func createAllDay(startTime: Timestamp, endTime: Timestamp) -> Int {
        let startData = startTime.dateValue()
        let endDate = endTime.dateValue()
        let limit = endDate.timeIntervalSince(startData)
        var limitDay = Int(limit/60/60/24)
        if(limit>0){
            limitDay += 1
        }else{
            limitDay = 0
        }
        return Int(limitDay)
    }
}
