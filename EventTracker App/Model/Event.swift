//
//  Event.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

struct Event: Codable {
    
    enum EntryType: Codable {
        case paid
        case free
    }
    let id: Int
    let name: String
    let place: String
    let entryType: EntryType
    let imageURL: String
}

extension Event: Equatable{
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension Event{
    static func getMockedData() -> [Event]{
        let events = [
            Event(id: 1, name: "Metallica Concert", place: "Palace Grounds", entryType: .paid, imageURL: "https://www.nme.com/wp-content/uploads/2020/04/Metallica-696x442.jpg"),
            Event(id: 2, name: "Saree Exhibition", place: "Malleswaram Grounds", entryType: .free, imageURL: "https://assets.architecturaldigest.in/photos/600831dd1b516d492c3aa3a9/4:3/w_1024,h_768,c_limit/D7A3056-1366x768.jpg"),
            Event(id: 3, name: "Wine tasting event", place: "Links Brewery", entryType: .paid, imageURL: "https://sommevents.com/wp-content/uploads/2019/10/Corporate-Wine-Event.jpg"),
            Event(id: 4, name: "Startups Meet", place: "Kanteerava Indoor Stadium", entryType: .paid, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 5, name: "Summer Noon Party", place: "Kumara Park", entryType: .paid, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 6, name: "Rock and Roll nights", place: "Sarjapur Road", entryType: .paid, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 7, name: "Barbecue Fridays", place: "Whitefield", entryType: .paid, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 8, name: "Summer workshop", place: "Indiranagar", entryType: .free, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 9, name: "Impressions & Expressions", place: "MG Road", entryType: .free, imageURL: "https://dummyimage.com/600x400/000/fff"),
            Event(id: 10, name: "Italian carnival", place: "Electronic City", entryType: .free, imageURL: "https://dummyimage.com/600x400/000/fff")
        ]
        return events
    }
}
