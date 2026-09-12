// This package is built for touch: every control in it is UIKit-backed.
// The Mac has system controls that do the same job better, so rather than
// port anything, the whole module compiles away there — hosts switch on the
// platform and use `Slider` and friends instead. The guard is additive: on
// iOS, iPadOS and visionOS nothing changes.
#if canImport(UIKit)

import UIKit

/// Sets the background type for the TransientLabel.
public enum TransientLabelBackground {
    
    public static let `default`: TransientLabelBackground = .solidColor(.systemBackground.withAlphaComponent(0.4))
    
    /// No background.
    case none
    
    /// Solid color background.
    case solidColor(UIColor)
    
    /// UIBlurEffect background.
    case blur(UIBlurEffect.Style)
    
    /// A custom UIView.
    ///
    /// This view will be pinned to the size of the label and may change size (width) during presentation.
    case custom(UIView)
}
#endif
