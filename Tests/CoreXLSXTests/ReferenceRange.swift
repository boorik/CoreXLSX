//
//  ReferenceRange.swift
//  
//
//  Created by vincent blanchet on 04/06/2024.
//

import XCTest
@testable import CoreXLSX

final class ReferenceRangeTests: XCTestCase {
  
  func testContains() throws {
    let sut = try ReferenceRange(string: "A3:C8")
    XCTAssertEqual(sut.start, CellReference(ColumnReference("A")!, 3))
    XCTAssertEqual(sut.end, CellReference(ColumnReference("C")!, 8))
    XCTAssertTrue(sut.contains(reference: CellReference(ColumnReference("B")!, 4)))
    XCTAssertTrue(sut.contains(reference: CellReference(ColumnReference("A")!, 3)))
    XCTAssertTrue(sut.contains(reference: CellReference(ColumnReference("C")!, 8)))
    XCTAssertFalse(sut.contains(reference: CellReference(ColumnReference("D")!, 8)))
    XCTAssertFalse(sut.contains(reference: CellReference(ColumnReference("A")!, 2)))
  }
}
