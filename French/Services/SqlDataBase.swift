//
//  SqlDataBase.swift
//  French
//
//  Created by dovietduy on 11/24/20.
//

import Foundation
import SQLite

class SqlDataBase{
    static let shared = SqlDataBase()
    public let connection: Connection?
    
    private init(){
        let dbPath = Bundle.main.path(forResource: "learnfrench", ofType: "db")
        print(dbPath!)
        do{
            connection = try Connection(dbPath!)
        } catch{
            connection = nil
            let nserr = error as NSError
            print("Cannot connect to Database. Error is: \(nserr), \(nserr.userInfo)")
        }
    }
}
