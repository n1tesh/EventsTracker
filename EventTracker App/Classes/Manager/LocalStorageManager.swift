//
//  LocalStorageManager.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

class LocalStorageManager: NSObject {
        
    var events: [Event] = []
    
    fileprivate let trackedEvents = "Event-\(AppController.shared.name)"
    static let shared = LocalStorageManager()
    
    private let defaults = UserDefaults.standard
    
    private override init() {
        super.init()
        getEvents()
    }
    
}

extension LocalStorageManager {
    
    
    func addEventToFavourite(_ event: Event) -> Bool{
        if self.events.contains(event) == false{
            self.events.append(event)
            defaults.set(try? PropertyListEncoder().encode(events), forKey: trackedEvents)
            return true
        }
        return false
    }
    
    func removeEventFromFavourite(_ event: Event) -> Bool {
        if let indexToRemove = self.events.firstIndex(where: {$0.id == event.id}){
            self.events.remove(at: indexToRemove)
            defaults.set(try? PropertyListEncoder().encode(events), forKey: trackedEvents)
            return true
        }
        return false
    }
    
    func checkIfEventExists(_ event: Event) -> Bool {
        return self.events.contains(event)
    }
    
    private func getEvents() {
        guard let data = defaults.object(forKey: trackedEvents) as? Data else {
            return
        }
        
        guard let info = try? PropertyListDecoder().decode([Event].self, from: data) else {
            return
        }
        
        self.events = info
    }
    
}
