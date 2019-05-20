import UIKit
import FrameAccessor

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(logoView)
        animateLogoViewToTop()

        view.addSubview(titleLabel)
        animateInAllElements()
    }

    private lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")

        // This matches the spec in LaunchScreen.storyboard
        logoView.width = self.view.width
        logoView.height = 200
        logoView.contentMode = .center

        logoView.centerX = 0.5 * self.view.width
        logoView.centerY = 0.5 * self.view.height

        return logoView
    }()

    private func animateLogoViewToTop() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0.3,
            options: .curveEaseInOut,
            animations: {
                self.logoView.top = 60
        },
            completion: nil
        )
    }

    private func animateInAllElements() {
        self.titleLabel.alpha = 0.0
        self.whyNeedAccountLabel.alpha = 0.0

        UIView.animate(
            withDuration: 0.3,
            delay: 0.8,
            options: .curveEaseOut,
            animations: {
                self.titleLabel.alpha = 1.0
                self.whyNeedAccountLabel.alpha = 1.0
            },
            completion: nil
        )
    }

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Futura-Medium", size: 24)
        titleLabel.text = "First, you‘ll need an account"
        titleLabel.textColor = .black

        let width = self.view.width - 2 * 60
        let sizeToFit = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        titleLabel.frame.size = titleLabel.sizeThatFits(sizeToFit)
        titleLabel.centerX = 0.5 * self.view.width
        titleLabel.top = self.logoView.bottom + 40

        return titleLabel
    }()

    private lazy var whyNeedAccountLabel: UILabel = {
        let whyNeedAccountLabel = UILabel()
        whyNeedAccountLabel.font = UIFont(name: "Futura-Medium", size: 24)
        whyNeedAccountLabel.text = "Why?"
        whyNeedAccountLabel.textColor = .black

        whyNeedAccountLabel.sizeToFit()
        whyNeedAccountLabel.centerX = 0.5 * self.view.width
        whyNeedAccountLabel.top = self.titleLabel.bottom + 12

        return whyNeedAccountLabel
    }()
}
