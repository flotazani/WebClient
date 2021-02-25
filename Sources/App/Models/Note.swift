//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 03.02.2021.
//

import Vapor
import Fluent


final class Note: Model {

    static let schema = "note"

    @ID(key: "id")
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "body")
    var body: String?


    init() {}

    init(id: UUID? = nil, userId: User.IDValue, body: String?) {
        self.id = id
        self.$user.id = userId
        self.body = body
    }
}

extension Note: Content {}

