//
//  Day_4.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/23/24.
//

import Foundation

class Day_04 {
  //    let input: [String] = File_Utils().readFile(named: "d4_e1", withExtension: "txt")
  //    let input: [String] = File_Utils().readFile(named: "d4_e2", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d4", withExtension: "txt")
  let helper = Helper()

  func run() {
    part1()
    part2()
  }

  func part1() {
    var totalScore: Decimal = 0
    for line in input {
      guard !line.isEmpty else { continue }
      let cardScore = helper.deserialize(line)
      let realScore = cardScore.score > 0 ? pow(2, cardScore.score - 1) : 0
      totalScore += realScore
    }
    print("Part 1: Total score: \(totalScore)")
  }

  func part2() {
    var scratchCards: [Int: Int] = [:]
    var totalScore: Int = 0
    for line in input {
      guard !line.isEmpty else { continue }

      let cardScore = helper.deserialize(line)
      scratchCards[cardScore.gameNumber, default: 0] += 1
      guard cardScore.score > 0 else { continue }

      var numCardCopies = scratchCards[cardScore.gameNumber] ?? 0
      repeat {
        for i in 1...cardScore.score {
          scratchCards[cardScore.gameNumber + i, default: 0] += 1
        }
        numCardCopies -= 1
      } while numCardCopies > 0
    }

    for (_, value) in scratchCards {
      totalScore += value
    }
    print("Part 2: Total score: \(totalScore)")
  }

  internal class Helper {
    func deserialize(_ fullCard: String) -> (gameNumber: Int, score: Int) {
      var cardScore = 0
      let temp = fullCard.split(separator: ":")

      let values = temp[1].split(separator: "|")
      let cardNumber =
        Int(
          temp[0].replacingOccurrences(of: "Card", with: "").filter { !$0.isWhitespace }
            .replacingOccurrences(of: ":", with: "")) ?? -1
      let winningNumbers: [Int: Int] = values[0].split(separator: " ").reduce(into: [:]) {
        (result, value) in
        let number = Int(value) ?? 0
        result[number] = (result[number] ?? 0) + 1
      }

      let playerNumbers: [Int] = {
        var numbers: [Int] = []
        let list = values[1].split(separator: " ")
        for number in list {
          numbers.append(Int(number)!)
        }
        return numbers
      }()

      for number in playerNumbers {
        if winningNumbers[number] == nil {
          cardScore += 0
        } else if winningNumbers[number]! > 0 {
          cardScore += 1
        }
      }

      return (cardNumber, cardScore)
    }
  }
}
