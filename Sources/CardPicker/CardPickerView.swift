//
//  CardPickerView.swift
//  CardPicker
//
//  Created by Guillaume Bellut on 22/11/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import SwiftUI

public struct CardPickerView: View {
  enum SwipeAction: String, Equatable {
    case up
    case left
    case down
    case right
  }

  @Binding private var card: Card?

  @State private var bufferedSwipes = [SwipeAction]()
  @State private var timer: Timer?

  @GestureState private var isDetectingLongPress = false

  @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

  private let suitsOrder = ["♠️", "♥️", "♣️", "♦️"]

  public init(
    card: Binding<Card?>
  ) {
    self._card = card
  }

  public var body: some View {
    ZStack {
      Color.black
        .simultaneousGesture(
          dragGesture
        )
        .simultaneousGesture(
          longPressGesture
        )
        .simultaneousGesture(
          tapGesture
        )

      if let card {
        Text(card.description)
      }
    }
    .colorScheme(.dark)
    .onChange(of: card) { newValue in
      if let card {
        print("New card received: \(card)")
      } else {
        print("Card reset")
        bufferedSwipes.removeAll()
      }

      let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
      switch card {
      case .basic, .joker:
        feedbackStyle = .heavy
      case .incomplete:
        feedbackStyle = .soft
      case nil:
        feedbackStyle = .rigid
      }
      UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    .onChange(of: isDetectingLongPress) { newValue in
      timer?.invalidate()

      if isDetectingLongPress {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
          card = nil
        }
      }
    }
    .onAppear {
      card = nil
    }
  }
}

// MARK: - Private

private extension CardPickerView {
  var dragGesture: some Gesture {
    DragGesture()
      .onEnded { gesture in
        switch card {
        case .basic, .joker:
          return
        default:
          break
        }

        if abs(gesture.translation.width) > abs(gesture.translation.height) {
          if gesture.translation.width > 0 {
            addSwipe(.right)
          } else {
            addSwipe(.left)
          }
        } else {
          if gesture.translation.height > 0 {
            addSwipe(.down)
          } else {
            addSwipe(.up)
          }
        }
      }
  }

  var longPressGesture: some Gesture {
    LongPressGesture(minimumDuration: 1, maximumDistance: 10)
      .updating($isDetectingLongPress) { currentState, gestureState,
        transaction in
        gestureState = currentState
      }
  }

  var tapGesture: some Gesture {
    TapGesture()
      .onEnded {
        switch card {
        case .incomplete, nil:
          return
        default:
          break
        }

        presentationMode.wrappedValue.dismiss()
      }
  }

  func addSwipe(_ swipeAction: SwipeAction) {
    print("Swipe \(swipeAction) detected")

    bufferedSwipes.append(swipeAction)

    switch bufferedSwipes.count {
    case 1:
      break

    case 2:
      guard let swipeInt = SwipeAction.swipeToInt(bufferedSwipes),
            let value = Card.Value(rawValue: swipeInt) else {
        card = .joker
        return
      }

      card = .incomplete(value: value, suit: nil)

    case 3:
      guard let card,
            let description = suitsOrder[safe: SwipeAction.swipeToInt(bufferedSwipes.last!) - 1],
            let swipesSuit = Card.Suit(basicDescription: description) else {
        return
      }

      switch card {
      case let .incomplete(value: cardFoundValue, suit: cardFoundSuit):
        guard let cardFoundValue = cardFoundValue,
              cardFoundSuit == nil else {
          return
        }
        self.card = .basic(value: cardFoundValue, suit: swipesSuit)

      default:
        return
      }

    default:
      return
    }
  }
}

private extension CardPickerView.SwipeAction {
  var imageSystemName: String {
    return "arrow.\(String(describing: self))"
  }

  static func swipeToInt(_ swipes: [CardPickerView.SwipeAction]) -> Int? {
    guard !swipes.isEmpty else {
      return nil
    }

    switch swipes.count {
    case 1:
      return swipeToInt(swipes.first!)

    case 2:
      switch swipes.first! {
      case .up:
        switch swipes.last! {
        case .up:
          return 12
        case .left:
          return 11
        case .down:
          return 13
        case .right:
          return 1
        }
      case .left:
        switch swipes.last! {
        case .up:
          return 10
        case .left:
          return 9
        case .down:
          return 8
        case .right:
          return 0
        }
      case .down:
        switch swipes.last! {
        case .up:
          return 0
        case .left:
          return 7
        case .down:
          return 6
        case .right:
          return 5
        }
      case .right:
        switch swipes.last! {
        case .up:
          return 2
        case .left:
          return 0
        case .down:
          return 4
        case .right:
          return 3
        }
      }

    default:
      var twoFirstSwipes = [CardPickerView.SwipeAction]()
      var otherSwipes = [CardPickerView.SwipeAction]()

      for i in 0 ..< swipes.count {
        if i < 2 {
          twoFirstSwipes.append(swipes[i])
        } else {
          otherSwipes.append(swipes[i])
        }
      }

      guard let otherSwipesInt = swipeToInt(otherSwipes),
            var twoFirstSwipesInt = swipeToInt(twoFirstSwipes) else {
        return nil
      }

      if twoFirstSwipesInt >= 10 {
        twoFirstSwipesInt = 0
      }

      return Int("\(otherSwipesInt)\(twoFirstSwipesInt)")
    }
  }

  static func swipeToInt(_ swipe: CardPickerView.SwipeAction) -> Int {
    switch swipe {
    case .up:
      return 1
    case .left:
      return 4
    case .down:
      return 3
    case .right:
      return 2
    }
  }
}

extension CardPickerView.SwipeAction: Identifiable {
  var id: String {
    rawValue
  }
}
