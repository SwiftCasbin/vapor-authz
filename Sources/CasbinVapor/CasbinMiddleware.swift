//
//  CasbinMiddleware.swift
//  CasbinVapor
//
//

import Vapor

public struct CasbinVals:Content {
    public let subject:String
    public let domain: String?
}

public struct CasbinMiddleware: Middleware {
    public init(enforcerId: EnforcerID = .default) {
        self.enforcerId = enforcerId
    }
    
    let enforcerId: EnforcerID
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let path = request.url.path
        let action = request.method.string
        guard let vals = try? request.query.decode(CasbinVals.self),!vals.subject.isEmpty else {
            return request.eventLoop.makeSucceededFuture(Response.init(status: .unauthorized))
        }
            if let domain = vals.domain {
               let enforcer = request.casbin(enforcerId).enforcer
                switch enforcer.enforce(vals.subject,domain,path,action) {
                case .success(true):
                    return next.respond(to: request)
                case .success(false):
                    return request.eventLoop.makeSucceededFuture(Response.init(status: .forbidden))
                case .failure:
                    return request.eventLoop.makeSucceededFuture(Response.init(status: .badGateway))
                }
            } else {
                let enforcer = request.casbin(enforcerId).enforcer
                 switch enforcer.enforce(vals.subject,path,action) {
                 case .success(true):
                     return next.respond(to: request)
                 case .success(false):
                     return request.eventLoop.makeSucceededFuture(Response.init(status: .forbidden))
                 case .failure:
                     return request.eventLoop.makeSucceededFuture(Response.init(status: .badGateway))
                 }
            }
    }
}
