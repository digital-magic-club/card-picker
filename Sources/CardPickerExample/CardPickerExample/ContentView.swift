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
  @State private var card: Card?

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink(
          "Clock Face Swiping",
          destination: ClockFaceSwipingView(
            card: $card,
            delayBeforeSending: 2,
            shouldDismiss: true
          )
        )
        
        NavigationLink(
          "Home Screen",
          destination: HomeScreenView(card: $card)
        )

        if let card {
          Text(card.description)
        }
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
