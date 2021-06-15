//
//  CasbinConfiguration.swift
//  CasbinVapor
//
import Casbin
import NIO
public struct CasbinConfiguration {
    public init(eventloop: EventLoopGroup,
                model: Model,
                adapter: Adapter,
                enabled: Bool = true,
                logEnabled: Bool = true,
                autoSave: Bool = true,
                autoBuildRoleLinks: Bool = true,
                autoNotifyWatcher: Bool = true,
                watcher: Watcher? = nil,
                roleManager: RoleManager = DefaultRoleManager.init(maxHierarchyLevel: 10)) {
        self.eventloop = eventloop
        self.model = model
        self.adapter = adapter
        self.enabled = enabled
        self.logEnabled = logEnabled
        self.autoSave = autoSave
        self.autoBuildRoleLinks = autoBuildRoleLinks
        self.autoNotifyWatcher = autoNotifyWatcher
        self.watcher = watcher
        self.roleManager = roleManager
    }
    
    
    
    public let eventloop:EventLoopGroup
    public let model:Casbin.Model
    public let adapter: Casbin.Adapter
    
    public let enabled:Bool
    public let logEnabled:Bool
    public let autoSave: Bool
    public let autoBuildRoleLinks:Bool
    public let autoNotifyWatcher:Bool
    public let watcher: Watcher?
    public let roleManager: RoleManager
}

extension Casbin.Enforcer {
    convenience init(_ config: CasbinConfiguration) throws {
       try self.init(m: config.model, adapter: config.adapter, .shared(config.eventloop))
       try self.setRoleManager(rm: config.roleManager).get()
        self.enableAutoBuildRoleLinks(auto: config.autoBuildRoleLinks)
        self.enableEnforce(enabled: config.enabled)
        self.enableAutoSave(auto: config.autoSave)
        self.enableAutoNotifyWatcher(auto: config.autoNotifyWatcher)
        self.watcher = config.watcher
        self.enableLog = config.logEnabled
    }
}
