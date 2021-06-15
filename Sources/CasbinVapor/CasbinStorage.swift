//
//  CasbinStorage.swift
//  CasbinVapor
//
//

import Vapor

extension Application {
    private struct CasbinStorageKey: StorageKey {
        typealias Value = CasbinStorage
    }
    
    var casbinStorage: CasbinStorage {
        if let existing = self.storage[CasbinStorageKey.self] {
            return existing
        }
        let casbinStorage = CasbinStorage.init()
        self.storage[CasbinStorageKey.self] = casbinStorage
        return casbinStorage
    }
}

final class CasbinStorage {
    init() {
        self.configurations = [:]
    }
    
    
    private var configurations: [EnforcerID: CasbinConfiguration]
    
    func use(_ casbinconfiguration: CasbinConfiguration, as id: EnforcerID = .default) {
        self.configurations[id] = casbinconfiguration
    }
    func configuration(for id: EnforcerID = .default) -> CasbinConfiguration? {
        self.configurations[id]
    }
    
    func ids() -> Set<EnforcerID> {
        Set(self.configurations.keys)
    }
}
