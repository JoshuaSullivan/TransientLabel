import UIKit

/// This is the UIKit implementation of TransientLabel, which temporarily displays new values then disappears.
///
public final class TransientLabel: UIView {
    
    /// The default background for labels.
    public static let defaultBackground = TransientLabelBackground.solidColor(.systemBackground.withAlphaComponent(0.4))
    
    /// The time, in seconds, that the label should be visible for when a new value is set.
    public var delay: TimeInterval
    
    /// The font used to display values.
    private let font: UIFont
    
    /// The font color of the label.
    private let textColor: UIColor
    
    /// The background type to use behind the label.
    private let background: TransientLabelBackground
    
    public private(set) var text: String = ""
    private let container: UIView
    private let label: UILabel
    private let bg: UIView
    
    private var animator: UIViewPropertyAnimator
    
    private var visTimer: Timer?
    private var isVisible = false
    
    /// Create a new instance of TransientLabel.
    ///
    /// - Parameters:
    ///     - delay: The time, in seconds, which the label should appear for when a new value is set.
    ///     - font: The font used to display values.
    ///     - textColor: The text color of the labael.
    ///     - backgroundColor: The color of the background behind the label.
    ///
    @available(*, deprecated, message: "Use the constructor which takes a TransientLabelBackground type instead.")
    public convenience init(delay: TimeInterval = 1, font: UIFont = .preferredFont(forTextStyle: .headline), textColor: UIColor = .label, backgroundColor: UIColor = .systemBackground.withAlphaComponent(0.4)) {
        self.init(delay: delay, font: font, textColor: textColor, background: .solidColor(backgroundColor))
    }
    
    /// Create a new instance of TransientLabel.
    ///
    /// - Parameters:
    ///     - delay: The time, in seconds, which the label should appear for when a new value is set.
    ///     - font: The font used to display values.
    ///     - textColor: The text color of the labael.
    ///     - background: The type of background behind the label.
    ///
    public init(delay: TimeInterval = 1, font: UIFont = .preferredFont(forTextStyle: .headline), textColor: UIColor = .label, background: TransientLabelBackground) {
        self.delay = delay
        
        let monoDigitFeature = [
            UIFontDescriptor.FeatureKey.type : kNumberSpacingType,
            UIFontDescriptor.FeatureKey.selector : kMonospacedNumbersSelector
        ]
        let monoDesc = font.fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings : [monoDigitFeature]])
        let monoFont = UIFont(descriptor: monoDesc, size: font.pointSize)
        self.font = monoFont
        
        self.textColor = textColor
        self.background = background
        self.container = UIView(frame: .zero)
        self.label = UILabel(frame: .zero)
        self.bg = UIView(frame: .zero)
        self.animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        
        super.init(frame: .zero)
        
        
        
        animator.pausesOnCompletion = true
        animator.addAnimations { [weak self] in
            guard let self else { return }
            self.container.alpha = 1.0
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(bg)
        container.addSubview(label)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0.0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        switch background {
        case .none:
            bg.isHidden = true
        case .solidColor(let color):
            bg.backgroundColor = color
            bg.layer.cornerRadius = 10
        case .blur(let blurType):
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurType))
            blurView.translatesAutoresizingMaskIntoConstraints = false
            bg.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: bg.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: bg.bottomAnchor),
                blurView.leadingAnchor.constraint(equalTo: bg.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: bg.trailingAnchor)
            ])
            bg.layer.cornerRadius = 10
        case .custom(let bgView):
            bg.addSubview(bgView)
            NSLayoutConstraint.activate([
                bgView.topAnchor.constraint(equalTo: bg.topAnchor),
                bgView.bottomAnchor.constraint(equalTo: bg.bottomAnchor),
                bgView.leadingAnchor.constraint(equalTo: bg.leadingAnchor),
                bgView.trailingAnchor.constraint(equalTo: bg.trailingAnchor)
            ])
        }
                
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: label.topAnchor, constant: -4),
            bg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            bg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -4),
            bg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public func display(_ string: String) {
        self.text = string
        label.text = string
        appear()
    }
    
    public func appear() {
        visTimer?.invalidate()
        visTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
            self?.disappear()
        })
        guard !isVisible else { return }
        isVisible = true
        animator.isReversed = false
        animator.startAnimation()
    }
    
    private func disappear() {
        guard isVisible else { return }
        isVisible = false
        animator.isReversed = true
        animator.startAnimation()
    }
    
    public override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 8, height: labelSize.height + 8)
    }
    
    private func describe(animator: UIViewPropertyAnimator, label: String? = nil) {
        var str = ""
        if let label {
            str += "[\(label)] "
        }
        str += "fractionComplete: \(animator.fractionComplete), isReversed: \(animator.isReversed), isRunning: \(animator.isRunning)"
        print(str)
    }
}

//public init(delay: TimeInterval = 1, font: Font = .headline.monospacedDigit(), textColor: Color = .primary, backgroundColor: Color = Color(UIColor.systemBackground).opacity(0.4)) {
//    vm = VisibilityManager(delay: delay)
//    self.font = font
//    self.backgroundColor = backgroundColor
//}
