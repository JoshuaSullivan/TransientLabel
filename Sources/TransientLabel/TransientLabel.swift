import SwiftUI

/// Creates a label that disappears after a short time.
public struct TransientLabel: View {
    
    public class VisibilityManager: ObservableObject {
        @Published var isVisible: Bool = false
        @Published var string: String = ""
        
        private let delay: TimeInterval
        private var timer: Timer?
        
        public init(delay: TimeInterval) {
            self.delay = delay
        }
        
        public func appear(with string: String) {
            isVisible = true
            self.string = string
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
                self?.isVisible = false
            })
        }
    }
    
    @ObservedObject private var vm: VisibilityManager
    
    private let font: Font
    private let backgroundColor: Color
    
    public var body: some View {
        Text(vm.string)
            .font(font.monospacedDigit())
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(RoundedRectangle(cornerRadius: 4.0).fill(backgroundColor))
            .opacity(vm.isVisible ? 1.0 : 0.0)
            .animation(.linear(duration: vm.isVisible ? 0.05 : 0.1), value: vm.isVisible)
    }
    
    /// Create a new instance of `TransientLabel`.
    ///
    /// - Parameters:
    ///     - delay: The time, in seconds, after which the label will disappear.
    public init(delay: TimeInterval = 1, font: Font = .headline.monospacedDigit(), textColor: Color = .primary, backgroundColor: Color = Color(UIColor.systemBackground).opacity(0.4)) {
        vm = VisibilityManager(delay: delay)
        self.font = font
        self.backgroundColor = backgroundColor
    }
    
    /// Display the specified string.
    ///
    ///  - Parameter string: The string for the label to display.
    ///
    public func display(_ string: String) {
        vm.appear(with: string)
    }
}

#Preview {
    
    var label1 = TransientLabel()
    var label2 = TransientLabel(font: .title, backgroundColor: .red.opacity(0.4))
    var label3 = TransientLabel(backgroundColor: .clear)

    VStack {
        VStack {
            label1
                .opacity(1)
            label2
                .foregroundColor(.white)
                .opacity(1)
            label3
                .opacity(1)
        }
        .padding()
        .background(Color.gray)
        
        Button {
            let str = "\(Int.random(in: 100...999))"
            label1.display(str)
            label2.display(str)
            label3.display(str)
        } label: {
            Text("Show Label")
                .padding()
                .contentShape(Rectangle())
        }

    }
}
