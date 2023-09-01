struct RegisteredUser: Codable {
    //@DocumentID var id: String? = UUID().uuidString
    let login: String
    let fullName: String
    let avatarURL: String?
    let status: String
    
    init(login: String, fullName: String, avatarURL: String?, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.status = status
    }
}
