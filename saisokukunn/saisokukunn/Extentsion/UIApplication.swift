//
//  UIApplication.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/27.
//

import Foundation
import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
