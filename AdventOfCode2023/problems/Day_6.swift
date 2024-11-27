//
//  Day 6.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/25/24.
//

import Foundation

class Day_6 {
//    let input: [String] = File_Utils().readFile(named: "d6_e1", withExtension: "txt")
  //  let input: [String] = File_Utils().readFile(named: "d6_e2", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d6", withExtension: "txt")
  let helper = Helper()
  
  func run() {
    part1()
    part2()
  }
  
  func part1() {
    let races = helper.deseriallize(input)
    var timesBeatRecord: [Int] = []
    
    for race in races {
      let time = race.time
      let recordDistance = race.distance
      var beatRecord: Int = 0
      
      for velocity in 0...time {
        let remainingTime = time - velocity
        let distanceTraveled = velocity * remainingTime
        if distanceTraveled > recordDistance {
          beatRecord += 1
        }
      }
      timesBeatRecord.append(beatRecord)
    }
    
    print("Part 1: \(timesBeatRecord.reduce(1, *))")
  }
  
  func part2() {
    let race = helper.deseriallizePart2(input)
    var beatRecord: Int = 0

    for velocity in 0...race.time {
      let remainingTime = race.time - velocity
      let distanceTraveled = velocity * remainingTime
      if distanceTraveled > race.distance {
        beatRecord += 1
      }
    }
    print("Part 2: \(beatRecord)")
  }
  
  internal class Helper {
    func deseriallize(_ input: [String]) -> [Race] {
      var timeArr: [Int] = []
      var distanceArr: [Int] = []
      
      for line in input {
        if line.contains("Time:") {
          let split = line.replacingOccurrences(of: "Time:", with: "").split(separator: " ")
          for i in split {
            timeArr.append(Int(i)!)
          }
        } else {
          let split = line.replacingOccurrences(of: "Distance:", with: "").split(separator: " ")
          for i in split {
            let distance = Int(i)!
            distanceArr.append(distance)
          }
        }
      }
      
      let races: [Race] = zip(timeArr, distanceArr).map(Race.init)
      return races
    }
    
    func deseriallizePart2(_ input: [String]) -> Race {
      var distance: String = ""
      var time: String = ""
      
      for line in input {
        if line.contains("Time:") {
          let split = line.replacingOccurrences(of: "Time:", with: "").split(separator: " ")
          split.forEach { time += $0 }
        } else {
          let split = line.replacingOccurrences(of: "Distance:", with: "").split(separator: " ")
          split.forEach { distance += $0 }
        }
      }
      
      return Race(time: Int(time)!, distance: Int(distance)!)
    }
  }
  
  internal class Race {
    let time: Int
    let distance: Int
    
    init(time: Int, distance: Int) {
      self.time = time
      self.distance = distance
    }
  }
}


