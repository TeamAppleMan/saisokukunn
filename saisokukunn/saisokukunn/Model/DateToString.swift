//
//  File.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/28.
//

import Foundation

class DateToString {
    let date: Date
    let dateFormatter = DateFormatter()

    init(date: Date) {
        self.date = date
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
    }

    func year() -> String {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    func month() -> String {
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }

    func day() -> String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }

}
