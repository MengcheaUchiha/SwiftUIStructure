//
//  PhotosModel.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

struct UserModel: Codable, Hashable {
    let id: Int
    let name: String?
    let username: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, username, phone
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.phone = try container.decode(String.self, forKey: .phone)
    }
    
    init(id: Int, name: String?, username: String?, phone: String?) {
        self.id = id
        self.name = name
        self.username = username
        self.phone = phone
    }
    
}
