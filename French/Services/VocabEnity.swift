//
//  VocabEnity.swift
//  French
//
//  Created by dovietduy on 11/25/20.
//

import Foundation
import SQLite
class VocabEntity{
    static let shared = VocabEntity()
    private let tbl = Table("tblVocabulary")
    
    private let id = Expression<Int>("id")
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
                    table.column(english)
                    table.column(vietnamese)
                    table.column(french)
                    table.column(voice)
                    table.column(favorite)
                }))
            }
        } catch{
            print("Cannnont create to Table vocabulary, Error is: \(error)")
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
            print("Cannot update data from table vocabulary, Error is: \(nsError), \(nsError)")
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
            print("Cannnont get data from Table vocabulary, Error is: \(error)")
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
}
