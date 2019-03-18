//
//  httpTool.swift
//  ElevatorCloud
//
//  Created by SinodomMac02 on 16/7/7.
//  Copyright © 2016年 SinodomMac02. All rights reserved.
//

import UIKit
import Alamofire
class httpTool: NSObject {
      static  let ip : NSString = "http://192.168.1.59:8080"
//    static  let ip : NSString = "http://192.168.1.100:91"
      static let ss : NSString = "/api/"
    
// MARK: -网络情GET方法
    class  func  GETRequesst(patch: NSString,parameters : [String : AnyObject], success : (dicDatas:[String : AnyObject]) -> () , failure : (errorInfo : NSError) -> ())
    {
        Alamofire.request(.GET, (ip as String) + (ss as String) + (patch as String) , parameters: parameters)
            .responseString { response in
                switch response.result{
                case .Success:
                    if let JSON = response.result.value {
                        let JSONData = JSON.dataUsingEncoding(NSUTF8StringEncoding)
                        guard  let responseJSON = try? NSJSONSerialization.JSONObjectWithData(JSONData! as NSData, options: NSJSONReadingOptions.MutableLeaves) else {
                        return
                        }
                        let dic :[String:AnyObject] = responseJSON as! [String : AnyObject]
                        success(dicDatas: dic)
                    }
                    break
                case .Failure(let error) :
                    failure(errorInfo: error)
                    break
                }
         }
    }
    
// MARK: -网络情POST方法
    class  func  POSTRequesst(patch: NSString,parameters : [String : AnyObject], success : (dicDatas:[String : AnyObject]) -> () , failure : (errorInfo : NSError) -> ())
    {
        Alamofire.request(.POST,  (ip as String)  + (ss as String) + (patch as String),parameters:parameters)
            .responseJSON { response in
                switch response.result {
                case  .Success :
                    if let JSON = response.result.value {
                           success(dicDatas: JSON as! [String : AnyObject])
                    }
                    break
                    case .Failure(let error) :
                           failure(errorInfo: error)
                    break
            }
        }
    }
    
    
// MARK: -网络情GET 拼接头参数方法
    class  func  GETHeaderRequesst(patch: NSString, header : [String :String ],success : (dicDatas:[String : AnyObject]) -> () , failure : (errorInfo : NSError) -> ()){
    
       Alamofire.request(.GET ,  (ip as String)  + (ss as String) + (patch as String), parameters: ["":""], encoding: .URL, headers: header).responseJSON { (response) in
         switch response.result {
        case  .Success :
        if let JSON = response.result.value {
            success(dicDatas: JSON as! [String : AnyObject])
        }
        break
        case .Failure(let error) :
        failure(errorInfo: error)
        break
        }
     }
  }
    
    // MARK: - 图片上传服务器网络请求
    class  func  uploadImageRequesst(patch: NSString, data: NSData ,success : (dicDatas:[String : AnyObject]) -> () , failure : (errorInfo : NSError) -> ()){
        
            Alamofire.upload(.POST, (ip as String)  + (ss as String) + (patch as String), data: data).responseJSON { (response) in
                switch response.result {
                case  .Success :
                    if let JSON = response.result.value {
                        success(dicDatas: JSON as! [String : AnyObject])
                    }
                    break
                case .Failure(let error) :
                    failure(errorInfo: error)
                    break
                }
           }
     }
    
    // MARK: - 文件上传服务器网络请求
    class  func  uploadFileRequesst(patch: NSString, url: NSURL ,success : (dicDatas:[String : AnyObject]) -> () , failure : (errorInfo : NSError) -> ()){
        
        Alamofire.upload(.POST, (ip as String)  + (ss as String) + (patch as String), file: url).responseJSON { (response) in
            switch response.result {
            case  .Success :
                if let JSON = response.result.value {
                    success(dicDatas: JSON as! [String : AnyObject])
                }
                break
            case .Failure(let error) :
                failure(errorInfo: error)
                break
            }
        }
    }
}

