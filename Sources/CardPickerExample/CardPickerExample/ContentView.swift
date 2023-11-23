//
//  ContentView.swift
//  CardPickerExample
//
//  Created by Guillaume Bellut on 23/11/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import SwiftUI
import CardPicker

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink("CFS", destination: CardPickerView())
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
