import Testing
import UIKit
@testable import TransientLabel

@Suite("TransientLabel Tests")
struct TransientLabelTests {

    @Test("Default initialization")
    func testDefaultInitialization() {
        let label = TransientLabel(background: .default)

        #expect(label.delay == 1.0)
        #expect(label.text == "")
    }

    @Test("Custom delay initialization")
    func testCustomDelayInitialization() {
        let customDelay = 2.5
        let label = TransientLabel(delay: customDelay, background: .default)

        #expect(label.delay == customDelay)
    }

    @Test("Initialize with solid color background")
    func testInitWithSolidColorBackground() {
        let bgColor = UIColor.red
        let label = TransientLabel(background: .solidColor(bgColor))

        #expect(label.text == "")
    }

    @Test("Initialize with blur background")
    func testInitWithBlurBackground() {
        let label = TransientLabel(background: .blur(.dark))

        #expect(label.text == "")
    }

    @Test("Initialize with no background")
    func testInitWithNoBackground() {
        let label = TransientLabel(background: .none)

        #expect(label.text == "")
    }

    @Test("Display updates text")
    func testDisplayUpdatesText() {
        let label = TransientLabel(background: .default)
        let testString = "123"

        label.display(testString)

        #expect(label.text == testString)
    }

    @Test("Multiple display calls update text")
    func testMultipleDisplayCallsUpdateText() {
        let label = TransientLabel(background: .default)

        label.display("First")
        #expect(label.text == "First")

        label.display("Second")
        #expect(label.text == "Second")

        label.display("Third")
        #expect(label.text == "Third")
    }

    @Test("Delay can be modified")
    func testDelayCanBeModified() {
        let label = TransientLabel(delay: 1.0, background: .default)

        label.delay = 3.0
        #expect(label.delay == 3.0)
    }

    @Test("Deprecated initializer creates label")
    func testDeprecatedInitializer() {
        let label = TransientLabel(
            delay: 1.5,
            font: .systemFont(ofSize: 12),
            textColor: .label,
            backgroundColor: .red
        )

        #expect(label.delay == 1.5)
        #expect(label.text == "")
    }

    @Test("Intrinsic content size updates with text")
    func testIntrinsicContentSizeWithEmptyText() {
        let label = TransientLabel(background: .default)

        let size = label.intrinsicContentSize
        #expect(size.width > 0)
        #expect(size.height > 0)
    }

    @Test("Custom font initialization")
    func testCustomFontInitialization() {
        let customFont = UIFont.boldSystemFont(ofSize: 24)
        let label = TransientLabel(
            font: customFont,
            background: .default
        )

        #expect(label.text == "")
    }

    @Test("Custom text color initialization")
    func testCustomTextColorInitialization() {
        let customColor = UIColor.blue
        let label = TransientLabel(
            textColor: customColor,
            background: .default
        )

        #expect(label.text == "")
    }
}
