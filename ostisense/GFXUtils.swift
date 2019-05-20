import UIKit

enum OstiSenseColors {
    case grey
    case brandGreen

    public var color: UIColor {
        switch self {
        case .brandGreen:
            return UIColor.init(
                red: (61 / 255.0),
                green: (235 / 255.0),
                blue: (222 / 255.0),
                alpha: 1.0
            )
        case .grey:
        return UIColor.init(
            red: (220 / 255.0),
            green: (220 / 255.0),
            blue: (220 / 255.0),
            alpha: 1.0
        )
        }
    }
}
