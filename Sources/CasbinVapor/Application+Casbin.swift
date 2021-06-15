//
//  Application+casbin.swift
//  CasbinVapor
//
//

import Casbin
import Vapor

extension Application {
    public struct Casbin {
        init(enforcerId: EnforcerID, application: Application) {
            self.id = enforcerId
            self.application = application
        }
        
        public let id: EnforcerID
        let application: Application
        
        func `for`(_ req: Request) -> Casbin {
            .init(enforcerId: self.id, application: req.application)
        }
    }
}
