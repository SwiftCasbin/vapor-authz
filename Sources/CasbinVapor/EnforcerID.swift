//
//  EfID.swift
//  CasbinVapor
//


import Casbin
import Vapor

public struct EnforcerID:Hashable,
                         Codable,
                         RawRepresentable,
                         ExpressibleByStringLiteral,
                         ExpressibleByStringInterpolation,
                         CustomStringConvertible,
                         Comparable {
        public let rawValue: String

        public init(stringLiteral: String) {
            self.rawValue = stringLiteral
        }

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ string: String) {
            self.rawValue = string
        }

        public var description: String { rawValue }
        public static func < (lhs: EnforcerID, rhs: EnforcerID) -> Bool { lhs.rawValue < rhs.rawValue }

        public static let `default`: EnforcerID = "default"
    
}

extension Application {
    public var casbin: Casbin {
        casbin(.default)
    }
    
    public func casbin(_ id: EnforcerID) -> Casbin {
        .init(enforcerId: id, application: self)
    }
}

extension Request {
    public var casbin: Application.Casbin {
        self.application.casbin.for(self)
    }
    public func casbin(_ id: EnforcerID) ->Application.Casbin {
        self.application.casbin(id).for(self)
    }
}
