import SwiftUI

/// Creates a label that disappears after a short time.
public struct TransientLabelView: View {
    
    /// Handles auto-hiding behvior.
    private class VisibilityManager: ObservableObject {
        @Published var isVisible: Bool = false
        @Published var string: String = ""
        
        private let delay: TimeInterval
        private var timer: Timer?
        
        init(delay: TimeInterval) {
            self.delay = delay
        }
        
        func set(string: String) {
            self.string = string
            appear()
        }
        
        func appear() {
            isVisible = true
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
                self?.isVisible = false
            })
        }
    }
        
    @ObservedObject private var vm: VisibilityManager
    
    private let font: Font
    private let background: TransientLabelBackground
    
    public var body: some View {
        Text(vm.string)
            .font(font.monospacedDigit())
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(backgroundView())
            .compositingGroup()
            .opacity(vm.isVisible ? 1.0 : 0.0)
            .animation(.linear(duration: vm.isVisible ? 0.05 : 0.1), value: vm.isVisible)
    }
    
    /// Create a new instance of `TransientLabel`.
    ///
    /// - Parameters:
    ///     - delay: The time, in seconds, after which the label will disappear.
    ///     - font: The font to use.
    ///     - textColor: The color of the label text.
    ///     - background: The type of background to use behind the label.
    public init(delay: TimeInterval = 1, font: Font = .headline, textColor: Color = .primary, background: TransientLabelBackground = .default) {
        vm = VisibilityManager(delay: delay)
        self.font = font.monospacedDigit()
        self.background = background
    }

    /// Display the specified string.
    ///
    ///  - Parameter string: The string for the label to display.
    ///
    public func display(_ string: String) {
        vm.set(string: string)
    }
    
    // Cause the label to appear.
    public func appear() {
        vm.appear()
    }

    @ViewBuilder
    private func backgroundView() -> some View {
        switch background {
        case .none:
            Color.clear
        case .solidColor(let color):
            Color(uiColor: color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        case .blur(let style):
            VisualEffectView(effect: UIBlurEffect(style: style))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        case .custom(let view):
            UIViewWrapper(uiView: view)
        }
    }
}

/// A wrapper for UIVisualEffectView.
private struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView(effect: effect) }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

/// A wrapper for an arbitrary UIView.
private struct UIViewWrapper: UIViewRepresentable {
    var uiView: UIView
    func makeUIView(context: Context) -> some UIView { uiView }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    
    let gradientStops: [Gradient.Stop] = {
        let light: Color = .init(white: 0.8)
        let dark: Color = .init(white: 0.4)
        return [
            .init(color: light, location: 0),
            .init(color: light, location: 0.2),
            .init(color: dark, location: 0.2),
            .init(color: dark, location: 0.4),
            .init(color: light, location: 0.4),
            .init(color: light, location: 0.6),
            .init(color: dark, location: 0.6),
            .init(color: dark, location: 0.8),
            .init(color: light, location: 0.8),
            .init(color: light, location: 1.0),
        ]
    }()
    
    let label1 = TransientLabelView()
    let label2 = TransientLabelView(font: .title, background: .solidColor(.red.withAlphaComponent(0.4)))
    let label3 = TransientLabelView(background: .none)
    let label4 = TransientLabelView(delay: 1.25, font: .title2, background: .blur(.systemThinMaterial))
    let bgImage = UIImage(resource: .checkers)
    let bgView: UIView = {
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = UIColor(patternImage: bgImage)
        bgView.layer.cornerRadius = 8
        return bgView
    }()
    let label5 = TransientLabelView(delay: 1.5, background: .custom(bgView))
    
    return VStack {
        VStack {
            label1
            label2
                .foregroundColor(.white)
                .onTapGesture {
                    label2.appear()
                }
            label3
            label4
            label5
        }
        .padding()
        .background(Rectangle()
            .fill(LinearGradient(stops: gradientStops, startPoint: .leading, endPoint: .trailing))
        )
        
        Button {
            let str = "\(Int.random(in: 100...999))"
            label1.display(str)
            label2.display(str)
            label3.display(str)
            label4.display(str)
            label5.display(str)
        } label: {
            Text("Show Label")
                .padding()
                .contentShape(Rectangle())
        }

    }
}
