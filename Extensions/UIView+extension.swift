
import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat, startColor: UIColor, endColor: UIColor) {
        
        self.backgroundColor = nil
        self.layoutIfNeeded() //views our gradient
        let gradientView = GradienView(from: .topTrailing, to: .bottomLeading, startColor: startColor, endColor: endColor)
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
       
            
    }
    
}
