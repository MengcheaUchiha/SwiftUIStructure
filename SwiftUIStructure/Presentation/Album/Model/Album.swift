//
//  Album.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

struct Album: Codable, Hashable {
    let id: Int
    let userId: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    init(id: Int, userId: Int?, title: String?) {
        self.id = id
        self.userId = userId
        self.title = title
    }
    
}
