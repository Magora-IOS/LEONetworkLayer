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

  internal enum Authetication {
    internal enum Message {
      /// Enter email
      internal static let enterEmail = L10n.tr("Localizable", "Authetication.message.enterEmail")
      /// Enter full name
      internal static let enterName = L10n.tr("Localizable", "Authetication.message.enterName")
      /// Enter zip
      internal static let enterZip = L10n.tr("Localizable", "Authetication.message.enterZip")
    }
    internal enum Registration {
      /// What's your name, email and zip code?
      internal static let message = L10n.tr("Localizable", "Authetication.registration.message")
      /// Let's get you setup!
      internal static let title = L10n.tr("Localizable", "Authetication.registration.title")
    }
  }

  internal enum DetailedNews {
    /// The detailed news
    internal static let title = L10n.tr("Localizable", "DetailedNews.Title")
  }

  internal enum Errors {
    internal enum AccountService {
      /// AccountService Error
      internal static let commonTitle = L10n.tr("Localizable", "Errors.AccountService.CommonTitle")
      internal enum TokenFailed {
        /// Token failed
        internal static let description = L10n.tr("Localizable", "Errors.AccountService.TokenFailed.description")
      }
      internal enum CodeExpired {
        /// Sms code has expired
        internal static let description = L10n.tr("Localizable", "Errors.AccountService.codeExpired.description")
      }
      internal enum InvalidSmsCode {
        /// Bad sms code, please try again
        internal static let description = L10n.tr("Localizable", "Errors.AccountService.invalidSmsCode.description")
      }
      internal enum NoAuth {
        /// Authorization error
        internal static let description = L10n.tr("Localizable", "Errors.AccountService.noAuth.description")
      }
    }
    internal enum LeoProvider {
      internal enum BadLeoResponse {
        /// Could not parse leo response
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
    internal enum Moya {
      internal enum Parsing {
        /// Could not parse json
        internal static let description = L10n.tr("Localizable", "Errors.Moya.parsing.description")
        /// NetworkResponse is not valid
        internal static let title = L10n.tr("Localizable", "Errors.Moya.parsing.title")
      }
    }
    internal enum Unknown {
      /// 
      internal static let description = L10n.tr("Localizable", "Errors.Unknown.description")
      /// Unknown error
      internal static let title = L10n.tr("Localizable", "Errors.Unknown.title")
    }
  }

  internal enum News {
    /// The news
    internal static let title = L10n.tr("Localizable", "News.Title")
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
