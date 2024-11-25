//
//  Day_5.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/23/24.
//

import Foundation

class Day_5 {
//  let input: [String] = File_Utils().readFile(named: "d5_e1", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d5", withExtension: "txt")
  let helper = Helper()
  
  func run() {
    let locationsPart1 = getLocations(seeds: helper.getSeeds(from: input))
    print("Part 1: \(locationsPart1.min()!)")
    
    let seedsPart2 = helper.getSeeds(from: input)
    let updatedSeedsPart2 = helper.getUpdatedSeeds(from: seedsPart2)
    let locationsPart2 = getLocations(seeds: updatedSeedsPart2)
    print("Part 2: \(locationsPart2.min()!)")
  }
  
  func getLocations(seeds: [Int]) -> [Int] {
    let seedToSoilMapping = helper.extractMapping(from: input, for: "seed-to-soil map:")
    let soilToFertilizerMapping = helper.extractMapping(from: input, for: "soil-to-fertilizer map:")
    let fertilizerToWaterMapping = helper.extractMapping(from: input, for: "fertilizer-to-water map:")
    let waterToLightMapping = helper.extractMapping(from: input, for: "water-to-light map:")
    let lightToTemperatureMapping = helper.extractMapping(from: input, for: "light-to-temperature map:")
    let temperatureToHumidityMapping = helper.extractMapping(from: input, for: "temperature-to-humidity map:")
    let humidityToLocationMapping = helper.extractMapping(from: input, for: "humidity-to-location map:")

    var endLocations: [Int] = []

    for seed in seeds {
      let soilLocation = helper.getDistination(for: seed, in: seedToSoilMapping)
      let fertilizerLocation = helper.getDistination(for: soilLocation, in: soilToFertilizerMapping)
      let waterLocation = helper.getDistination(for: fertilizerLocation, in: fertilizerToWaterMapping)
      let lightLocation = helper.getDistination(for: waterLocation, in: waterToLightMapping)
      let temperatureLocation = helper.getDistination(for: lightLocation, in: lightToTemperatureMapping)
      let humidityLocation = helper.getDistination(for: temperatureLocation, in: temperatureToHumidityMapping)
      let endlocation = helper.getDistination(for: humidityLocation, in: humidityToLocationMapping)
      endLocations.append(endlocation)
    }
    return endLocations
  }
  
  func part_2() {
    
  }
  

  internal class SeedHelper {
    let seed: Int
    let range: Int
    
    init(seed: Int, range: Int) {
      self.seed = seed
      self.range = range
    }
  }
  
  internal class Helper {
    func makeSeedHelpers(from seeds: [Int]) -> [SeedHelper] {
      var updatedSeeds: [SeedHelper] = []
      var skipNext: Bool = false
      
      for i in 0..<seeds.count {
        if skipNext {
          skipNext = false
          continue
        }
        let seedStart = seeds[i]
        let range = seeds[i+1]
        
        updatedSeeds.append(SeedHelper(seed: seedStart, range: range))
        skipNext = true // skip the next entry cause its already been processed
      }
      return updatedSeeds
    }
    
    func getUpdatedSeeds(from seeds: [Int]) -> [Int] {
      var updatedSeeds: [Int] = []
      var skipNext: Bool = false
      
      for i in 0..<seeds.count {
        if skipNext {
          skipNext = false
          continue
        }
        let seedStart = seeds[i]
        let range = seeds[i+1]
        
        for i in 0..<range {
          updatedSeeds.append(seedStart + i)
          if i % 10000000 == 0 {
            print("Completed Seed: \(i)")
          }
        }
        skipNext = true // skip the next entry cause its already been processed
      }
      return updatedSeeds
    }
    
    func getDistination(for source: Int, in map: [Int: (destinationStart: Int, offset: Int)]) -> Int {
      for (sourceStart, (destinationStart, offset)) in map {
        if source >= sourceStart && source < sourceStart + offset {
          return destinationStart + (source - sourceStart)
        }
      }
      return source
    }
  
    func extractMapping(from input: [String], for header: String) -> [Int: (destinationStart: Int, offset: Int)] {
      var mapping: [Int: (Int, Int)] = [:]
      var found: Bool = false
      var exit: Bool = false
      
      for line in input {
        if line.contains(header) {
          found = true
          continue
        }
        if found {
          if exit { break }
          if line.isEmpty {
            exit = true
            continue
          }
          let split = line.split(separator: " ")
          let destinationStart = Int(split[0])!
          let sourceStart = Int(split[1])!
          let offsetData = Int(split[2])!
          
          mapping[sourceStart] = (destinationStart, offsetData)
        }
      }
      return mapping
    }
    
    func getSeeds(from input: [String]) -> [Int] {
      var seeds: [Int] = []
      for line in input {
        if line.contains("seeds:") {
          line
            .replacingOccurrences(of: "seeds:", with: "")
            .split(separator: " ")
            .forEach { seeds.append(Int($0)!) }
        }
      }
      return seeds
    }
  }
}
