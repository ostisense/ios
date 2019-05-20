import UIKit
import FrameAccessor

enum OstiSenseButtonType {
    case grey
    case green
}

class OstiSenseButton: UIButton {
    static let fixedWidth: CGFloat = 280
    static let fixedHeight: CGFloat = 80

    let type: OstiSenseButtonType
    required init(type: OstiSenseButtonType) {
        self.type = type
        super.init(frame: .zero)

        width = OstiSenseButton.fixedWidth
        height = OstiSenseButton.fixedHeight

        layer.cornerRadius = 0.5 * height

        setBackground()

        addSubview(customLabel)
    }

    private func setBackground() {
        backgroundColor = {
            switch type {
            case .grey: return OstiSenseColors.grey.color
            case .green: return OstiSenseColors.brandGreen.color
            }
        }()
    }

    private lazy var customLabel: UILabel = {
        let customLabel = UILabel()
        customLabel.font = UIFont(name: "Futura-Medium", size: 16)
        customLabel.textColor = .black
        customLabel.textAlignment = .center

        customLabel.width = OstiSenseButton.fixedWidth
        customLabel.height = OstiSenseButton.fixedHeight
        customLabel.isUserInteractionEnabled = false

        return customLabel
    }()

    public func setText(_ text: String) {
        customLabel.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
