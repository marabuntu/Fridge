import UIKit

protocol BarcodeScannerParameters {

    var recognizableAreaRect: CGRect { get }
    var recognizableAreaWidth: CGFloat { get }
    var recognizableAreaHeight: CGFloat { get }
    var codeRectangleWidth: CGFloat { get }
    var codeRectangleCornerRadius: CGFloat { get }
}

extension BarcodeScannerParameters {

    var recognizableAreaWidthMultiplier: CGFloat { 0.8 }
    var recognizableAreaWidth: CGFloat { UIScreen.main.bounds.width * recognizableAreaWidthMultiplier }
    var recognizableAreaHeight: CGFloat { 200 }
    var recognizableAreaRect: CGRect {
        let x = UIScreen.main.bounds.width * (1 - recognizableAreaWidthMultiplier) / 2
        let y = UIScreen.main.bounds.height / 2 - (recognizableAreaHeight / 2)
        let w = UIScreen.main.bounds.width * recognizableAreaWidthMultiplier
        return CGRect(x: x, y: y, width: w, height: recognizableAreaHeight)
    }
    var codeRectangleWidth: CGFloat { 3 }
    var codeRectangleCornerRadius: CGFloat { 3 }
}
