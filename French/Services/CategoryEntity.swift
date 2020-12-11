//
//  CategoryEntity.swift
//  French
//
//  Created by dovietduy on 11/16/20.
//

import Foundation
import SQLite
class CategoryEntity{
    static let shared = CategoryEntity()
    private let tbl = Table("category")
    
    private let id = Expression<Int>("id")
    private let english = Expression<String>("english")
    private let vietnamese = Expression<String>("vietnamese")
    private let icon = Expression<String>("icon")

    private init(){
        do{
            if let connection = SqlDataBase.shared.connection{
                try connection.run(tbl.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(id, primaryKey: true)
                    table.column(english)
                    table.column(vietnamese)
                    table.column(icon)
                }))
            }
        } catch{
            print("Cannot create to Table, Error is: \(error)")
        }
    }
    
    func getData() -> [CategoryModel]{
        var listData = [CategoryModel]()
        do {
            if let listCate = try  SqlDataBase.shared.connection?.prepare(self.tbl) {
                for item in listCate {
                    listData.append(CategoryModel(id: item[id], english: item[english], vietnamese: item[vietnamese], image: item[icon]))
                }
            }
        } catch {
            print("Cannot get data from \(self.tbl), Error is: \(error)")
        }
        return listData
    }
}
