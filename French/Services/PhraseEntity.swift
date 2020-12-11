//
//  PhraseEntity.swift
//  French
//
//  Created by dovietduy on 11/16/20.
//

import Foundation
import SQLite
class PhraseEntity{
    static let shared = PhraseEntity()
    private let tbl = Table("tblPhrase")
    
    private let id = Expression<Int>("id")
    private let category_id = Expression<Int>("category_id")
    private let english = Expression<String>("english")
    private let vietnamese = Expression<String?>("vietnamese")
    private let french = Expression<String?>("french")
    private let voice = Expression<String>("voice")
    private let favorite = Expression<Int>("favorite")
    
    private init(){
        do{
            if let connection = SqlDataBase.shared.connection{
                try connection.run(tbl.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(id, primaryKey: true)
                    table.column(category_id)
                    table.column(english)
                    table.column(vietnamese)
                    table.column(french)
                    table.column(voice)
                    table.column(favorite)
                }))
            }
        } catch{
            print("Cannnont create to Table phrase, Error is: \(error)")
        }
    }
    
    func updateFavorite(id: Int) -> Bool {
        do{
            if SqlDataBase.shared.connection == nil{
                return false
            }
            let tblFilter = self.tbl.filter(self.id == id)
            var setter: [SQLite.Setter] = [SQLite.Setter]()
            setter.append(self.favorite <- 1)
            
            let tblUpdate = tblFilter.update(setter)
            if try SqlDataBase.shared.connection!.run(tblUpdate) <= 0
            {
                return false
            }
            return true
        }catch
        {
            let nsError = error as NSError
            print("Cannot update data from table phrase, Error is: \(nsError), \(nsError)")
            return false
        }
    }
    func getFavoriteData() -> [PhraseModel]{
        var listData = [PhraseModel]()
        do {
            if let listPhrase = try  SqlDataBase.shared.connection?.prepare(self.tbl.filter(self.favorite == 1)) {
                for item in listPhrase {
                    listData.append(PhraseModel(id: item[id], english: item[english], vietnam: item[vietnamese] ?? "", french: item[french] ?? "", favorite: item[favorite], voice: item[voice]))
                }
            }
        } catch {
            print("Cannnont get data from Table phrase, Error is: \(error)")
        }
        return listData
    }
    func getAllData() -> [PhraseModel]{
        var listData = [PhraseModel]()
        do {
            if let listPhrase = try  SqlDataBase.shared.connection?.prepare(self.tbl) {
                for item in listPhrase {
                    listData.append(PhraseModel(id: item[id], english: item[english], vietnam: item[vietnamese] ?? "", french: item[french] ?? "", favorite: item[favorite], voice: item[voice]))
                }
            }
        } catch {
            print("Cannnont get data from table phrase, Error is: \(error)")
        }
        return listData
    }
    
    var count = 0
    func getData(item: CategoryModel) -> [PhraseModel]{
        var listData = [PhraseModel]()
        do {
            if let listPhrase = try  SqlDataBase.shared.connection?.prepare(self.tbl.filter(self.category_id == item.id)) {
                for item in listPhrase {
                    listData.append(PhraseModel(id: item[id], english: item[english], vietnam: item[vietnamese] ?? "", french: item[french] ?? "", favorite: item[favorite], voice: item[voice]))
                    count += 1
                }
            }
        } catch {
            print("Cannot get data from table phrase, Error is: \(error)")
        }
        return listData
    }
    func count(byCategory: CategoryModel) -> Int {
        count = 0
        if byCategory.id == 0 {return 26}
        _ = getData(item: byCategory)
        return count
    }
}
