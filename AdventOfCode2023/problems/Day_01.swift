//
//  Day_1.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/21/24.
//

class Day_01 {
  func run() {
    //    let input = File_Utils().readFile(named: "day_1_example_1", withExtension: "txt")
    //    let input = File_Utils().readFile(named: "day_1_example_2", withExtension: "txt")
    let input = File_Utils().readFile(named: "day_1", withExtension: "txt")

    part1(data: input)
    part2(data: input)
  }

  func part1(data: [String]) {
    var rollingSum: Int = 0
    for line in data {
      let wordsRmoved = line.filter(\.isNumber)
      let firstDigit = wordsRmoved.first ?? "0"
      let lastDigit = wordsRmoved.last ?? wordsRmoved.first ?? "0"

      let wordsum = Int(String(firstDigit) + String(lastDigit)) ?? 0
      rollingSum += wordsum
    }

    print("day 1: \(rollingSum)")
  }

  func part2(data: [String]) {
    let stringToNumberMapping: [String: String] = [
      "one": "one1one",
      "two": "two2two",
      "three": "three3three",
      "four": "four4four",
      "five": "five5five",
      "six": "six6six",
      "seven": "seven7seven",
      "eight": "eight8eight",
      "nine": "nine9nine",
    ]
    var sum: Int = 0
    var reMapped: [String] = []

    for line in data {
      var newWord = line
      for (key, value) in stringToNumberMapping {
        let temp = newWord
        newWord = temp.replacingOccurrences(of: key, with: value)
      }
      reMapped.append(newWord)
    }

    for line in reMapped {
      let charsRemoved = line.filter(\.isNumber)
      let firstDigit = charsRemoved.first ?? "0"
      let lastDigit = charsRemoved.last ?? "0"

      let wordsum = Int(String(firstDigit) + String(lastDigit)) ?? 0
      sum += wordsum
    }

    print("day 2: \(sum)")
  }
}
