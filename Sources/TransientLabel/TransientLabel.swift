import UIKit

public final class TransientLabel: UIView {
    
    public var delay: TimeInterval
    private let font: UIFont
    private let textColor: UIColor
    private let backgroundShapeColor: UIColor
    
    public private(set) var text: String = ""
    private var label: UILabel?
    
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
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        let bg = UIView(frame: .zero)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = backgroundShapeColor
        bg.layer.cornerRadius = 10
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        self.label = label
        
        addSubview(bg)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: label.topAnchor, constant: -4),
            bg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            bg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -4),
            bg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func display(_ string: String) {
        guard let label else { return }
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
}

//public init(delay: TimeInterval = 1, font: Font = .headline.monospacedDigit(), textColor: Color = .primary, backgroundColor: Color = Color(UIColor.systemBackground).opacity(0.4)) {
//    vm = VisibilityManager(delay: delay)
//    self.font = font
//    self.backgroundColor = backgroundColor
//}
