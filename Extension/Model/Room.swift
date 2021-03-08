import Matrix
import CoreData

extension Room {
    public var hasMoreMessages: Bool { previousBatch != nil }
    
    public var messages: [Message] {
        roomMessages?.allObjects as? [Message] ?? []
    }
    
    public var members: [Member] {
        roomMembers?.allObjects as? [Member] ?? []
    }
    
    convenience init(id: String, joinedRoom: JoinedRooms, context: NSManagedObjectContext) {
        let messages = joinedRoom.timeline.events.filter { $0.type == "m.room.message" }
                                                 .compactMap { Message(roomEvent: $0, context: context) }
        
        self.init(context: context)
        self.id = id
        self.roomMessages = NSSet(array: messages)
        self.previousBatch = joinedRoom.timeline.previousBatch
    }
    
    func generatedName(for userID: String?) -> String {
        name ?? members.filter { $0.id != userID }.compactMap { $0.displayName ?? $0.id }.joined(separator: ", ")
    }
}
