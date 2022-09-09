//
//  createLimiteDay.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/09/09.
//

import Foundation
import Firebase

class CreateLimiteDay {
    func createLimitDay(endTime: Timestamp) -> Int {
        let endDate = endTime.dateValue()
        let now = Date()
        let limit = endDate.timeIntervalSince(now)
        var limitDay = Int(limit/60/60/24)
        if(limit>0){
            limitDay += 1
        }else{
            limitDay = 0
        }
        return Int(limitDay)
    }
}
