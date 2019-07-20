//
//  RMDatabaseManager.swift
//  realMatch-OC
//
//  Created by arceushs on 2019/7/14.
//  Copyright © 2019 qingting. All rights reserved.
//

import UIKit
@objcMembers
@objc class RMDatabaseManager: NSObject {
    private static let manager = RMDatabaseManager()
    
    @objc class func shareManager()->RMDatabaseManager{
        return manager
    }
    
    private let dbName = "test.db"
    
    lazy var dbURL:URL = { () -> URL in
        let fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(self.dbName)
        print(fileURL)
        return fileURL
    }()
    
    @objc lazy var db:FMDatabase = {
        let database = FMDatabase(url:self.dbURL)
        return database
    }()
    
    lazy var dbQueue :FMDatabaseQueue? = {
        let databaseQueue = FMDatabaseQueue(url: self.dbURL)
        return databaseQueue
    }()
    
    @objc func createTable(){
        let sql = "create table messageTable(\n" +
            "fromUser INTEGER, \n" +
            "toUser INTEGER, \n" +
            "msg TEXT, \n" +
            "msgType INTEGER \n" +
        "); \n"
        
        let db = RMDatabaseManager.shareManager().db
        
        if db.open(){
            if db.executeUpdate(sql, withArgumentsIn: []){
                
            }
        }
    }
}
