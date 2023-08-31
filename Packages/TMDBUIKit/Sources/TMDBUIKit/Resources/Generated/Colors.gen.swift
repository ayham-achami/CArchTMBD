// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Colors {
  public static let invertBack = ColorAsset(name: "invertBack")
  public static let primaryBack = ColorAsset(name: "primaryBack")
  public static let secondaryBack = ColorAsset(name: "secondaryBack")
  public static let tertiaryBack = ColorAsset(name: "tertiaryBack")
  public static let incomingBubble = ColorAsset(name: "incomingBubble")
  public static let incomingMessageInfo = ColorAsset(name: "incomingMessageInfo")
  public static let outgoingBubble = ColorAsset(name: "outgoingBubble")
  public static let outgoingMessageInfo = ColorAsset(name: "outgoingMessageInfo")
  public static let scrollDownButtonBackground = ColorAsset(name: "scrollDownButtonBackground")
  public static let scrollDownButtonTint = ColorAsset(name: "scrollDownButtonTint")
  public static let sendIcon = ColorAsset(name: "sendIcon")
  public static let separatorColor = ColorAsset(name: "separatorColor")
  public static let danger = ColorAsset(name: "danger")
  public static let success = ColorAsset(name: "success")
  public static let warn = ColorAsset(name: "warn")
  public static let invertText = ColorAsset(name: "invertText")
  public static let primaryText = ColorAsset(name: "primaryText")
  public static let secondaryText = ColorAsset(name: "secondaryText")
  public static let tertiaryText = ColorAsset(name: "tertiaryText")
  public static let black = ColorAsset(name: "black")
  public static let disable = ColorAsset(name: "disable")
  public static let primary = ColorAsset(name: "primary")
  public static let primaryLight = ColorAsset(name: "primaryLight")
  public static let primaryPress = ColorAsset(name: "primaryPress")
  public static let purple = ColorAsset(name: "purple")
  public static let red = ColorAsset(name: "red")
  public static let secondary = ColorAsset(name: "secondary")
  public static let secondaryPress = ColorAsset(name: "secondaryPress")
  public static let tmbd = ColorAsset(name: "tmbd")
  public static let white = ColorAsset(name: "white")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
