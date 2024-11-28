//
//  Day_5.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/23/24.
//

import Foundation

class Day_05 {
  //  let input: [String] = File_Utils().readFile(named: "d5_e1", withExtension: "txt")
  let input: [String] = File_Utils().readFile(named: "d5", withExtension: "txt")
  let helper = Helper()

  func run() {
    let locationsPart1 = getLocations(seedList: helper.getSeeds(from: input))
    print("Part 1: \(locationsPart1.min()!)\n")

    let seedsPart2 = helper.getSeeds(from: input)
    let updatedSeedsPart2 = helper.getUpdatedSeeds(from: seedsPart2)
    let locationsPart2 = getLocations(seedRange: updatedSeedsPart2)
    print("Part 2: \(locationsPart2.min()!)")
  }

  func getLocations(seedRange: RangeSet<Int>? = nil, seedList: [Int]? = nil) -> [Int] {
    var seedToSoilMapping = helper.extractMapping(from: input, for: "seed-to-soil map:")
    var soilToFertilizerMapping = helper.extractMapping(from: input, for: "soil-to-fertilizer map:")
    var fertilizerToWaterMapping = helper.extractMapping(
      from: input, for: "fertilizer-to-water map:")
    var waterToLightMapping = helper.extractMapping(from: input, for: "water-to-light map:")
    var lightToTemperatureMapping = helper.extractMapping(
      from: input, for: "light-to-temperature map:")
    var temperatureToHumidityMapping = helper.extractMapping(
      from: input, for: "temperature-to-humidity map:")
    var humidityToLocationMapping = helper.extractMapping(
      from: input, for: "humidity-to-location map:")
    var endLocations: [Int] = []

    if let seedRange {
      for seedRan in seedRange.ranges {
        for seed in seedRan {
          let soilLocation = helper.getDistination(for: seed, in: &seedToSoilMapping)
          let fertilizerLocation = helper.getDistination(
            for: soilLocation, in: &soilToFertilizerMapping)
          let waterLocation = helper.getDistination(
            for: fertilizerLocation, in: &fertilizerToWaterMapping)
          let lightLocation = helper.getDistination(for: waterLocation, in: &waterToLightMapping)
          let temperatureLocation = helper.getDistination(
            for: lightLocation, in: &lightToTemperatureMapping)
          let humidityLocation = helper.getDistination(
            for: temperatureLocation, in: &temperatureToHumidityMapping)
          let endlocation = helper.getDistination(
            for: humidityLocation, in: &humidityToLocationMapping)
          endLocations.append(endlocation)
        }
      }
    } else if let seedList {
      for seed in seedList {
        let soilLocation = helper.getDistination(for: seed, in: &seedToSoilMapping)
        let fertilizerLocation = helper.getDistination(
          for: soilLocation, in: &soilToFertilizerMapping)
        let waterLocation = helper.getDistination(
          for: fertilizerLocation, in: &fertilizerToWaterMapping)
        let lightLocation = helper.getDistination(for: waterLocation, in: &waterToLightMapping)
        let temperatureLocation = helper.getDistination(
          for: lightLocation, in: &lightToTemperatureMapping)
        let humidityLocation = helper.getDistination(
          for: temperatureLocation, in: &temperatureToHumidityMapping)
        let endlocation = helper.getDistination(
          for: humidityLocation, in: &humidityToLocationMapping)
        endLocations.append(endlocation)
      }
    }
    return endLocations
  }
}

internal class Helper {
  func getUpdatedSeeds(from seeds: [Int]) -> RangeSet<Int> {
    var skipNext: Bool = false
    var intRange: RangeSet<Int> = RangeSet()
    for i in 0..<seeds.count {
      if skipNext {
        skipNext = false
        continue
      }
      let seedStart = seeds[i]
      let range = seeds[i + 1]
      intRange.insert(contentsOf: seedStart..<(seedStart + range))
      skipNext = true  // skip the next entry cause its already been processed
    }
    return intRange
  }

  func getDistination(for source: Int, in map: inout [Int: (destinationStart: Int, offset: Int)])
    -> Int
  {
    for (sourceStart, (destinationStart, offset)) in map {
      if source >= sourceStart && source < sourceStart + offset {
        return destinationStart + (source - sourceStart)
      }
    }
    return source
  }

  func extractMapping(from input: [String], for header: String) -> [Int: (
    destinationStart: Int, offset: Int
  )] {
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
