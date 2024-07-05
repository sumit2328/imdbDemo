//
//  Movies+CoreDataProperties.swift
//  IMDB Demo
//
//  Created by Sumit on 02/07/24.
//
//

import Foundation
import CoreData


extension Movies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var year: String?
    @NSManaged public var imdbId: String?

    @NSManaged public dynamic var isFavorite: Bool // Use dynamic

}

extension Movies : Identifiable {

}
