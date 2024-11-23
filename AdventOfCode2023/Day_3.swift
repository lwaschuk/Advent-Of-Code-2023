//
//  Day_3.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/22/24.
//

import Foundation

class Day_3 {
  static let LEFT = (-1, 0)
  static let RIGHT = (1, 0)
  static let TOP = (0, -1)
  static let BOTTOM = (0, 1)
  static let TOP_LEFT = (-1, -1)
  static let TOP_RIGHT = (1, -1)
  static let BOTTOM_LEFT = (-1, 1)
  static let BOTTOM_RIGHT = (1, 1)
  
//  let input: [String] = File_Utils().readFile(named: "d3_e1", withExtension: "txt")
//  let input: [String] = File_Utils().readFile(named: "d3_e2", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d3", withExtension: "txt")
  let helper = EngineHelper()
  
  func run () {
    part1()
    part2()
  }
  
  func part1() {
    var engine = helper.convertToCharacters(input)
    let symbols: [Character] = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "|", "-", "=", "\\", "/"]
    var numbers: [Int] = []
    
    for y in 0..<engine.count {
      let row = engine[y]
      for x in 0..<row.count {
        if !engine[y][x].isNumber { continue }
        if helper.checkSchematic(x: x, y: y, for: engine, symbols: symbols).numOfSurrounding != 0 {
          let number = helper.collectNumber(x: x, y: y, engine: &engine)
          numbers.append(number)
        }
      }
    }
    print("Sum of engine schematic numbers: \(numbers.reduce(0, +))")
  }
  
  func part2() {
    var engine = helper.convertToCharacters(input)
    var gear_ratios = 0
    
    for y in 0..<engine.count {
      let row = engine[y]
      let symbols: [Character] = ["1" , "2", "3", "4", "5", "6", "7", "8", "9", "0"]
      for x in 0..<row.count {
        if helper.isGear(x: x, y: y, for: engine) {
          let output = helper.checkSchematic(x: x, y: y, for: engine, symbols: symbols)
          if output.numOfSurrounding == 2 {
            
            let first = helper.collectNumber(x: x + output.locations[0].0, y: y + output.locations[0].1, engine: &engine)
            let second = helper.collectNumber(x: x + output.locations[1].0, y: y + output.locations[1].1, engine: &engine)
            print("Found gear: \(first) * \(second)")
            let ratio = first * second
            gear_ratios += ratio
          }
        }
      }
    }
    print("Sum of gear ratios: \(gear_ratios)")
  }
  
  
  internal class EngineHelper {
    func isGear(x: Int, y: Int, for engine: [[Character]]) -> Bool {
      if engine[y][x] == "*" { return true }
      return false
    }
    
    func collectNumber(x: Int, y: Int, engine: inout [[Character]]) -> Int {
      var number = ""
      var leftFound: Bool = false
      var rightFound: Bool = false
      var x = x
    
      while !leftFound || !rightFound {
        let current = engine[y][x]
        if current.isNumber {
          if !leftFound {
            // check left is its . add current to number and go right, else go left
            if x == 0 {
              leftFound = true
              continue
            }
            let numToLeft = engine[y][x-1]
            if numToLeft.isNumber { x -= 1 }
            else { leftFound = true }
          } // !leftFound
          else {
            let current = engine[y][x]
            number.append(current)
            engine[y][x] = "."
            let lastPos = engine[y].count - 1
            if x == lastPos {
              rightFound = true
              continue
            }
            let numToRight = engine[y][x+1]
            if numToRight.isNumber {
              x += 1
            }
            else { rightFound = true }
          }
        } // engine[y][x].isNumber
      }
      return Int(number)!
    }
    
    func checkSchematic(x: Int, y: Int, for engine: [[Character]], symbols: [Character]) -> (numOfSurrounding: Int, locations: [(Int, Int)]){
      var num = 0
      var locations: [(Int, Int)] = []
      var topFound: Bool = false
      var topRightFound: Bool = false
      var topLeftFound: Bool = false
      var bottomFound: Bool = false
      var bottomRightFound: Bool = false
      var bottomLeftFound: Bool = false
      
      if isSymbol(input: getTop(x: x, y: y, engine: engine), symbols: symbols) {
        topFound = true
        if !(topLeftFound || topRightFound) {
          num += 1
          locations.append(TOP)
        }
      }
      	
      if isSymbol(input: getTopRight(x: x, y: y, engine: engine), symbols: symbols) {
        topRightFound = true
        if !topFound {
          num += 1
          locations.append(TOP_RIGHT)
        }
      }
      
      if isSymbol(input: getRight(x: x, y: y, engine: engine), symbols: symbols) {
        num += 1
        locations.append(RIGHT)
      }
      
      if isSymbol(input: getBottomRight(x: x, y: y, engine: engine), symbols: symbols) {
        bottomRightFound = true
        if !bottomFound {
          num += 1
          locations.append(BOTTOM_RIGHT)
        }
      }
      
      if isSymbol(input: getBottom(x: x, y: y , engine: engine), symbols: symbols) {
        bottomFound = true
        if !(bottomLeftFound || bottomRightFound) {
          num += 1
          locations.append(BOTTOM)
        }
      }
      
      if isSymbol(input: getBottomLeft(x: x, y: y, engine: engine), symbols: symbols) {
        bottomLeftFound = true
        if !bottomFound {
          num += 1
          locations.append(BOTTOM_LEFT)
        }
      }
      
      if isSymbol(input: getLeft(x: x, y: y, engine: engine), symbols: symbols) {
        num += 1
        locations.append(LEFT)
      }
      
      if isSymbol(input: getTopLeft(x: x, y: y, engine: engine), symbols: symbols) {
        topLeftFound = true
        if !topFound {
          num += 1
          locations.append(TOP_LEFT)
        }
      }
      
      return (num, locations)
    }
    
    func isSymbol(input: Character, symbols: [Character]) -> Bool {
      return symbols.contains(input)
    }
    
    func getTop(x: Int, y: Int, engine: [[Character]]) -> Character {
      if y > 0  {
        let row = engine[y-1]
        return row[x]
      }
      return "."
    }
    
    func getBottom(x: Int, y: Int, engine: [[Character]]) -> Character {
      if y < engine.count - 1 {
        let row = engine[y+1]
        return row[x]
      }
      return "."
    }
    
    func getLeft(x: Int, y: Int, engine: [[Character]]) -> Character {
      if x > 0 {
        let row = engine[y]
        return row[x-1]
      }
      return "."
    }
    
    func getRight(x: Int, y: Int, engine: [[Character]]) -> Character {
      if x < engine[y].count - 1  {
        let row = engine[y]
        return row[x+1]
      }
      return "."
    }
    
    func getTopLeft(x: Int, y: Int, engine: [[Character]]) -> Character {
      if y > 0 && x > 0  {
        let row = engine[y-1]
        return row[x-1]
      }
      return "."
    }
    
    func getTopRight(x: Int, y: Int, engine: [[Character]]) -> Character {
      if y > 0 && x < engine[y].count - 1 {
        let row = engine[y-1]
        return row[x+1]
      }
      return "."
    }
    
    func getBottomLeft(x: Int, y: Int, engine: [[Character]]) -> Character {
      if y < engine.count - 1 && x > 0 {
        let row = engine[y+1]
        return row[x-1]
      }
      return "."
    }
    
    func getBottomRight(x: Int, y: Int, engine: [[Character]]) -> Character {
        if y < engine.count - 1 && x < engine[y].count - 1 {
        let row = engine[y+1]
        return row[x+1]
      }
      return "."
    }
    
    func convertToCharacters(_ input: [String]) -> [[Character]] {
      var charArray: [[Character]] = []
      
      for line in input {
        let characters = Array(line)
        
        if characters.count > 0 {
          charArray.append( characters )
        }
        
      }
      return charArray
    }
  }
}


