//
//  Book+CoreDataClass.swift
//  
//
//  Created by Vladimir Sukanica on 12.12.20..
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Book)
public class Book: NSManagedObject {

    func updateForList(with json: JSON) {
        self.id = json[CodingKeys.id.rawValue].int32Value
        self.author = json[CodingKeys.author.rawValue].string
        self.boxNumber = json[CodingKeys.boxNumber.rawValue].int16Value
        self.genre = json[CodingKeys.genre.rawValue].string
        self.imageURL = json[CodingKeys.imageURL.rawValue].string
        self.isbn = json[CodingKeys.isbn.rawValue].string
        self.title = json[CodingKeys.title.rawValue].string
        self.vip = json[CodingKeys.vip.rawValue].bool ?? false
        self.weRecommend = json[CodingKeys.weRecommend.rawValue].bool ?? false
        self.locked = json[CodingKeys.locked.rawValue].int16Value
    }
}
extension Book {
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
        case weRecommend
        case locked
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
        
        var controllerTitle: String {
            switch self {
            
            case .avantura:
                return "Adventure".localized()
            case .biografija:
                return "Biography".localized()
            case .detektivski:
                return "Detective novels / crime novels".localized()
            case .epski:
                return "The epic fantasy".localized()
            case .erotski:
                return "Erotic novels / romance novels".localized()
            case .klasika:
                return "Classical Literature".localized()
            case .psihologija:
                return "Popular Psychology".localized()
            case .triler:
                return "Thriller".localized()
            case .istorijski:
                return "Historical novels".localized()
            case .ostalo:
                return "Miscellaneous".localized()
            case .horor:
                return "Horror".localized()
            case .akcija:
                return "Action".localized()
            case .roman:
                return "Novel".localized()
            }
        }
    }
    
    
}
