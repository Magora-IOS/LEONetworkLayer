// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Authentication {
    internal enum Code {
      /// Enter sms-code
      internal static let message = L10n.tr("Localizable", "Authentication.code.message")
    }
    internal enum Welcome {
      /// Enter phone
      internal static let message = L10n.tr("Localizable", "Authentication.welcome.message")
    }
  }

  internal enum Errors {
    internal enum LeoProvider {
      internal enum BadLeoResponse {
        /// Could not parse response
        internal static let description = L10n.tr("Localizable", "Errors.LeoProvider.badLeoResponse.description")
        /// NetworkResponse is not valid
        internal static let title = L10n.tr("Localizable", "Errors.LeoProvider.badLeoResponse.title")
      }
      internal enum ConnectionFailed {
        /// Check your connection and try again
        internal static let description = L10n.tr("Localizable", "Errors.LeoProvider.connectionFailed.description")
        /// Connection Failed
        internal static let title = L10n.tr("Localizable", "Errors.LeoProvider.connectionFailed.title")
      }
      internal enum SecurityError {
        /// The client is not authenticated
        internal static let description = L10n.tr("Localizable", "Errors.LeoProvider.securityError.description")
        /// Authentication is required
        internal static let title = L10n.tr("Localizable", "Errors.LeoProvider.securityError.title")
      }
      internal enum ServerError {
        /// Unexpected behaviour for the server
        internal static let description = L10n.tr("Localizable", "Errors.LeoProvider.serverError.description")
        /// Server error
        internal static let title = L10n.tr("Localizable", "Errors.LeoProvider.serverError.title")
      }
      internal enum TimeoutError {
        /// Looks like the server is taking to long to respond, please try again in sometime
        internal static let description = L10n.tr("Localizable", "Errors.LeoProvider.timeoutError.description")
        /// Timeout error
        internal static let title = L10n.tr("Localizable", "Errors.LeoProvider.timeoutError.title")
      }
    }
    internal enum Unknown {
      /// 
      internal static let description = L10n.tr("Localizable", "Errors.Unknown.description")
      /// Unknown error
      internal static let title = L10n.tr("Localizable", "Errors.Unknown.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
