//
//  topBar.swift
//  Japanese-listening-pratice
//
//  Created by Victor Lau on 8/3/2021.
//

import SwiftUI

struct topBar: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
            Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
        }
    }
}

struct topBar_Previews: PreviewProvider {
    static var previews: some View {
        topBar()
    }
}
