//
//  HomeScreenView.swift
//  CardPicker
//
//  Created by Guillaume Bellut on 01/12/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import SwiftUI

protocol Iconable: Identifiable {
  var icon: Image? { get }
}

public struct HomeScreenView: View {
  @Binding private var card: Card?

  public init(card: Binding<Card?>) {
    self._card = card
  }

  public var body: some View {
    VStack {
      VStack {
        firstRow
        secondRow
        thirdRow
        forthRow
      }
      Spacer()
      dockRow
    }
    .frame(
      maxWidth: UIScreen.main.bounds.width,
      maxHeight: UIScreen.main.bounds.height
    )
    .background(
      Image(.wallpaper)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
    )
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
  }
}

// MARK: - Private

private extension HomeScreenView {
  var firstRow: some View {
    rowView(
      values: [
        Card.Value.ace,
        Card.Value.two,
        Card.Value.three,
        Card.Value.four
      ]
    )
  }

  var secondRow: some View {
    rowView(
      values: [
        Card.Value.ace,
        Card.Value.two,
        Card.Value.three,
        Card.Value.four
      ]
    )
  }

  var thirdRow: some View {
    rowView(
      values: [
        Card.Value.ace,
        Card.Value.two,
        Card.Value.three,
        Card.Value.four
      ]
    )
  }

  var forthRow: some View {
    let any: [any Iconable] = [Card.Value.king, Card.joker]
    rowView(
      values: any
    )
  }

  var dockRow: some View {
    HStack {
      Card.Suit.spades.icon
      Card.Suit.hearts.icon
      Card.Suit.clubs.icon
      Card.Suit.diamonds.icon
    }
  }

  func rowView(_ subview: some View) -> some View {
    HStack {
      subview
    }
  }
}

struct RowViewModifier: ViewModifier {
  
}

extension Card.Value: Iconable {
  var icon: Image? {
    switch self {
    case .ace:
      Image(.ace)
    case .two:
      Image(.two)
    case .three:
      Image(.three)
    case .four:
      Image(.four)
    case .five:
      Image(.five)
    case .six:
      Image(.six)
    case .seven:
      Image(.seven)
    case .eight:
      Image(.eight)
    case .nine:
      Image(.nine)
    case .ten:
      Image(.ten)
    case .jack:
      Image(.jack)
    case .queen:
      Image(.queen)
    case .king:
      Image(.king)
    }
  }

  public var id: String {
    description(type: .short)
  }
}

extension Card.Suit: Iconable {
  var icon: Image? {
    switch self {
    case .spades:
      Image(.spades)
    case .hearts:
      Image(.hearts)
    case .clubs:
      Image(.clubs)
    case .diamonds:
      Image(.diamonds)
    }
  }

  public var id: String {
    description
  }
}

extension Card: Iconable {
  var icon: Image? {
    switch self {
    case .joker:
      Image(.joker)
    default:
      nil
    }
  }
}

#Preview {
  @State var card: Card?
  return HomeScreenView(card: $card)
}
