// Copyright 2019-2020 CoreOffice contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Created by vincent blanchet on 04/06/2024.
//

import Foundation

enum ReferenceRangeError: Error {
  case invalidRangeString(String)
}

public struct ReferenceRange: Codable, Equatable {
  public let start: CellReference
  public let end: CellReference
  
  init(start: CellReference, end: CellReference) {
    self.start = start
    self.end = end
  }
}

public extension ReferenceRange {
  init(string: String) throws {
    let members = string.split(separator: ":")
    guard members.count == 2 else {
      throw ReferenceRangeError.invalidRangeString(string)
    }
    
    start = try CellReference(string: String(members[0]))
    end = try CellReference(string: String(members[1]))
  }
}

extension ReferenceRange {
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(String.self)
    try self.init(string: value)
  }
  
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    let ref = start.description + end.description
    try container.encode(ref)
  }
}

public extension ReferenceRange {
  func contains(reference: CellReference) -> Bool {
    reference.column >= start.column &&
    reference.column <= end.column &&
    reference.row >= start.row &&
    reference.row <= end.row
  }

  func getMatchingColumnsAndRows() -> ([ColumnReference], [UInt]) {
    let columnCount = start.column.distance(to: end.column)
    let columns: [ColumnReference] = (0...columnCount).map { index in
      start.column.advanced(by: index)
    }

    let rows:[UInt] = Array(start.row...end.row)
    return (columns, rows)
  }
}
