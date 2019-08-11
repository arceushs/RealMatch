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
    
    private let dbName = "test2.db"
    
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
            "fromUser TEXT, \n" +
            "toUser TEXT, \n" +
            "msg TEXT, \n" +
            "msgType TEXT, \n" +
            "uploadId INTEGER, \n" +
            "timestamp REAL \n" +
        "); \n"
        
        let db = RMDatabaseManager.shareManager().db
        
        if db.open(){
            if db.executeUpdate(sql, withArgumentsIn: []){
                
            }
        }
    }
    
    @objc func insertData(_ messageDetail:RMMessageDetail) -> Bool {
        if(self.db.open()){
            do{
                try self.db.executeUpdate("insert into messageTable (fromUser, toUser, msg, msgType, uploadId,timestamp) values (?,?,?,?,?,?)", values: [messageDetail.fromUser,messageDetail.toUser,messageDetail.msg,messageDetail.msgType,messageDetail.uploadId,NSDate.timeIntervalSinceReferenceDate])
                print(NSDate.timeIntervalSinceReferenceDate,"insert")
            }catch{
                return false
            }
            return true
        }
        return false
    }
    
    @objc func getData(_ messageParam:RMMessageParams)->Array<RMMessageDetail>?{
        if(self.db.open()){
            do{
                if messageParam.direction == "front"{
                    let sets = try self.db .executeQuery("select * from messageTable where ((fromUser = (?) and toUser = (?)) or (fromUser = (?) and toUser = (?))) and timestamp < (?) order by timestamp Desc limit 0,(?)", values: [messageParam.fromUser,messageParam.toUser,messageParam.toUser,messageParam.fromUser,messageParam.timestamp,messageParam.count])
                    var messagesArr = [RMMessageDetail]()
                    while sets.next(){
                        var dict = [String:Any]()
                        let fromUser = sets.string(forColumn: "fromUser")
                        dict["fromUser"] = fromUser ?? ""
                        let toUser = sets.string(forColumn: "toUser")
                        dict["toUser"] = toUser ?? ""
                        let msg = sets.string(forColumn: "msg")
                        dict["msg"] = msg ?? ""
                        let msg_type = sets.string(forColumn: "msgType")
                        dict["msg_type"] = msg_type
                        let uploadId = sets.int(forColumn: "uploadId")
                        dict["upload_id"] = uploadId
                        let message = RMMessageDetail(dict)
                        let timestamp = sets.double(forColumn: "timestamp")
                        message.timestamp = timestamp
                        messagesArr.append(message)
                    }
                    return messagesArr.reversed()
                }else if messageParam.direction == "back"{
                    let sets = try self.db .executeQuery("select * from messageTable where fromUser = (?) and toUser = (?) and timestamp > (?) order by timestamp limit 0,(?)", values: [messageParam.fromUser,messageParam.toUser,messageParam.timestamp,messageParam.count])
                    var messagesArr = [RMMessageDetail]()
                    while sets.next(){
                        var dict = [String:Any]()
                        let fromUser = sets.string(forColumn: "fromUser")
                        dict["fromUser"] = fromUser ?? ""
                        let toUser = sets.string(forColumn: "toUser")
                        dict["toUser"] = toUser ?? ""
                        let msg = sets.string(forColumn: "msg")
                        dict["msg"] = msg ?? ""
                        let msg_type = sets.string(forColumn: "msgType")
                        dict["msg_type"] = msg_type
                        let uploadId = sets.int(forColumn: "uploadId")
                        dict["upload_id"] = uploadId
                        let message = RMMessageDetail(dict)
                        let timestamp = sets.double(forColumn: "timestamp")
                        message.timestamp = timestamp
                        messagesArr.append(message)
                    }
                    return messagesArr

                }else{
                    return nil
                }
                
            }catch{
                
            }
            
        }
        
        return nil
        
    }
}
