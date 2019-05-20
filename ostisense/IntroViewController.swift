import UIKit
import FrameAccessor

class IntroViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(logoView)
        animateLogoViewToTop()

        view.addSubview(welcomeLabel)
        view.addSubview(moreInfoButton)
        view.addSubview(signupButton)
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
        self.welcomeLabel.alpha = 0.0
        self.moreInfoButton.alpha = 0.0
        self.signupButton.alpha = 0.0

        UIView.animate(
            withDuration: 0.3,
            delay: 0.8,
            options: .curveEaseOut,
            animations: {
                self.welcomeLabel.alpha = 1.0
                self.moreInfoButton.alpha = 1.0
                self.signupButton.alpha = 1.0
            },
            completion: nil
        )
    }

    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.font = UIFont(name: "Futura-Medium", size: 36)
        welcomeLabel.text = "Welcome"
        welcomeLabel.textColor = .black

        let width = self.view.width - 2 * 60
        let sizeToFit = CGSize.init(width: welcomeLabel.width, height: CGFloat.greatestFiniteMagnitude)
        welcomeLabel.frame.size = welcomeLabel.sizeThatFits(sizeToFit)
        welcomeLabel.centerX = 0.5 * self.view.width
        welcomeLabel.top = self.logoView.bottom + 40

        return welcomeLabel
    }()

    private lazy var moreInfoButton: OstiSenseButton = {
        let moreInfoButton = OstiSenseButton(type: .grey)
        moreInfoButton.centerX = 0.5 * self.view.width
        moreInfoButton.bottom = self.signupButton.top - 40
        moreInfoButton.setText("I need a mouthguard")
        return moreInfoButton
    }()

    private lazy var signupButton: OstiSenseButton = {
        let signupButton = OstiSenseButton(type: .green)
        signupButton.centerX = 0.5 * self.view.width
        signupButton.bottom = self.view.height - 40
        signupButton.setText("I have my mouthguard")
        return signupButton
    }()
}
