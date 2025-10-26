import Testing
import UIKit
@testable import TransientLabel

@Suite("TransientLabelBackground Tests")
struct TransientLabelBackgroundTests {

    @Test("Default background is solid color")
    func testDefaultBackground() {
        let defaultBg = TransientLabelBackground.default

        // Verify default is a solid color case
        if case .solidColor(let color) = defaultBg {
            #expect(color.cgColor.alpha == 0.4)
        } else {
            Issue.record("Expected default background to be solidColor case")
        }
    }

    @Test("None background case")
    func testNoneBackground() {
        let bg = TransientLabelBackground.none

        // Verify we can create none case
        if case .none = bg {
            // Success
        } else {
            Issue.record("Expected none background case")
        }
    }

    @Test("Solid color background case")
    func testSolidColorBackground() {
        let testColor = UIColor.red
        let bg = TransientLabelBackground.solidColor(testColor)

        if case .solidColor(let color) = bg {
            #expect(color == testColor)
        } else {
            Issue.record("Expected solidColor background case")
        }
    }

    @Test("Blur background case")
    func testBlurBackground() {
        let blurStyle = UIBlurEffect.Style.dark
        let bg = TransientLabelBackground.blur(blurStyle)

        if case .blur(let style) = bg {
            #expect(style == blurStyle)
        } else {
            Issue.record("Expected blur background case")
        }
    }

    @Test("Custom view background case")
    func testCustomViewBackground() {
        let customView = UIView()
        let bg = TransientLabelBackground.custom(customView)

        if case .custom(let view) = bg {
            #expect(view === customView)
        } else {
            Issue.record("Expected custom background case")
        }
    }
}
