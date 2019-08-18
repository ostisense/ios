import UIKit
import FrameAccessor

class IntroViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(logoView)
        animateLogoViewToTop()

        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
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
        let views = [
            self.welcomeLabel,
            self.descriptionLabel,
            self.moreInfoButton,
            self.signupButton,
        ]

        for (index, view) in views.enumerated() {
            view.alpha = 0.0

            UIView.animate(
                withDuration: 1.0,
                delay: 0.6 + TimeInterval(index) * 0.1,
                options: .curveEaseInOut,
                animations: {
                    view.alpha = 1.0
                },
                completion: nil
            )
        }
    }

    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.font = UIFont(name: "Futura-Medium", size: 36)
        welcomeLabel.text = "Welcome"
        welcomeLabel.textColor = .black

        welcomeLabel.sizeToFit()
        welcomeLabel.centerX = 0.5 * self.view.width
        welcomeLabel.top = self.logoView.bottom + 40

        return welcomeLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "Futura-Medium", size: 16)
        descriptionLabel.text = "Marketing copy explaining the benefits lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sodales ex at porta scelerisque. Vivamus ac scelerisque nisi."
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center

        descriptionLabel.numberOfLines = 0
        let width = self.view.width - 2 * 40
        let sizeToFit = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        descriptionLabel.frame.size = descriptionLabel.sizeThatFits(sizeToFit)
        descriptionLabel.centerX = 0.5 * self.view.width
        descriptionLabel.top = self.welcomeLabel.bottom + 40

        return descriptionLabel
    }()

    private lazy var moreInfoButton: OstiSenseButton = {
        let moreInfoButton = OstiSenseButton(type: .grey)
        moreInfoButton.centerX = 0.5 * self.view.width
        moreInfoButton.bottom = self.signupButton.top - 40
        moreInfoButton.setText("I need a mouthguard")
        signupButton.addTarget(self, action: #selector(didTapMoreInfoButton), for: .touchUpInside)
        return moreInfoButton
    }()

    private lazy var signupButton: OstiSenseButton = {
        let signupButton = OstiSenseButton(type: .green)
        signupButton.centerX = 0.5 * self.view.width
        signupButton.bottom = self.view.height - 40
        signupButton.setText("I have my mouthguard")
        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        return signupButton
    }()

    @objc private func didTapMoreInfoButton() {
        // TODO: Push an info modal or screen
    }

    @objc private func didTapSignupButton() {
        let forceHeatmapViewController = ForceHeatmapViewController()
        self.navigationController?.pushViewController(forceHeatmapViewController, animated: true)
    }
}
