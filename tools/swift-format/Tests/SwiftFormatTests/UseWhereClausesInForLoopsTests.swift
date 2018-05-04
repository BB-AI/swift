import Foundation
import XCTest
import SwiftSyntax

@testable import Rules

public class UseWhereClausesInForLoopsTests: DiagnosingTestCase {
  public func testForLoopWhereClauses() {
    XCTAssertFormatting(
      UseWhereClausesInForLoops.self,
      input: """
             for i in [0, 1, 2, 3] {
               if i > 30 {
                 print(i)
               }
             }

             for i in [0, 1, 2, 3] {
               if i > 30 {
                 print(i)
               }
               print(i)
             }

             for i in [0, 1, 2, 3] {
               if let x = (2 as Int?) {
                 print(i)
               }
             }

             for i in [0, 1, 2, 3] {
               guard i > 30 else {
                 continue
               }
               print(i)
             }
             """,
      expected: """
                for i in [0, 1, 2, 3] where i > 30 {
                    print(i)
                }

                for i in [0, 1, 2, 3] {
                  if i > 30 {
                    print(i)
                  }
                  print(i)
                }

                for i in [0, 1, 2, 3] {
                  if let x = (2 as Int?) {
                    print(i)
                  }
                }

                for i in [0, 1, 2, 3] where i > 30 {
                  print(i)
                }
                """)
  }

#if !os(macOS)
  static let allTests = [
    UseWhereClausesInForLoopsTests.testMultipleVariableBindings,
  ]
#endif

}
