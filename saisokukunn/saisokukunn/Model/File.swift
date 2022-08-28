//
//  File.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/28.
//

import Foundation

class dateToString {
    let date: Date
    let dateFormatter = DateFormatter()

    init(date: Date) {
        self.date = date
    }

    func year() -> String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    func month() -> String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }

    func day() -> String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }

}
