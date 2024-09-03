# TransientLabel

This library produces a label which displays a value for a fixed duration, then disappears. It is useful in cases where you want to view chagnes to a value while it is changing, 
but not be a distraction when the value isn't changing. It is used by the [NumericGauge](https://github.com/JoshuaSullivan/NumericGauge/) library to display the current value of 
the slider.

It is provided for both UIKit and SwiftUI. See `TransientLabel.swift` for the UIKit version and `TransientLabelView.swift` for the SwiftUI version.

## Version 1.1.0
This new version makes the background of the label much more flexible by adding additional background types. The backgrounds you can use now are:

* No Background
* Solid Color
* UIBlurEffect
* Custom UIView

I decided to deprecate the old background color initializer, it will be removed in version 2.0.
