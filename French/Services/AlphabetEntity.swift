//
//  AlphabetEntity.swift
//  French
//
//  Created by dovietduy on 11/16/20.
//

import Foundation
import SQLite
class AlphabetEntity{
    static let shared = AlphabetEntity()
    private let tbl = Table("tblAlphabet")
    
    private let id = Expression<String>("id")
    private let name = Expression<String>("name")
    private let icon = Expression<String>("icon")
    private let voice = Expression<String>("voice")

    private init(){
        do{
            if let connection = SqlDataBase.shared.connection{
                try connection.run(tbl.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(id, primaryKey: true)
                    table.column(name)
                    table.column(icon)
                    table.column(voice)
                }))
            }
        } catch{
            print("Cannot create to Table alphabet, Error is: \(error)")
        }
    }
    
    func getData() -> [AlphabetModel]{
        var listData = [AlphabetModel]()
        do {
            if let listCate = try  SqlDataBase.shared.connection?.prepare(self.tbl) {
                for item in listCate {
                    listData.append(AlphabetModel(id: item[id], name: item[name], voice: item[voice], icon: item[icon]))
                }
            }
        } catch {
            print("Cannot get data from table alphabet, Error is: \(error)")
        }
        return listData
    }
}
