//
//  SettingView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/11/06.
//

// https://www.yururiwork.net/archives/511

import SwiftUI

struct SettingView: View {

    @State private var isOn = false
    @State private var pickerSelection = 0

    @AppStorage("userName") var userName: String = ""

    let languages: [String] = [
        "English",
        "Japanease",
        "French",
        "Chinese"
    ]

    var body: some View {
        Form {
            HStack {
                Image(systemName: "person.circle")
                Button(userName, action: {})
            }

            Section(header: Text("General")) {
                HStack {
                    Text("Airplane Mode")
                    Spacer()
                    Toggle(isOn: $isOn) {
                        EmptyView()
                    }
                }
                HStack {
                    Picker(selection: $pickerSelection, label: Text("Language")) {
                        ForEach(0..<self.languages.count) { index in
                            Text(self.languages[index])
                        }
                    }
                }
            }

            Section(header: Text("About"), footer: Text("copyright ©︎ 20XX-20XX Apple All Rights Reserved.")) {
                HStack {
                    Text("Device Name")
                    Spacer()
                    Text(UIDevice.current.name)
                }
                HStack {
                    Text("Operating System")
                    Spacer()
                    Text(UIDevice.current.systemName)
                }
                HStack {
                    Text("Version")
                    Spacer()
                    Text(UIDevice.current.systemVersion)
                }
            }

        }
        .navigationBarTitle("設定")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
