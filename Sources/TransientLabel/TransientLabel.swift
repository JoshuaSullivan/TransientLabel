import UIKit

public final class TransientLabel: UIView {
    
    public var delay: TimeInterval
    private let font: UIFont
    private let textColor: UIColor
    private let backgroundShapeColor: UIColor
    
    public private(set) var text: String = ""
    private let container: UIView
    private let label: UILabel
    private let bg: UIView
    
    private var animator: UIViewPropertyAnimator
    
    private var visTimer: Timer?
    
    private var isVisible: Bool = false
    
    public init(delay: TimeInterval = 1, font: UIFont = .preferredFont(forTextStyle: .headline), textColor: UIColor = .label, backgroundColor: UIColor = .systemBackground.withAlphaComponent(0.4)) {
        self.delay = delay
        
        let monoDigitFeature = [
            UIFontDescriptor.FeatureKey.featureIdentifier : kNumberSpacingType,
            UIFontDescriptor.FeatureKey.selector : kMonospacedNumbersSelector
        ]
        let monoDesc = font.fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings : [monoDigitFeature]])
        let monoFont = UIFont(descriptor: monoDesc, size: font.pointSize)
        self.font = monoFont
        
        self.textColor = textColor
        self.backgroundShapeColor = backgroundColor
        
        self.container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0.0
        container.isHidden = true
        
        self.label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        self.bg = UIView(frame: .zero)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = backgroundShapeColor
        bg.layer.cornerRadius = 10
        
        self.animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        
        super.init(frame: .zero)
        
        container.addSubview(bg)
        container.addSubview(label)
        
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
        
        animator.addAnimations { [weak self] in
            guard let self else { return }
            self.container.isHidden = false
            self.container.alpha = 1.0
        }
        
        animator.addCompletion { [weak self] position in
            if case .end = position {
                self?.container.isHidden = true
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        isHidden = false
        alpha = 0.0
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
    }
    
    private func disappear() {
        guard isVisible else { return }
        isVisible = false
        alpha = 1.0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 8, height: labelSize.height + 8)
    }
}

//public init(delay: TimeInterval = 1, font: Font = .headline.monospacedDigit(), textColor: Color = .primary, backgroundColor: Color = Color(UIColor.systemBackground).opacity(0.4)) {
//    vm = VisibilityManager(delay: delay)
//    self.font = font
//    self.backgroundColor = backgroundColor
//}
