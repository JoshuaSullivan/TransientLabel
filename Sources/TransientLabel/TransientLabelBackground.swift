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
