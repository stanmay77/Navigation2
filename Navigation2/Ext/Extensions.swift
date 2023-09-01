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
