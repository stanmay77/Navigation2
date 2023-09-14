import UIKit
import CoreData


extension UITextField {
    
    func addSpacer(for space: CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
}

extension UIImage {
    
    func image(alpha: Double) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension CDPost {
    func toStruct() -> Post {
        return Post(title: self.title!, author: self.author!, descr: self.descr!, image: self.image!, likes: Int(self.likes), views: Int(self.views))
    }
}

extension Post {
    func toCoreData(context: NSManagedObjectContext) -> CDPost {
        let cdPost = CDPost(context: context)
        cdPost.title = self.title
        cdPost.descr = self.descr
        cdPost.author = self.author
        cdPost.image = self.image
        cdPost.likes = Int32(self.likes)
        cdPost.views = Int32(self.views)
        return cdPost
    }
}

extension UIColor {
    static func createColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return light
        }
        
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }
    
    
    static let fieldColor1 = createColor(light: UIColor.systemGray6, dark: .white)
    static let postColor = createColor(light: .white, dark: .systemGray6)
    static let monochrome = createColor(light: .black, dark: .white)
    static let antiMonochrome = createColor(light: .white, dark: .black)
    static let fieldColor2 = createColor(light: .systemGray4, dark: .systemGray)
    static let navBarColor = createColor(light: UIColor(named: "AccentColor")!, dark: .systemGray4)
    static let tabBarColor = createColor(light: UIColor(named: "AccentColor")!, dark: .white)
    
}
