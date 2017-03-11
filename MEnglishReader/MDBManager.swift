//
//  MDBManager.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/8.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import SQLite.Swift
import PKHUD

class MDBManager {
    static let sharedDBManager = MDBManager()
    
    lazy var dbConnection: Connection? = {
        var dbConn: Connection?
        self.connectDB() { (conn) in
            dbConn = conn
        }
        guard dbConn != nil else {
            HUD.flash(HUDContentType.label(DATA_BASE_CONNECTION_FAULTS_TIPS), delay: 1.0)
            
            return nil
        }
        
        return dbConn
    }()
    
    func connectDB(completed: (_ conn: Connection?)->()){
        var databaseConnection: Connection?
        let dbPath = NSHomeDirectory() + "/Documents/database"
        print(dbPath)
        if !FileManager.default.fileExists(atPath: dbPath){
            let databaseBundlePath = Bundle.main.path(forResource: "DatabaseBundle", ofType: "bundle")!
            do {
                try FileManager.default.copyItem(atPath: databaseBundlePath, toPath: dbPath)
                print(dbPath)
            } catch _ {
                print(DATA_BASE_DATA_COPY_FAULTS_TIPS)
            }
        }
 
        do {
                databaseConnection = try Connection("\(dbPath)/MEnglishReader.db")
        } catch _ {
                print(DATA_BASE_CONNECTION_FAULTS_TIPS)
        }
        
        completed(databaseConnection)
    }
    
    private init() {}
}
