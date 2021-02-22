//
//  File.swift
//  
//
//  Created by Andrei Konovalov on 03.02.2021.
//

import Vapor
import Fluent

struct NewDinner: Content {
    let date: Date
    let location: String
}

struct ScheduleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let ScheduleRoute = routes.grouped("schedule")

        let tokenProtected = ScheduleRoute.grouped(Token.authenticator())

        tokenProtected.get("get", use: getSchedule)
        tokenProtected.post("create", use: create)
        tokenProtected.delete("delete", use: deleteSchedule)
    }

    fileprivate func create(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        _ = try req.auth.require(User.self)
        let data = try req.content.decode(Schedule.self)

        return data.save(on: req.db).transform(to: HTTPResponseStatus.ok)
    }

    fileprivate func getSchedule(req: Request) throws -> EventLoopFuture<[Schedule]> {
        let user = try req.auth.require(User.self)
        let userID = try user.asPublic().id
        return Schedule.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
            .flatMapThrowing { $0 }
    }

    fileprivate func deleteSchedule(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let _ = try req.auth.require(User.self)
        let sheduleID = try req.content.decode(UUID.self)
        return Schedule.find(sheduleID, on: req.db)
            .flatMapThrowing { row -> EventLoopFuture<Void> in
                guard let row = row else {
                    throw Abort(.notFound)
                }
               return row.delete(on: req.db)
            }.transform(to: .ok)
    }
}

