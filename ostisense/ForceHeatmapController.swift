import UIKit

// the 16 sensors in the mouth
enum ForceSensorLocation: CaseIterable {
    case r1
    case r2
    case r3
    case r4
    case r5
    case r6
    case r7
    case r8
    case l1
    case l2
    case l3
    case l4
    case l5
    case l6
    case l7
    case l8
}

class ForceHeatmapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(toothLayoutView)
        view.addSubview(todaysSessionButton)
        view.addSubview(replaySummaryLabel)

        generateHeatmapRings()
        clearForces()
    }

    var heatmapRings: [ForceSensorLocation: UIView] = [:]
    private func generateHeatmapRings() {
        for sensorLocation in ForceSensorLocation.allCases {
            let heatmapRing = self.heatmapRingForSensorLocation(sensorLocation)
            self.heatmapRings[sensorLocation] = heatmapRing
            toothLayoutView.addSubview(heatmapRing)
        }
    }

    private let toothLayoutWidth: CGFloat = 300
    private let toothLayoutHeight: CGFloat = 250
    private lazy var toothLayoutView: UIImageView = {
        let toothLayoutView = UIImageView()
        toothLayoutView.image = UIImage(named: "tooth-layout")

        // This matches the spec in LaunchScreen.storyboard
        toothLayoutView.width = self.toothLayoutWidth
        toothLayoutView.height = self.toothLayoutHeight
        toothLayoutView.contentMode = .scaleToFill

        toothLayoutView.centerX = 0.5 * self.view.width
        toothLayoutView.top = 240

        return toothLayoutView
    }()

    private lazy var todaysSessionButton: OstiSenseButton = {
        let todaysSessionButton = OstiSenseButton(type: .grey)
        todaysSessionButton.centerX = 0.5 * self.view.width
        todaysSessionButton.bottom = self.view.height - 60

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let todaysDateString = formatter.string(from: date)
        todaysSessionButton.setText("Replay \(todaysDateString)")

        todaysSessionButton.addTarget(self, action: #selector(didTapTodaysSessionButton), for: .touchUpInside)
        return todaysSessionButton
    }()

    private lazy var replaySummaryLabel: UILabel = {
        let replaySummaryLabel = UILabel()
        replaySummaryLabel.numberOfLines = 0
        replaySummaryLabel.font = UIFont(name: "Futura-Medium", size: 24)
        replaySummaryLabel.text = ""
        replaySummaryLabel.textColor = .black
        replaySummaryLabel.textAlignment = .center

        replaySummaryLabel.height = 120
        replaySummaryLabel.width = self.view.width - 2 * 20
        replaySummaryLabel.centerX = 0.5 * self.view.width
        replaySummaryLabel.centerY = 0.5 * (self.todaysSessionButton.top + self.toothLayoutView.bottom)

        return replaySummaryLabel
    }()

    let animationDuration = 10.0 // in seconds
    var timeAnimationBegan: TimeInterval?
    var animationDisplayLink: CADisplayLink?
    private var timeSinceAnimationBegan: TimeInterval {
        return CACurrentMediaTime() - (timeAnimationBegan ?? 0)
    }
    @objc private func didTapTodaysSessionButton() {
        tryToStartAnimation()
    }

    private func tryToStartAnimation() {
        guard animationDisplayLink == nil else { return }

        timeAnimationBegan = CACurrentMediaTime()
        animationDisplayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        animationDisplayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    @objc private func updateAnimation() {
        let timeSince = self.timeSinceAnimationBegan
        let animationProgress = (timeSince / animationDuration)
        let numFrames = totalForcesOverTime.count
        let currentFrameIndex: Int = Int(floor(Double(numFrames) * animationProgress))
        guard currentFrameIndex < numFrames else {
            animationDisplayLink?.invalidate()
            animationDisplayLink = nil
            clearForces()
            return
        }

        self.renderForcesForIndex(currentFrameIndex)

        let timeBeganMinutes: TimeInterval = 23 * 60 + 7 // 11:07pm
        let timeEndedMinutes: TimeInterval = 24 * 60 + (6 * 60 + 48) // 6:48am the next day
        let timeNowMinutes = (timeEndedMinutes - timeBeganMinutes) * animationProgress + timeBeganMinutes
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let dateNow = startOfDay.addingTimeInterval(60 * timeNowMinutes)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let timeOfDayString = formatter.string(from: dateNow).lowercased()

        let totalForce = totalForcesOverTime[currentFrameIndex]

        replaySummaryLabel.text = "Force \(totalForce)\nat time \(timeOfDayString)"
    }

    // these are defined based on the tooth image photo itself, the pixel
    // locations of each individual tooth. This could be more complex for an individual mouth
    // but for this demo it's very simplistic assuming all mouths are the same and the force sensor
    // is perfectly in the middle of each tooth
    private let forcePoints: [ForceSensorLocation: CGPoint] = [
        .l8: CGPoint(x: 22, y: 228),
        .l7: CGPoint(x: 24, y: 190),
        .l6: CGPoint(x: 31, y: 153),
        .l5: CGPoint(x: 43, y: 115),
        .l4: CGPoint(x: 53, y: 81),
        .l3: CGPoint(x: 70, y: 52),
        .l2: CGPoint(x: 98, y: 29),
        .l1: CGPoint(x: 130, y: 13),
        .r1: CGPoint(x: 170, y: 13),
        .r2: CGPoint(x: 202, y: 29),
        .r3: CGPoint(x: 230, y: 52),
        .r4: CGPoint(x: 247, y: 81),
        .r5: CGPoint(x: 257, y: 115),
        .r6: CGPoint(x: 269, y: 153),
        .r7: CGPoint(x: 276, y: 190),
        .r8: CGPoint(x: 278, y: 228),
    ]

    private func heatmapRingForSensorLocation(_ location: ForceSensorLocation) -> UIView {
        let view = UIView()
        view.width = 100
        view.height = 100

        let layer = HeatmapRingLayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        view.layer.addSublayer(layer)

        view.center = self.forcePoints[location] ?? .zero

        return view
    }

    private class ForceSensorTimesampleValues {
        private let numbers: [ForceSensorLocation: Float]
        init(numbers: [ForceSensorLocation: Float]) {
            self.numbers = numbers
        }

        func numberForLocation(_ location: ForceSensorLocation) -> Float {
            return self.numbers[location] ?? 0
        }
    }

    // index should be 0 through 19
    private func forceSensorValuesAtIndex(_ index: Int) -> ForceSensorTimesampleValues {
        var numbers: [ForceSensorLocation: Float] = [:]
        for sensorLocation in ForceSensorLocation.allCases {
            let numbersForLocation: [Float] = sensorForcesOverTime[sensorLocation] ?? []
            numbers[sensorLocation] = numbersForLocation[index]
        }
        return ForceSensorTimesampleValues(numbers: numbers)
    }

    private func totalForceAtIndex(_ index: Int) -> Float {
        return totalForcesOverTime[index]
    }

    private func renderForcesForIndex(_ index: Int) {
        guard index < totalForcesOverTime.count else { return }

        let timestampValues = self.forceSensorValuesAtIndex(index)
        self.renderForcesForTimestampValues(timestampValues)
    }

    private func clearForces() {
        let emptyTimestampValues = ForceSensorTimesampleValues(numbers: [:])
        self.renderForcesForTimestampValues(emptyTimestampValues)
    }

    private func renderForcesForTimestampValues(_ timestampValues: ForceSensorTimesampleValues) {
        for sensorLocation in ForceSensorLocation.allCases {
            let heatmapRing = self.heatmapRings[sensorLocation]
            let force = timestampValues.numberForLocation(sensorLocation)

            heatmapRing?.alpha = self.heatmapRingOpacityForForce(force)
            let scale = self.heatmapRingScaleForForce(force)
            heatmapRing?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    private func heatmapRingOpacityForForce(_ force: Float) -> CGFloat {
        return CGFloat(min(1, force / 60.0))
    }

    private func heatmapRingScaleForForce(_ force: Float) -> CGFloat {
        let maxScale: Float = 1.5
        let minScale: Float = 0.5
        return CGFloat(force * (maxScale - minScale) / 70.0 + minScale)
    }

    // Declaring the raw timeseries data in code this way  is hacky, but makes the code easier by avoiding
    // having to import a CSV parsing library and mess with that complexity.
    // Obviously it's an easy addition to modify this to use a file format or json or whatever we decide later, but for this
    // demo it's just declared here in code
    let totalForcesOverTime: [Float] = [
        150,
        175,
        200,
        225,
        250,
        275,
        300,
        325,
        350,
        375,
        400,
        425,
        375,
        370,
        350,
        300,
        250,
        200,
        150,
        100,
    ]

    let sensorForcesOverTime: [ForceSensorLocation:[Float]] = [
        .r1: [
            4.2,
            4.9,
            5.6,
            6.3,
            7,
            7.7,
            8.4,
            9.1,
            9.8,
            10.5,
            11.2,
            11.9,
            10.5,
            10.36,
            9.8,
            8.4,
            7,
            5.6,
            4.2,
            2.8,
        ],
        .r2: [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ],
        .r3: [
            18,
            21,
            24,
            27,
            30,
            33,
            36,
            39,
            42,
            45,
            48,
            51,
            45,
            44.4,
            42,
            36,
            30,
            24,
            18,
            12,
        ],
        .r4: [
            21,
            24.5,
            28,
            31.5,
            35,
            38.5,
            42,
            45.5,
            49,
            52.5,
            56,
            59.5,
            52.5,
            51.8,
            49,
            42,
            35,
            28,
            21,
            14,
        ],
        .r5: [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ],
        .r6: [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ],
        .r7: [
            30.15,
            35.175,
            40.2,
            45.225,
            50.25,
            55.275,
            60.3,
            65.325,
            70.35,
            75.375,
            80.4,
            85.425,
            75.375,
            74.37,
            70.35,
            60.3,
            50.25,
            40.2,
            30.15,
            20.1,
        ],
        .r8: [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ],
        .l1: [
            3.3,
            3.85,
            4.4,
            4.95,
            5.5,
            6.05,
            6.6,
            7.15,
            7.7,
            8.25,
            8.8,
            9.35,
            8.25,
            8.14,
            7.7,
            6.6,
            5.5,
            4.4,
            3.3,
            2.2,
        ],
        .l2: [
            3.3,
            3.85,
            4.4,
            4.95,
            5.5,
            6.05,
            6.6,
            7.15,
            7.7,
            8.25,
            8.8,
            9.35,
            8.25,
            8.14,
            7.7,
            6.6,
            5.5,
            4.4,
            3.3,
            2.2,
        ],
        .l3: [
            7.05,
            8.225,
            9.4,
            10.575,
            11.75,
            12.925,
            14.1,
            15.275,
            16.45,
            17.625,
            18.8,
            19.975,
            17.625,
            17.39,
            16.45,
            14.1,
            11.75,
            9.4,
            7.05,
            4.7,
        ],
        .l4: [
            10.65,
            12.425,
            14.2,
            15.975,
            17.75,
            19.525,
            21.3,
            23.075,
            24.85,
            26.625,
            28.4,
            30.175,
            26.625,
            26.27,
            24.85,
            21.3,
            17.75,
            14.2,
            10.65,
            7.1,
        ],
        .l5: [
            24.3,
            28.35,
            32.4,
            36.45,
            40.5,
            44.55,
            48.6,
            52.65,
            56.7,
            60.75,
            64.8,
            68.85,
            60.75,
            59.94,
            56.7,
            48.6,
            40.5,
            32.4,
            24.3,
            16.2,
        ],
        .l6: [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ],
        .l7: [
            14.55,
            16.975,
            19.4,
            21.825,
            24.25,
            26.675,
            29.1,
            31.525,
            33.95,
            36.375,
            38.8,
            41.225,
            36.375,
            35.89,
            33.95,
            29.1,
            24.25,
            19.4,
            14.55,
            9.7,
        ],
        .l8: [
            6.75,
            7.875,
            9,
            10.125,
            11.25,
            12.375,
            13.5,
            14.625,
            15.75,
            16.875,
            18,
            19.125,
            16.875,
            16.65,
            15.75,
            13.5,
            11.25,
            9,
            6.75,
            4.5,
        ],
    ]
}

