import CoreData
import UIKit

final class CoreDManager {

    static let shared = CoreDManager()
    private (set) var posts: [CDPost] = []
    
    private var context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    private init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let fetchRequest = CDPost.fetchRequest()
        posts = (try? context.fetch(fetchRequest)) ?? []
    }
    
    func savePost(_ post: Post) {
        if posts.filter({$0.toStruct() == post}).isEmpty {
            let newPost = post.toCoreData(context: context)
            try? context.save()
            fetchPosts()
        }
    }
    
    func deletePost(at index: Int) {
        context.delete(posts[index])
        try? context.save()
        fetchPosts()
    }
    
}
