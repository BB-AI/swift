import Core
import Foundation
import SwiftSyntax

/// Enforces whitespace requirements for array literals, tuples, and dictionary literals.
///
/// Lint: If an array, dictionary, or tuple literal it on a single line, and there are any spaces
///       after the opening delimiter, or any spaces before the closing delimiter, a lint
///       error is raised.
///
/// Format: Extraneous spaces at the beginning and end of collection literals will be removed.
///
/// - SeeAlso: https://google.github.io/swift#horizontal-whitespace
public final class CollectionLiteralWhitespace: SyntaxFormatRule {
  public override func visit(_ token: TokenSyntax) -> Syntax {
    // Ensure we have an adjacent token on the same line
    guard let next = token.nextToken else { return token }
    if next.leadingTrivia.containsNewlines { return token }

    // If either this current token is a left delimiter, or the next token
    // is a right delimiter, then remove spaces from our trailing trivia.
    if token.tokenKind.isLeftBalancedDelimiter && token.trailingTrivia.containsSpaces {
      // TODO(b/77534297): location for diagnostic
      diagnose(.noSpacesAfter(token), location: nil)
      return token.withTrailingTrivia(token.trailingTrivia.withoutSpaces())
    }

    if next.tokenKind.isRightBalancedDelimiter && token.trailingTrivia.containsSpaces {
      // TODO(b/77534297): location for diagnostic
      diagnose(.noSpacesBefore(next), location: nil)
      return token.withTrailingTrivia(token.trailingTrivia.withoutSpaces())
    }
    return token
  }
}

extension Diagnostic.Message {
  static func noSpacesAfter(_ token: TokenSyntax) -> Diagnostic.Message {
    return .init(.warning, "remove spaces after '\(token.text)'")
  }
  static func noSpacesBefore(_ token: TokenSyntax) -> Diagnostic.Message {
    return .init(.warning, "remove spaces before '\(token.text)'")
  }
}
