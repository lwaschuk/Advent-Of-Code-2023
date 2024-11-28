//
//  main.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/21/24.
//

import Foundation

let dayNumber = Int(ProcessInfo.processInfo.environment["RUN_DAY"]!)!

print(
  "*********************************************************************************************")
print(
  "*                                    Advent of Code 2023                                    *")
print(
  "*                 Set the RUN_DAY environment variable to run a specific day                *")
print(
  "*********************************************************************************************")
print()

print("\t\t\t\t\t\t\t\tRunning day \(dayNumber)")
print("***********************************************")
print("*                    Day \(dayNumber)                    *")
print("***********************************************")
runDay(dayNumber)()
print("\n")

func runDay(_ day: Int) -> (() -> Void) {
  switch day {
    case 1: return Day_01().run
    case 2: return Day_02().run
    case 3: return Day_03().run
    case 4: return Day_04().run
    case 5: return Day_05().run
    case 6: return Day_06().run
    case 7: return Day_07().run
    case 8: return Day_08().run
    case 9: return Day_09().run
    case 10: return Day_10().run
    case 11: return Day_11().run
    case 12: return Day_12().run
    case 13: return Day_13().run
    case 14: return Day_14().run
    case 15: return Day_15().run
    case 16: return Day_16().run
    case 17: return Day_17().run
    case 18: return Day_18().run
    case 19: return Day_19().run
    case 20: return Day_20().run
    case 21: return Day_21().run
    case 22: return Day_22().run
    case 23: return Day_23().run
    case 24: return Day_24().run
    case 25: return Day_25().run
    default: return { print("Unknown day \(day)") }
  }
}
