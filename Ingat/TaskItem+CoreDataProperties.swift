//
//  TaskItem+CoreDataProperties.swift
//  Ingat
//
//  Created by Ivan Valentino Sigit on 05/05/21.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var due: Date?

}

extension TaskItem : Identifiable {

}
