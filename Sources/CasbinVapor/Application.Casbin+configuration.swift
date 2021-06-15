//
//  Application.Casbin+configuration.swift
//  CasbinVapor

import Vapor
import Casbin

extension Application.Casbin {
    public var configuration: CasbinConfiguration? {
        get {
            self.application.casbinStorage.configuration(for: self.id)
        }
        nonmutating set {
            guard let newConfig = newValue else {
             fatalError("Modifying configuration is not supported")
            }
            application.casbinStorage.use(newConfig, as: self.id)
        }
    }
    public var enforcer : Enforcer {
        guard let configuration = configuration
           else {
            fatalError("enforcer configuration is nil,pelase app.casbin.configuration = CasbinConfiguration.init(...)")
        }
        do {
           return try .init(configuration)
        } catch  {
            fatalError(error.localizedDescription)
        }
    }
}
