//
//  File_Utils.swift
//  AdventOfCode2023
//
//  Created by Lukas Waschuk on 11/21/24.
//

import Foundation

class File_Utils {
  func readFile(named fileName: String, withExtension fileExtension: String) -> [String] {
    if let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
      do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        return content.components(separatedBy: .newlines)
      } catch {
        fatalError("Error reading file: \(error.localizedDescription)")
      }
    } else {
      fatalError("File not found")
    }
  }
}
