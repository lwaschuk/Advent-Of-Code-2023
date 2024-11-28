//
//  Day_2.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/21/24.
//

import Foundation

class Day_02 {
  //  let input = File_Utils().readFile(named: "day_2_example_1", withExtension: "txt")
  //  let input = File_Utils().readFile(named: "day_2_example_2", withExtension: "txt")
  let input = File_Utils().readFile(named: "day_2", withExtension: "txt")

  func run() {
    part1()
    part2()
  }

  func part1() {
    let MAX_RED = 12
    let MAX_BLUE = 14
    let MAX_GREEN = 13
    var validGames: [Int] = []

    for game in input {
      guard !game.isEmpty else { continue }
      let parsedGame = CubeDeserializer(game: game).parse()
      let gameNumber = parsedGame.0
      let handfuls = parsedGame.1

      var isValid: Bool = true
      for handful in handfuls {
        let red = handful.red
        let blue = handful.blue
        let green = handful.green

        if red > MAX_RED || blue > MAX_BLUE || green > MAX_GREEN {
          isValid = false
        }
      }
      if isValid { validGames.append(gameNumber) }
    }
    print("Valid games: \(validGames.reduce(0, +))")
  }

  func part2() {
    var powerOfCubes: [Int] = []

    for game in input {
      guard !game.isEmpty else { continue }
      var MAX_RED = 0
      var MAX_BLUE = 0
      var MAX_GREEN = 0
      let parsedGame = CubeDeserializer(game: game).parse()
      let handfuls = parsedGame.1

      for handful in handfuls {
        let red = handful.red
        let blue = handful.blue
        let green = handful.green

        if red > MAX_RED { MAX_RED = red }
        if blue > MAX_BLUE { MAX_BLUE = blue }
        if green > MAX_GREEN { MAX_GREEN = green }
      }
      powerOfCubes.append(MAX_RED * MAX_BLUE * MAX_GREEN)
    }
    print("Power of cubes: \(powerOfCubes.reduce(0, +))")
  }

  /// A cube object is defined as follows
  /// ```
  /// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  /// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  /// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  /// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  /// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  /// ```
  /// Each hand is seperated by a semicolon (;)
  ///
  /// This will return the game number, number of blue, red, and green cubes
  internal class CubeDeserializer {
    var game: String

    init(game: String) {
      self.game = game
    }

    func parse() -> (Int, [HandfulOfCubes]) {
      var handfuls: [HandfulOfCubes] = []
      let temp = game.split(separator: ":")

      let gameNumber =
        Int(
          temp[0].replacingOccurrences(of: "Game ", with: "").replacingOccurrences(
            of: ":", with: "")) ?? 999_999_999

      let hands = temp[1].split(separator: ";")

      for handful in hands {
        let cubes = handful.split(separator: ",")

        let blueSubstring = cubes.filter({ $0.contains("blue") })
        let bluecount = Int(blueSubstring.description.filter({ $0.isNumber })) ?? 0

        let greenSubstring = cubes.filter({ $0.contains("green") })
        let greencount = Int(greenSubstring.description.filter({ $0.isNumber })) ?? 0

        let redSubstring = cubes.filter({ $0.contains("red") })
        let redcount = Int(redSubstring.description.filter({ $0.isNumber })) ?? 0

        handfuls.append(HandfulOfCubes(red: redcount, blue: bluecount, green: greencount))
      }

      return (gameNumber, handfuls)
    }
  }

  internal class HandfulOfCubes {
    var red: Int
    var blue: Int
    var green: Int

    init(red: Int, blue: Int, green: Int) {
      self.red = red
      self.blue = blue
      self.green = green
    }
  }
}
