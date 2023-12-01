//
//  ClockFaceSwipingView.swift
//  CardPicker
//
//  Created by Guillaume Bellut on 22/11/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import SwiftUI

public struct ClockFaceSwipingView: View {
  enum SwipeAction: String, Equatable {
    case up
    case left
    case down
    case right
  }

  @Binding private var bindedCard: Card?

  @State private var card: Card?
  @State private var bufferedSwipes = [SwipeAction]()
  @State private var longPressTimer: Timer?
  @State private var delayBeforeSendingTimer: Timer?

  @GestureState private var isDetectingLongPress = false

  @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

  private let suitsOrder = ["♠️", "♥️", "♣️", "♦️"]
  private let delayBeforeSending: TimeInterval?
  private let shouldDismiss: Bool

  public init(
    card: Binding<Card?>,
    delayBeforeSending: TimeInterval? = nil,
    shouldDismiss: Bool = false
  ) {
    self._bindedCard = card
    self._card = State(initialValue: card.wrappedValue)
    self.delayBeforeSending = delayBeforeSending
    self.shouldDismiss = shouldDismiss
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
        .ignoresSafeArea()

      feedbackView
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
    .colorScheme(.dark)
    .onChange(of: card) { newValue in
      if let newValue {
        print("New card received: \(newValue)")

        switch newValue {
        case .basic, .joker:
          if let delayBeforeSending {
            delayBeforeSendingTimer = Timer.scheduledTimer(
              withTimeInterval: delayBeforeSending,
              repeats: false
            ) { _ in
              bindedCard = card
              print("Card sent: \(newValue)")
            }
          }
        default:
          break
        }
      } else {
        print("Card reset")
        bufferedSwipes.removeAll()
        delayBeforeSendingTimer?.invalidate()
      }

      let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
      switch newValue {
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
      longPressTimer?.invalidate()

      if isDetectingLongPress {
        longPressTimer = Timer.scheduledTimer(
          withTimeInterval: 0.5,
          repeats: false
        ) { _ in
          card = nil
        }
      }
    }
    .onChange(of: bindedCard) { newValue in
      if newValue != nil && shouldDismiss {
        presentationMode.wrappedValue.dismiss()
      }
    }
    .onAppear {
      card = nil
      bindedCard = nil
    }
  }
}

// MARK: - Private

private extension ClockFaceSwipingView {
  @ViewBuilder
  var feedbackView: some View {
    if let card {
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text(card.description)
            .font(.system(.footnote))
            .opacity(0.2)
        }
      }
      .padding()
    }
  }

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

        bindedCard = card
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

private extension ClockFaceSwipingView.SwipeAction {
  var imageSystemName: String {
    return "arrow.\(String(describing: self))"
  }

  static func swipeToInt(_ swipes: [ClockFaceSwipingView.SwipeAction]) -> Int? {
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
      var twoFirstSwipes = [ClockFaceSwipingView.SwipeAction]()
      var otherSwipes = [ClockFaceSwipingView.SwipeAction]()

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

  static func swipeToInt(_ swipe: ClockFaceSwipingView.SwipeAction) -> Int {
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

extension ClockFaceSwipingView.SwipeAction: Identifiable {
  var id: String {
    rawValue
  }
}
