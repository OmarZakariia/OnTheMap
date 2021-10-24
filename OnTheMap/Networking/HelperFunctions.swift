//
//  HelperFunctions.swift
//  OnTheMap
//
//  Created by Zakaria on 19/10/2021.
//

import Foundation

class HelperFunctions {
    class  func taskForGetRequest <ResponseType: Decodable>(url : URL, type: String, responseType: ResponseType.Type, completion: @escaping(ResponseType?, Error?)->Void){
       var  request = URLRequest(url: url)
       request.httpMethod = "GET"
       if type == "Udacity" {
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       } else {
           request.addValue(ClientUdacity.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
           request.addValue(ClientUdacity.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
       }
       let task = URLSession.shared.dataTask(with: request) { data , response , error in
           if error !=  nil{
               completion(nil, error)
           }
           guard let data = data else {
               DispatchQueue.main.async {
                   completion(nil, error)
               }
               return
           }
           do {
               if type == "Udacity"{
                   let range = 5..<data.count
                   let newData =  data.subdata(in: range)
                   let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                   DispatchQueue.main.async {
                       completion(responseObject, nil)
                   }
               } else {
                   let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                   completion(responseObject, nil)
               }
           }
           catch{
               DispatchQueue.main.async {
                   completion(nil, error)
               }
           }
       }
       task.resume()
   }

    class   func taskForPostRequest<ResponseType: Decodable>(url: URL, type: String, responseType: ResponseType.Type, body: String, httpMethod: String,completion: @escaping(ResponseType?, Error?)->Void){
       
       var request =  URLRequest(url: url)
       if httpMethod == "POST"{
           request.httpMethod = "POST"
       } else {
           request.httpMethod = "PUT"
       }
       if type == "Udacity"{
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       } else {
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       }
       request.httpBody =  body.data(using: String.Encoding.utf8)
       
           
       let task = URLSession.shared.dataTask(with: request) { data , response , error  in
           if   error != nil {
               completion(nil, error)
               
           }
           guard let data = data else {
               DispatchQueue.main.async {
                   completion(nil, error)
               }
               return
           }
           do {
               if type == "Udacity" {
                   let range = 5..<data.count
                   let newData = data.subdata(in: range)
                   let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                   DispatchQueue.main.async {
                       completion(responseObject, nil)
                   }
               } else {
                   let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                   DispatchQueue.main.async {
                       completion(responseObject, nil)
                   }
               }
               
           }
           catch {
               DispatchQueue.main.async {
                   completion(nil, error)
               }
           }
       }
       task.resume()
   }


}
