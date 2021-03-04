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

        tokenProtected.get("get", use: getNotes)
        tokenProtected.post("create", use: create)
        tokenProtected.delete("delete", use: deleteNote)
        tokenProtected.put("update", use: update)
    }

    fileprivate func create(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        _ = try req.auth.require(User.self)
        let data = try req.content.decode(Note.self)

        return data.save(on: req.db).transform(to: HTTPResponseStatus.ok)
    }

    fileprivate func getNotes(req: Request) throws -> EventLoopFuture<[Note]> {
        do{
        let user = try req.auth.require(User.self)
        let userID = try user.asPublic().id
        return Note.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
            .flatMapThrowing { notes in
                if notes.isEmpty {
                    throw PublicEror.noData
                }
                return notes
            }
        }catch (let error) {
            print(error)
        }
        return Note.query(on: req.db).all()
    }

    fileprivate func deleteNote(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let _ = try req.auth.require(User.self)
        let note = try req.content.decode(Note.self)
        return Note.query(on: req.db)
            .filter(\.$id == note.id!)
            .delete()
            .transform(to: .ok)

    }

    fileprivate func update(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let _ = try req.auth.require(User.self)
        let note = try req.content.decode(Note.self)

        return Note.query(on: req.db)
            .set(\.$body, to: note.body)
            .filter(\.$id == note.id!)
            .update()
            .transform(to: .ok)
    }
}

