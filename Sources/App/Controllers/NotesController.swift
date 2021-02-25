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

struct NoteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let ScheduleRoute = routes.grouped("notes")

        let tokenProtected = ScheduleRoute.grouped(Token.authenticator())

        tokenProtected.get("get", use: getNote)
        tokenProtected.post("create", use: create)
        tokenProtected.delete("delete", use: deleteNote)
        tokenProtected.post("update", use: update)
    }

    fileprivate func create(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        _ = try req.auth.require(User.self)
        let data = try req.content.decode(Note.self)

        return data.save(on: req.db).transform(to: HTTPResponseStatus.ok)
    }

    fileprivate func getNote(req: Request) throws -> EventLoopFuture<[Note]> {
        let user = try req.auth.require(User.self)
        let userID = try user.asPublic().id
        return Note.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
            .flatMapThrowing { $0 }
    }

    fileprivate func deleteNote(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let _ = try req.auth.require(User.self)
        let note = try req.content.decode(Note.self)
        return Note.find(note.id, on: req.db)
            .flatMapThrowing { row -> EventLoopFuture<Void> in
                guard let row = row else {
                    throw Abort(.notFound)
                }
               return row.delete(on: req.db)
            }.transform(to: .ok)
    }

    fileprivate func update(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let _ = try req.auth.require(User.self)
        let schedule = try req.content.decode(Note.self)
        return Note.find(schedule.id, on: req.db)
            .flatMapThrowing { row -> EventLoopFuture<Void> in
                guard let row = row else {
                    throw Abort(.notFound)
                }
                return row.update(on: req.db)
            }.transform(to: .ok)
    }
}

