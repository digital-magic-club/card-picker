//
//  Card.swift
//  CardPicker
//
//  Created by Guillaume Bellut on 23/11/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import Foundation

public enum Card {
  case basic(value: Card.Value, suit: Card.Suit)
  case incomplete(value: Card.Value?, suit: Card.Suit?)
  case joker

  public enum Value: Int, Codable, CaseIterable {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13

    init?(localizedDescription: String) {
      let lowercasedDescription = localizedDescription.lowercased()
      let words = lowercasedDescription.components(separatedBy: " ")

      for value in Card.Value.all where words.contains(value.localizedValue.lowercased()) {
        self = value
        return
      }

      return nil
    }

    init?(basicDescription: String) {
      switch basicDescription {
      case _ where basicDescription.range(of: "Ace of ") != nil:
        self = .ace
        return
      case _ where basicDescription.range(of: "Jack of ") != nil:
        self = .jack
        return
      case _ where basicDescription.range(of: "Queen of ") != nil:
        self = .queen
        return
      case _ where basicDescription.range(of: "King of ") != nil:
        self = .king
        return
      case _ where basicDescription.range(of: " of ") != nil:
        guard let value = Int(basicDescription.components(separatedBy: " of ")[0]),
              let cardValue = Card.Value(rawValue: value) else {
          return nil
        }
        self = cardValue
        return
      default:
        return nil
      }
    }

    init?(identifier: Character) {
      guard let suit = Card.Value.all.first(where: { $0.identifier == identifier }) else {
        return nil
      }

      self = suit
    }

    var identifier: Character {
      switch self {
      case .ace:
        "1"
      case .two:
        "2"
      case .three:
        "3"
      case .four:
        "4"
      case .five:
        "5"
      case .six:
        "6"
      case .seven:
        "7"
      case .eight:
        "8"
      case .nine:
        "9"
      case .ten:
        "0"
      case .jack:
        "J"
      case .queen:
        "Q"
      case .king:
        "K"
      }
    }
    var alternateVoiceValue: Card.Value {
      switch self {
      case .ace:
        .king
      default:
        Card.Value(rawValue: self.rawValue - 1)!
      }
    }

    var localizedPrefix: String {
      switch self {
      case .ace:
        return NSLocalizedString("the [Ace]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the Ace of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .two:
        return NSLocalizedString("the [2]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 2 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .three:
        return NSLocalizedString("the [3]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 3 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .four:
        return NSLocalizedString("the [4]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 4 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .five:
        return NSLocalizedString("the [5]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 5 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .six:
        return NSLocalizedString("the [6]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 6 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .seven:
        return NSLocalizedString("the [7]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 7 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .eight:
        return NSLocalizedString("the [8]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 8 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .nine:
        return NSLocalizedString("the [9]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 9 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .ten:
        return NSLocalizedString("the [10]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the 10 of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .jack:
        return NSLocalizedString("the [Jack]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the Jack of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .queen:
        return NSLocalizedString("the [Queen]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the Queen of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      case .king:
        return NSLocalizedString("the [King]",
                                 value: "the ",
                                 comment: "Translate 'the ' from 'the King of Hearts'. Some languages have a different translations regarding the card's value. Do not forget the optional space.")
      }
    }

    var localizedValue: String {
      switch self {
      case .ace:
        NSLocalizedString("Ace",
                                 comment: "From 'Ace of Hearts'")
      case .jack:
        NSLocalizedString("Jack",
                                 comment: "From 'Jack of Hearts'")
      case .queen:
        NSLocalizedString("Queen",
                                 comment: "From 'Queen of Hearts'")
      case .king:
        NSLocalizedString("King",
                                 comment: "From 'King of Hearts'")
      default:
        "\(rawValue)"
      }
    }

    func description(type: CardDescriptionType) -> String {
      switch self {

      case .ace:
        switch type {
        case .short:
          return "A"
        case .incomplete:
          return "Ace"
        case .basic:
          return "Ace of "
        case .localized, .localizedWithoutSymbol:
          return localizedValue
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          return "\(localizedPrefix) \(localizedValue)"
        }

      case .jack:
        switch type {
        case .short:
          return "J"
        case .incomplete:
          return "Jack"
        case .basic:
          return "Jack of "
        case .localized, .localizedWithoutSymbol:
          return localizedValue
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          return "\(localizedPrefix) \(localizedValue)"
        }

      case .queen:
        switch type {
        case .short:
          return "Q"
        case .incomplete:
          return "Queen"
        case .basic:
          return "Queen of "
        case .localized, .localizedWithoutSymbol:
          return localizedValue
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          return "\(localizedPrefix) \(localizedValue)"
        }

      case .king:
        switch type {
        case .short:
          return "K"
        case .incomplete:
          return "King"
        case .basic:
          return "King of "
        case .localized, .localizedWithoutSymbol:
          return localizedValue
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          return "\(localizedPrefix) \(localizedValue)"
        }

      default:
        switch type {
        case .short, .incomplete:
          return "\(self.rawValue)"
        case  .basic:
          return "\(self.rawValue) of "
        case .localized, .localizedWithoutSymbol:
          return localizedValue
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          return "\(localizedPrefix) \(localizedValue)"
        }
      }
    }

    static var all: [Card.Value] {
      var values: [Card.Value] = []

      for i in 1...13 {
        if let value = Card.Value(rawValue: i) {
          values.append(value)
        }
      }

      return values
    }
  }

  public enum Suit: Int, Codable, CaseIterable {
    case spades = 1
    case hearts = 2
    case clubs = 3
    case diamonds = 4

    init?(localizedDescription: String) {
      let lowercasedDescription = localizedDescription.lowercased()
      let words = lowercasedDescription.components(separatedBy: " ")

      for suit in Card.Suit.all where words.contains(suit.localizedSuit.lowercased()) {
        self = suit
        return
      }

      return nil
    }

    init?(basicDescription: String) {
      switch basicDescription {
      case _ where basicDescription.range(of: "♠️") != nil:
        self = .spades
        return
      case _ where basicDescription.range(of: "♥️") != nil:
        self = .hearts
        return
      case _ where basicDescription.range(of: "♣️") != nil:
        self = .clubs
        return
      case _ where basicDescription.range(of: "♦️") != nil:
        self = .diamonds
        return
      default:
        return nil
      }
    }

    init?(identifier: Character) {
      guard let suit = Card.Suit.all.first(where: { $0.identifier == identifier }) else {
        return nil
      }

      self = suit
    }

    var identifier: Character {
      switch self {
      case .spades:
        "S"
      case .hearts:
        "H"
      case .clubs:
        "C"
      case .diamonds:
        "D"
      }
    }

    var alternateVoiceSuit: Card.Suit {
      switch self {
      case .spades:
        .clubs
      case .clubs:
        .spades
      case .hearts:
        .diamonds
      case .diamonds:
        .hearts
      }
    }

    var description: String {
      switch self {
      case .spades:
        "♠️"
      case .hearts:
        "♥️"
      case .clubs:
        "♣️"
      case .diamonds:
        "♦️"
      }
    }

    var localizedSuit: String {
      switch self {
      case .spades:
        NSLocalizedString("Spades", comment: "From 'Queen of Spades'")
      case .hearts:
        NSLocalizedString("Hearts", comment: "From 'Queen of Hearts'")
      case .clubs:
        NSLocalizedString("Clubs", comment: "From 'Queen of Clubs'")
      case .diamonds:
        NSLocalizedString("Diamonds", comment: "From 'Queen of Diamonds'")
      }
    }

    static var all: [Card.Suit] {
      var suits: [Card.Suit] = []

      for i in 1...4 {
        if let suit = Card.Suit(rawValue: i) {
          suits.append(suit)
        }
      }

      return suits
    }
  }

  enum CardDescriptionType {
    case short
    case incomplete
    case basic
    case localized
    case localizedWithoutSymbol
    case localizedWithPrefix
    case localizedWithPrefixWithoutSymbol
  }

  init?(localizedDescription: String) {
    let lowercasedDescription = localizedDescription.lowercased()
    let words = lowercasedDescription.components(separatedBy: " ")

    if words.contains(Card.joker.description(type: .localized).lowercased()) {
      self = .joker
      return
    }

    let value = Card.Value(localizedDescription: localizedDescription)
    let suit = Card.Suit(localizedDescription: localizedDescription)

    guard value != nil || suit != nil else {
      return nil
    }

    if let value = value,
       let suit = suit {
      self = .basic(value: value, suit: suit)
      return
    }

    self = .incomplete(value: value, suit: suit)
  }

  init?(basicDescription: String) {
    if basicDescription == "Joker" {
      self = .joker
      return
    }

    let value = Card.Value(basicDescription: basicDescription)
    let suit = Card.Suit(basicDescription: basicDescription)

    guard value != nil || suit != nil else {
      return nil
    }

    if let value = value,
       let suit = suit {
      self = .basic(value: value, suit: suit)
      return
    }

    self = .incomplete(value: value, suit: suit)
  }

  init?(identifier: String) {
    guard identifier.count == 2 else {
      return nil
    }

    if identifier == "JJ" {
      self = .joker
      return
    }

    let value: Value?
    let suit: Suit?

    if let valueIdentifier = identifier.first {
      value = Card.Value.init(identifier: valueIdentifier)
    } else {
      value = nil
    }

    if let suitIdentifier = identifier.last {
      suit = Card.Suit.init(identifier: suitIdentifier)
    } else {
      suit = nil
    }

    if value == nil && suit == nil {
      return nil
    } else if let value = value,
              let suit = suit {
      self = .basic(value: value, suit: suit)
    } else {
      self = .incomplete(value: value, suit: suit)
    }
  }

  static let mnemonicaStack: [Card] = [
    Card.basic(value: .four, suit: .clubs),
    Card.basic(value: .two, suit: .hearts),
    Card.basic(value: .seven, suit: .diamonds),
    Card.basic(value: .three, suit: .clubs),
    Card.basic(value: .four, suit: .hearts),
    Card.basic(value: .six, suit: .diamonds),
    Card.basic(value: .ace, suit: .spades),
    Card.basic(value: .five, suit: .hearts),
    Card.basic(value: .nine, suit: .spades),
    Card.basic(value: .two, suit: .spades),
    Card.basic(value: .queen, suit: .hearts),
    Card.basic(value: .three, suit: .diamonds),
    Card.basic(value: .queen, suit: .clubs),
    Card.basic(value: .eight, suit: .hearts),
    Card.basic(value: .six, suit: .spades),
    Card.basic(value: .five, suit: .spades),
    Card.basic(value: .nine, suit: .hearts),
    Card.basic(value: .king, suit: .clubs),
    Card.basic(value: .two, suit: .diamonds),
    Card.basic(value: .jack, suit: .hearts),
    Card.basic(value: .three, suit: .spades),
    Card.basic(value: .eight, suit: .spades),
    Card.basic(value: .six, suit: .hearts),
    Card.basic(value: .ten, suit: .clubs),
    Card.basic(value: .five, suit: .diamonds),
    Card.basic(value: .king, suit: .diamonds),
    Card.basic(value: .two, suit: .clubs),
    Card.basic(value: .three, suit: .hearts),
    Card.basic(value: .eight, suit: .diamonds),
    Card.basic(value: .five, suit: .clubs),
    Card.basic(value: .king, suit: .spades),
    Card.basic(value: .jack, suit: .diamonds),
    Card.basic(value: .eight, suit: .clubs),
    Card.basic(value: .ten, suit: .spades),
    Card.basic(value: .king, suit: .hearts),
    Card.basic(value: .jack, suit: .clubs),
    Card.basic(value: .seven, suit: .spades),
    Card.basic(value: .ten, suit: .hearts),
    Card.basic(value: .ace, suit: .diamonds),
    Card.basic(value: .four, suit: .spades),
    Card.basic(value: .seven, suit: .hearts),
    Card.basic(value: .four, suit: .diamonds),
    Card.basic(value: .ace, suit: .clubs),
    Card.basic(value: .nine, suit: .clubs),
    Card.basic(value: .jack, suit: .spades),
    Card.basic(value: .queen, suit: .diamonds),
    Card.basic(value: .seven, suit: .clubs),
    Card.basic(value: .queen, suit: .spades),
    Card.basic(value: .ten, suit: .diamonds),
    Card.basic(value: .six, suit: .clubs),
    Card.basic(value: .ace, suit: .hearts),
    Card.basic(value: .nine, suit: .diamonds)
  ]

  var alternateVoiceCard: Card {
    switch self {
    case .basic(let value, let suit):
      .basic(value: value.alternateVoiceValue, suit: suit.alternateVoiceSuit)
    default:
      self
    }
  }

  func description(type: CardDescriptionType) -> String {
    switch self {
    case .basic(let value, let suit):
      switch type {
      case .localized,
          .localizedWithoutSymbol,
          .localizedWithPrefix,
          .localizedWithPrefixWithoutSymbol:
        let suitDescription = type == .localizedWithPrefixWithoutSymbol || type == .localizedWithoutSymbol ? suit.localizedSuit : suit.description

        var description: String

        switch type {
        case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
          description = value.localizedPrefix
        default:
          description = ""
        }

        description += Card.valueFirstInDescription ? value.description(type: .localized) : suitDescription
        description += NSLocalizedString(" of ", comment: "From '5 of Hearts' for example. Do not forget spaces if they are needed. It can be a simple space if our language doesn't need any separator between the value and the suit of a card.")
        description += Card.valueFirstInDescription ? suitDescription : value.description(type: .localized)
        return description
      default:
        return "\(value.description(type: type))\(suit.description)"
      }
    case .joker:
      switch type {
      case .short:
        return "J"
      case .incomplete, .basic:
        return "Joker"
      case .localized, .localizedWithoutSymbol:
        return NSLocalizedString("Joker", comment: "the Joker card")
      case .localizedWithPrefix, .localizedWithPrefixWithoutSymbol:
        return NSLocalizedString("the Joker", comment: "the Joker card")
      }
    case .incomplete(let value, let suit):
      if let value = value {
        return value.description(type: type)
      }

      if let suit = suit {
        return suit.description
      }

      return "Error while returning incomplete card description: should be nil"
    }
  }

  var isComplete: Bool {
    switch self {
    case .basic, .joker:
      true

    case .incomplete:
      false
    }
  }

  private static let descriptionOrder: String = NSLocalizedString("[Queen] [of] [Hearts]", comment: "Do not translate anything here. Just move the word's position to give something correct in your language. For example, 'Queen of Hearts' gives 'Reine de Coeur' in French: the order remains the same so no change has to be applied here.")

  static var valueFirstInDescription: Bool {
    return descriptionOrder.range(of: "[Queen]")!.lowerBound < descriptionOrder.range(of: "[Hearts]")!.lowerBound
  }

  static var all: [Card] {
    var cards: [Card] = []

    for suit in Card.Suit.all {
      for value in Card.Value.all {
        cards.append(.basic(value: value, suit: suit))
      }
    }

    cards.append(.joker)

    return cards
  }
}

extension Card: Equatable {
  public static func == (lhs: Card, rhs: Card) -> Bool {
    switch (lhs, rhs) {
    case let (.basic(valueA, suitA), .basic(valueB, suitB)):
      valueA == valueB && suitA == suitB
    case let (.incomplete(valueA, suitA), .incomplete(valueB, suitB)):
      valueA == valueB && suitA == suitB
    case (.joker, .joker):
      true
    default:
      false
    }
  }
}

extension Card: CustomStringConvertible {
  public var description: String {
    description(type: .localized)
  }
}

extension Card: Identifiable {
  public var id: String {
    description(type: .basic)
  }
}

extension Card: Hashable {
}

extension Card: Codable {
  // Need to keep it as a decodable string since
  // Watch Connectivity is not compatible with codable enum

  enum CodingKeys: String, CodingKey {
    case basicDescription
    case basic
  }

  var dictionary: [String: Any] {
    var dictionary: [String: Any] = [:]

    dictionary[CodingKeys.basicDescription.rawValue] = description(type: .basic)

    return dictionary
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    // [1017] Legacy enum codable before 6.1.1
    if let dictionary = try? values.decode([String: Int].self, forKey: .basic),
       let suitInt = dictionary["suit"],
       let suit = Suit(rawValue: suitInt),
       let valueInt = dictionary["value"],
       let value = Value(rawValue: valueInt) {
      self = .basic(value: value, suit: suit)
      return
    }

    let basicDescription = try values.decode(String.self, forKey: .basicDescription)

    guard let card = Card(basicDescription: basicDescription) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Couldn't init card from found description \(basicDescription)"))
    }

    self = card
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(description(type: .basic), forKey: .basicDescription)
  }
}
