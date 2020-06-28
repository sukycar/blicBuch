//
//  Books+CoreDataClass.swift
//  
//
//  Created by Vladimir Sukanica on 5/7/20.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Books)
public class Books: NSManagedObject {
    
    func updateForList(with json: JSON) {
        self.id = json[CodingKeys.id.rawValue].int32Value
        self.author = json[CodingKeys.author.rawValue].string
        self.boxNumber = json[CodingKeys.boxNumber.rawValue].int16Value
        self.genre = json[CodingKeys.genre.rawValue].string
        self.imageURL = json[CodingKeys.imageURL.rawValue].stringValue
        self.isbn = json[CodingKeys.isbn.rawValue].string
        self.title = json[CodingKeys.title.rawValue].string
        self.vip = json[CodingKeys.vip.rawValue].bool ?? false
    }
    
}
extension Books {
    enum CodingKeys: String, CodingKey {
        case author
        case boxNumber
        case genre
        case id
        case imageURL
        case isbn
        case title
        case vip
        case vipUser
    }
    
    enum Genre {
        case avantura
        case biografija
        case detektivski
        case epski
        case erotski
        case klasika
        case psihologija
        case triler
        case istorijski
        case ostalo
        case horor
        case akcija
        case roman
        
        var title: String {
            switch self {
                
            case .avantura:
                return "Das Abenteuer"
            case .biografija:
                return "Lebenslauf"
            case .detektivski:
                return "Detektiv-Romane /Kriminalromane"
            case .epski:
                return "Das epische Fantasy Romangenre"
            case .erotski:
                return "Erotikromane/Liebesromane"
            case .klasika:
                return "Klassikliteratur"
            case .psihologija:
                return "Popularpsychologie"
            case .triler:
                return "Thriller"
            case .istorijski:
                return "Historische Romane"
            case .ostalo:
                return "Sonstiges"
            case .horor:
                return "Horror"
            case .akcija:
                return "Aktion"
            case .roman:
                return "Roman"
            
            }
        }
    }
}
