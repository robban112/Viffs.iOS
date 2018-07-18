import UIKit
import Overture

// extensions
extension UIColor {
  public convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  public convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}

extension UIFont {
  public var bolded: UIFont {
    guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
    return UIFont(descriptor: descriptor, size: 0)
  }
}

extension UIButton {
  public var normalTitleColor: UIColor? {
    get { return self.titleColor(for: .normal) }
    set { self.setTitleColor(newValue, for: .normal) }
  }
}

extension UIButton {
  public var normalBackgroundImage: UIImage? {
    get { return self.backgroundImage(for: .normal) }
    set { self.setBackgroundImage(newValue, for: .normal) }
  }
  
  public var normalImage: UIImage? {
    get { return self.image(for: .normal) }
    set { self.setImage(newValue, for: .normal) }
  }
}

extension UIImage {
  public static func from(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}

// colors
extension UIColor {
  static let blipp_blue: UIColor = UIColor(rgb: 0x73C1F9)
}

// styles
public let autolayoutStyle = mut(\UIView.translatesAutoresizingMaskIntoConstraints, false)

public let stackBaseStyle = concat(
  autolayoutStyle,
  mut(\UIStackView.spacing, 20),
  mut(\.axis, .vertical)
)

public let centeredLabelStyle = mut(\UILabel.textAlignment, .center)

public let backgroundStyle = concat(
  autolayoutStyle,
  mut(\.contentMode, .scaleAspectFill)
)

public func roundedStyle(cornerRadius: CGFloat) -> (UIView) -> Void {
  return concat(
    mut(\.layer.cornerRadius, cornerRadius),
    mut(\.layer.masksToBounds, true)
  )
}

public let baseRoundedStyle = roundedStyle(cornerRadius: 6)

public let bolded: (inout UIFont) -> Void = { $0 = $0.bolded }

public let baseTextButtonStyle = concat(
  mut(\UIButton.titleLabel!.font, UIFont(name: "ChalkboardSE-Regular", size: 15)),
  mver(\UIButton.titleLabel!.font!, bolded)
)

public let baseButtonStyle = concat(
  autolayoutStyle,
  baseTextButtonStyle,
  mut(\.contentEdgeInsets, .init(top: 8, left: 16, bottom: 8, right: 16))
)

public let baseFilledButtonStyle = concat(
  baseButtonStyle,
  baseRoundedStyle
)

public let primaryButtonStyle = concat(
  baseFilledButtonStyle,
  mut(\.normalBackgroundImage, .from(color: UIColor.blipp_blue.withAlphaComponent(0.85))),
  mut(\.normalTitleColor, .white)
)
