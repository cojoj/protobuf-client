//
//  HttpClient.swift
//  ProtobufSampleApp
//
//  Created by Michał Cichoń on 24/05/2017.
//  Copyright © 2017 Codete. All rights reserved.
//

import Alamofire

let host = "http://localhost:8080"

enum AcceptHeader {
    case json, protobuf
}

struct DurationTimes {
    var totalDuration: TimeInterval
    var requestDuration: TimeInterval
}

class HttpClient {
    func getAccountList(acceptHeader: AcceptHeader, completion: @escaping (Bool, AccountList?, DurationTimes?) -> Void) {
        switch acceptHeader {
        case .json:
            getAccountListJSON(completion: completion)
        case .protobuf:
            getAccountListProtobuf(completion: completion)
        }
    }
    
    func getTransactionList(acceptHeader: AcceptHeader, id: UInt64, completion: @escaping (Bool, Array<Transaction>, DurationTimes?) -> Void) {
        switch acceptHeader {
        case .json:
            getTransactionListJSON(id: id, completion: completion)
        case .protobuf:
            getTransactionListProtobuf(id: id, completion: completion)
        }
    }
    
    private func getAccountListProtobuf(completion: @escaping (Bool, AccountList?, DurationTimes?) -> Void) {
        let headers: HTTPHeaders = [
            "Accept" : "application/octet-stream"
        ]
        
        Alamofire.request(host + "/accountList", method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseData { response in
                guard let data = response.data else {
                    completion(false, nil, nil)
                    return
                }
                
                do {
                    let accountList = try AccountList(serializedData: data)
                    let durationTimes = DurationTimes(totalDuration: response.timeline.totalDuration, requestDuration: response.timeline.requestDuration)
                    completion(true, accountList, durationTimes)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
    }
    
    private func getAccountListJSON(completion: @escaping (Bool, AccountList?, DurationTimes?) -> Void) {
        let headers: HTTPHeaders = [
            "Accept" : "application/json"
        ]
        
        Alamofire.request(host + "/accountList", method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseData { response in
                guard let data = response.data else {
                    completion(false, nil, nil)
                    return
                }
                
                do {
                    let accountList = try AccountList(jsonUTF8Data: data)
                    let durationTimes = DurationTimes(totalDuration: response.timeline.totalDuration, requestDuration: response.timeline.requestDuration)
                    completion(true, accountList, durationTimes)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
    }
    
    private func getTransactionListJSON(id: UInt64, completion: @escaping (Bool, [Transaction], DurationTimes?) -> Void) {
        let headers: HTTPHeaders = [
            "Accept" : "application/json"
        ]
        
        Alamofire.request(host + "/account/" + String(id), method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseData { response in
                guard let data = response.data else {
                    completion(false, [], nil)
                    return
                }
                
                do {
                    let account = try Account(jsonUTF8Data: data)
                    let transactionList = account.transactions
                    let durationTimes = DurationTimes(totalDuration: response.timeline.totalDuration, requestDuration: response.timeline.requestDuration)
                    completion(true, transactionList, durationTimes)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
    }
    
    private func getTransactionListProtobuf(id: UInt64, completion: @escaping (Bool, [Transaction], DurationTimes?) -> Void) {
        let headers: HTTPHeaders = [
            "Accept" : "application/octet-stream"
        ]
        
        Alamofire.request(host + "/account/" + String(id), method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseData { response in
                guard let data = response.data else {
                    completion(false, [], nil)
                    return
                }
                
                do {
                    let account = try Account(serializedData: data)
                    let transactionList = account.transactions
                    let durationTimes = DurationTimes(totalDuration: response.timeline.totalDuration, requestDuration: response.timeline.requestDuration)
                    completion(true, transactionList, durationTimes)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
    }
}
