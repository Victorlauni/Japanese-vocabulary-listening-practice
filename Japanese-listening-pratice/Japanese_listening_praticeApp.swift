//
//  Japanese_listening_praticeApp.swift
//  Japanese-listening-pratice
//
//  Created by Victor Lau on 7/3/2021.
//

import SwiftUI

class wordlist: ObservableObject {
    @Published var list: [String] = []
}

@main
struct Japanese_listening_praticeApp: App {
    let wordList = wordlist()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wordList)
                .frame(minWidth: 100, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: 300, minHeight: 100, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 300, alignment: .center)
        }.commands() {
            Menubar(wordList: wordList)
        }
    }
}
