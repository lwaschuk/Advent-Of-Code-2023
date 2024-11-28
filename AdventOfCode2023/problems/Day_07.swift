//
//  Day_7.swift
//  AoC-2024
//
//  Created by Lukas Waschuk on 11/25/24.
//

import Algorithms
import Foundation

class Day_07 {
  //  let input: [String] = File_Utils().readFile(named: "d7_e1", withExtension: "txt")
  //  let input: [String] = File_Utils().readFile(named: "d7_e2", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d7", withExtension: "txt")
  let helper = Helper()

  func run() {
    part1()
    part2()
  }

  func part1() {
    let hands = helper.deseriallize(input)
    let sortedHands = hands.sorted(by: <)
    var sum: Int = 0
    var multiplier: Int = 1
    for hand in sortedHands {
      sum += hand.getBid() * multiplier
      multiplier += 1
    }
    print("Part 1: \(sum)")
  }

  func part2() {
    let hands = helper.deseriallize(input, wild: true)

    for hand in hands {
      hand.findBestMatchForJack()
    }

    let sortedHands = hands.sorted(by: <)
    var sum: Int = 0
    var multiplier: Int = 1

    for hand in sortedHands {
      sum += hand.getBid() * multiplier
      multiplier += 1
    }

    print("Part 2: \(sum)")
  }

  internal class Hand: Equatable, Comparable {
    private var cards: [Card] = [] {
      didSet { if cards.count == 5 { self.rank = setRank() } }
    }
    private let bid: Int
    private var wild: Bool
    private var rank = Rank.HIGH_CARD
    private var remappedCards: [Card] = []

    init(bid: Int, wild: Bool = false) {
      self.bid = bid
      self.wild = wild
    }

    var description: String {
      return """
        Hand: \(cards.description) 
        \tBid: \(bid)
        \tRank: \(rank.description)
        \tRemapped Hand: \(remappedCards.description)\n
        """
    }

    func findBestMatchForJack() {
      if cards.contains(.WILD) {
        let wildCount = cards.filter({ $0 == .WILD }).count

        var types: [Card] = []
        for _ in 0..<wildCount {
          types.append(contentsOf: Card.allCases.filter({ $0 != .WILD && $0 != .JACK }))
        }

        for combination in types.combinations(ofCount: wildCount) {
          var wildsRemoved = cards.filter({ $0 != .WILD })
          for card in combination {
            wildsRemoved.append(card)
          }
          let newRank = setRank(with: wildsRemoved)

          if newRank > self.rank {
            self.rank = newRank
            remappedCards = wildsRemoved
          }

        }
      }
    }

    static func == (lhs: Hand, rhs: Hand) -> Bool {
      lhs.cards == rhs.cards
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
      if lhs.rank < rhs.rank {
        return true
      }
      if lhs.rank > rhs.rank {
        return false
      }
      if lhs.rank == rhs.rank {
        for (l, r) in zip(lhs.cards, rhs.cards) {
          if l == r {
            continue
          }
          if l < r {
            return true
          }
          if l > r {
            return false
          }
        }
      }
      return false
    }

    func add(_ card: Card) {
      cards.append(card)
    }

    func getCards() -> (c1: Card, c2: Card, c3: Card, c4: Card, c5: Card) {
      return (cards[0], cards[1], cards[2], cards[3], cards[4])
    }

    func getBid() -> Int {
      return bid
    }

    /// Sets the hands "rank"
    ///
    /// This creates a set of occurances ([1,2] would mean a single occurance of a card two pairs)
    ///
    /// - [1 item in cardset]: Five of a kind, where all five cards have the same label
    /// - [2 items in cardset and ]: Four of a kind, where four cards have the same label and one card has a different label
    /// - [2, 3]: Full house, where three cards have the same label, and the remaining two cards share a different label
    /// - [1, 3]: Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand
    /// - [1, 2]: Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label
    /// - [1, 2]: One pair, where two cards share one label, and the other three cards have a different label from the pair and each other
    /// - [1]: High card, where all cards' labels are distinct
    func setRank(with cards: [Card]? = nil) -> Rank {
      var cards = cards
      if cards == nil {
        cards = self.cards
      }
      guard let cards else { fatalError("Cannot set rank without cards") }
      let cardsSet: NSCountedSet = []
      for card in cards {
        cardsSet.add(card)
      }

      if cardsSet.count == 1 {
        return .FIVE_OF_A_KIND
      } else if cardsSet.count == 2 {
        for card in cards {
          if cardsSet.count(for: card) == 4 {
            return .FOUR_OF_A_KIND
          } else if cardsSet.count(for: card) == 3 {
            return .FULL_HOUSE
          }
        }
      } else if cardsSet.count == 3 {
        for card in cards {
          if cardsSet.count(for: card) == 3 {
            return .THREE_OF_A_KIND
          }
        }
        return .TWO_PAIR
      } else if cardsSet.count == 4 {
        return .PAIR
      } else if cardsSet.count == 5 {
        return .HIGH_CARD
      }
      return .NOTHING
    }

    func getRank() -> Rank {
      return rank
    }
  }

  internal enum Rank: Int, Equatable, Comparable, CaseIterable, CustomStringConvertible {
    case NOTHING = 0
    case HIGH_CARD = 1
    case PAIR = 2
    case TWO_PAIR = 3
    case THREE_OF_A_KIND = 4
    case FULL_HOUSE = 5
    case FOUR_OF_A_KIND = 6
    case FIVE_OF_A_KIND = 7

    public var description: String {
      switch self {
        case .NOTHING: return "NOTHING"
        case .HIGH_CARD: return "HIGH_CARD"
        case .PAIR: return "PAIR"
        case .TWO_PAIR: return "TWO_PAIR"
        case .THREE_OF_A_KIND: return "THREE_OF_A_KIND"
        case .FULL_HOUSE: return "FULL_HOUSE"
        case .FOUR_OF_A_KIND: return "FOUR_OF_A_KIND"
        case .FIVE_OF_A_KIND: return "FIVE_OF_A_KIND"
      }
    }

    static func == (lhs: Rank, rhs: Rank) -> Bool {
      lhs.rawValue == rhs.rawValue
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
      lhs.rawValue < rhs.rawValue
    }
  }

  internal enum Card: Int, Equatable, Comparable, CaseIterable, CustomStringConvertible {
    case WILD = 1
    case TWO = 2
    case THREE = 3
    case FOUR = 4
    case FIVE = 5
    case SIX = 6
    case SEVEN = 7
    case EIGHT = 8
    case NINE = 9
    case TEN = 10
    case JACK = 11
    case QUEEN = 12
    case KING = 13
    case ACE = 14

    var description: String {
      switch self {
        case .WILD: return "WILD"
        case .TWO: return "TWO"
        case .THREE: return "THREE"
        case .FOUR: return "FOUR"
        case .FIVE: return "FIVE"
        case .SIX: return "SIX"
        case .SEVEN: return "SEVEN"
        case .EIGHT: return "EIGHT"
        case .NINE: return "NINE"
        case .TEN: return "TEN"
        case .JACK: return "JACK"
        case .QUEEN: return "QUEEN"
        case .KING: return "KING"
        case .ACE: return "ACE"
      }
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
      lhs.rawValue == rhs.rawValue
    }

    static func < (lhs: Card, rhs: Card) -> Bool {
      lhs.rawValue < rhs.rawValue
    }
  }

  internal class Helper {
    func deseriallize(_ input: [String], wild: Bool = false) -> [Hand] {
      var hands: [Hand] = []
      for line in input {
        guard !line.isEmpty else { continue }
        let temp = line.split(separator: " ")
        let cards = temp[0]
        let bid = Int(temp[1])!
        let hand = Hand(bid: bid, wild: wild)
        for card in cards {
          switch card {
            case "2": hand.add(.TWO)
            case "3": hand.add(.THREE)
            case "4": hand.add(.FOUR)
            case "5": hand.add(.FIVE)
            case "6": hand.add(.SIX)
            case "7": hand.add(.SEVEN)
            case "8": hand.add(.EIGHT)
            case "9": hand.add(.NINE)
            case "T": hand.add(.TEN)
            case "J": if wild { hand.add(.WILD) } else { hand.add(.JACK) }
            case "Q": hand.add(.QUEEN)
            case "K": hand.add(.KING)
            case "A": hand.add(.ACE)
            default: fatalError("Unknown card: \(card)")
          }
        }
        hands.append(hand)

      }
      return hands
    }
  }
}
