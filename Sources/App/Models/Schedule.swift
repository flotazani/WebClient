//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 03.02.2021.
//

import Vapor
import Fluent


final class Schedule: Model {

//    struct Public: Content {
//        let id: UUID
//        let user: User.Public
//        let day: String
//        let stime: String
//        let etime: String
//        let sName: String
//    }

    static let schema = "schedule"

    @ID(key: "id")
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "day")
    var day: String?

    @Field(key: "start_time")
    var stime: String?

    @Field(key: "end_time")
    var etime: String?

    @Field(key: "subject_name")
    var sName: String?

    init() {}

    init(id: UUID? = nil, userId: User.IDValue, day: String?, start: String?, end: String?, name: String?) {
        self.id = id
        self.$user.id = userId
        self.day = day
        self.stime = start
        self.etime = end
        self.sName = name
    }
}

extension Schedule: Content {
//    func asPublic() throws -> Public {
//        Public(id: try requireID(),
//               user: try user.asPublic(),
//               day: day,
//               stime: stime,
//               etime: etime,
//               sName: sName)
//    }
}

