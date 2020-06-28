//
//  SortModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6/7/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation

class SortModel: Equatable, NSCopying {
    var title:String?
    var selected:Bool = false
    var type:SortModelType?
    var direction: SortModelDirection?
    var subItems:[SortModel]?
    
    init(type:SortModelType) {
        self.type = type
        self.title = type.name
        subItems = [SortModel]()
        subItems?.append(SortModel(type:type, direction: .Asc))
        subItems?.append(SortModel(type:type, direction: .Desc))
    }
    
    init(type:SortModelType, direction:SortModelDirection) {
        self.direction = direction
        self.title = direction.name
        self.type = type
    }
    
    init() {
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let sortModel = SortModel()
        sortModel.title = self.title
        sortModel.selected = self.selected
        sortModel.type = self.type
        sortModel.direction = self.direction
        return sortModel
    }
    
    static func == (lhs: SortModel, rhs: SortModel) -> Bool {
        return lhs.type == rhs.type && lhs.subItems == rhs.subItems
    }
}

enum SortModelType:String{
    case preVetStatus = "vesselPreVetStatus"
    case imoNumber = "imoNumber"
    case friendlyName = "friendlyName"
    case flag = "flag"
    case businessCode = "businessCode"
    case vesselImoNumber = "vesselImoNumber"
    var name:String{
        switch self {
        case .preVetStatus:
            return "Pre vet status"
        case .imoNumber:
            return "Imo Number"
        case .friendlyName:
            return "Friendly Name"
        case .flag:
            return "Flag"
        case .businessCode:
            return "Business Code"
        case .vesselImoNumber:
            return "IMO Number"
        default:
            return ""
        }
    }
    
    var sortDirection:Bool {
        return true
    }
    
    static let vessels:[SortModel] = [SortModel(type: .preVetStatus),
                                      SortModel(type: .imoNumber),
                                      SortModel(type: .friendlyName),
                                      SortModel(type: .flag)]
    
    static let requests:[SortModel] = [SortModel(type: .businessCode), SortModel(type: .vesselImoNumber)]
}

enum SortModelDirection:Int{
    case Asc = 1,
    Desc = 2
    
    var name:String{
        switch self {
        case .Asc:
            return "Asc"
        default:
            return "Desc"
        }
    }
    
    var sufix:String{
        switch self {
        case .Asc:
            return "(Asc.)"
        case .Desc:
            return "(Desc.)"
        }
    }
    
    static let getBoth:[SortModelDirection] = [Asc, Desc]
}
extension Array where Element: SortModel{
    func getActive() -> [(String,Bool)]?{
        var selected = [(String,Bool)]()
        for item in self{
            if let selectedSubitem = item.subItems?.first(where: {$0.selected}) {
                let id = item.type?.rawValue ?? ""
                let direction = (selectedSubitem.direction ?? .Asc) == .Asc ? true : false
                selected.append((id, direction))
            }
            
        }
        if selected.count > 0 {
            return selected
        }
        return nil
    }
    func reset() {
        self.forEach { (item) in
            item.selected = false
            if let subitems = item.subItems?.filter({$0.selected == true}) {
                subitems.forEach({$0.selected = false})
            }
        }
    }
}
