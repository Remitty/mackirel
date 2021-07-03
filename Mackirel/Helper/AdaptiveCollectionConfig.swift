import UIKit

struct AdaptiveCollectionConfig {
    
    static let bannerHeight: CGFloat = 210
    static let placeholderHeight: CGFloat = 150
    static var cellBaseHeight: CGFloat {
        //Need in project detect padding/height for smaller devices than iPhone 6
        return UIDevice.isPhoneSE ? 190 : 210
    }
    static var numberOfColumns = 3
    static var cellPadding: CGFloat {
        return UIDevice.isPhoneSE ? 5 : 5
    }
}


//If you prefer you can add it too
extension UIDevice {
    
    static var isPhoneSE: Bool {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth == 320
    }
    
}
