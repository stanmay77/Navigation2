import Foundation

struct Notification {
    
    let id: String
    let time: String
    let name: String
    let body: String
    let repeats: Bool

    init(id: String, time: String, name: String, body: String, repeats: Bool) {
        self.id = id
        self.time = time
        self.name = name
        self.body = body
        self.repeats = repeats
    }
}
