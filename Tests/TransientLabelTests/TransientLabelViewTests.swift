import Testing
import SwiftUI
@testable import TransientLabel

@Suite("TransientLabelView Tests")
@MainActor
struct TransientLabelViewTests {

    @Test("Default initialization")
    func testDefaultInitialization() {
        let labelView = TransientLabelView()

        // Verify the view can be created without errors - body is always present
        _ = labelView.body
    }

    @Test("Custom delay initialization")
    func testCustomDelayInitialization() {
        let labelView = TransientLabelView(delay: 2.5)

        _ = labelView.body
    }

    @Test("Custom font initialization")
    func testCustomFontInitialization() {
        let labelView = TransientLabelView(font: .title)

        _ = labelView.body
    }

    @Test("Custom text color initialization")
    func testCustomTextColorInitialization() {
        let labelView = TransientLabelView(textColor: .red)

        _ = labelView.body
    }

    @Test("Initialize with solid color background")
    func testInitWithSolidColorBackground() {
        let bgColor = UIColor.blue
        let labelView = TransientLabelView(background: .solidColor(bgColor))

        _ = labelView.body
    }

    @Test("Initialize with blur background")
    func testInitWithBlurBackground() {
        let labelView = TransientLabelView(background: .blur(.systemMaterial))

        _ = labelView.body
    }

    @Test("Initialize with no background")
    func testInitWithNoBackground() {
        let labelView = TransientLabelView(background: .none)

        _ = labelView.body
    }

    @Test("Initialize with default background")
    func testInitWithDefaultBackground() {
        let labelView = TransientLabelView(background: .default)

        _ = labelView.body
    }

    @Test("Display method can be called")
    func testDisplayMethodCanBeCalled() {
        let labelView = TransientLabelView()

        // This should not crash
        labelView.display("Test String")

        _ = labelView.body
    }

    @Test("Appear method can be called")
    func testAppearMethodCanBeCalled() {
        let labelView = TransientLabelView()

        // This should not crash
        labelView.appear()

        _ = labelView.body
    }

    @Test("Multiple display calls")
    func testMultipleDisplayCalls() {
        let labelView = TransientLabelView()

        labelView.display("First")
        labelView.display("Second")
        labelView.display("Third")

        _ = labelView.body
    }

    @Test("All parameters custom initialization")
    func testAllParametersCustomInitialization() {
        let labelView = TransientLabelView(
            delay: 1.5,
            font: .title2,
            textColor: .green,
            background: .blur(.prominent)
        )

        _ = labelView.body
    }

    @Test("Custom UIView background")
    func testCustomUIViewBackground() {
        let customView = UIView()
        customView.backgroundColor = .red
        let labelView = TransientLabelView(background: .custom(customView))

        _ = labelView.body
    }
}
