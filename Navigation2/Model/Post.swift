public struct Post: Equatable {
    
    public init(title: String, author: String, descr: String, image: String, likes: Int, views: Int) {
        self.title = title
        self.author = author
        self.descr = descr
        self.image = image
        self.likes = likes
        self.views = views
    }
    
    public let title: String
    public let author: String
    public let descr: String
    public let image: String
    public let likes: Int
    public let views: Int
    
    
    public static let posts = [
    Post(title: "OpenAI announces ChatGPT successor GPT-4", author: "Mad Daymon", descr: "The new model can respond to images - providing recipe suggestions from photos of ingredients, for example, as well as writing captions and descriptions", image: "gpt4", likes: 569, views: 1000),
    Post(title: "Apple WWDC 2023: Dates Confirmed, Countdown Begins", author: "Tim Cook", descr: "Apple today announced it will host its annual Worldwide Developers Conference (WWDC) in an online format from June 5 through 9, 2023", image: "wwdc", likes: 567394, views: 657888),
    Post(title: "Google reveals its newest A.I. supercomputer, says it beats Nvidia", author: "Sergey Brin", descr: "Google published details about its AI supercomputer on Wednesday, saying it is faster and more efficient than competing Nvidia systems.", image: "ggo", likes: 890999, views: 2359856),
    Post(title: "OneNote is getting Microsoft’s new AI Copilot to help you write your notes", author: "Bill Gates", descr: "Copilot in OneNote can rewrite, format, or summarize your existing notes and help you create plans and more", image: "msft", likes: 12333, views: 76580)
    ]
    
    
}

