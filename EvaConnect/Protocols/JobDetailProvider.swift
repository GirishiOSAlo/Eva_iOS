//
//  JobDetailProvider.swift
//  EvaConnect
//
//  Created by usama on 12/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

protocol JobDetailProvider {
    func getJobDetial(jobId: Int, completion: @escaping (JobDetail?, Error?) -> Void)
}


extension JobDetailProvider {
    
    func getJobDetial(jobId: Int, completion: @escaping (JobDetail?, Error?) -> Void) {
        
        let endPoint = EndPoints.jobDetails + "\(jobId)/"
        print(endPoint)
        NetworkManagerr.request(endPoint) { (response) in
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let jobDetailRoot = try jsonDecoder.decode(JobDetailRoot.self, from: response.data!)
                    if !jobDetailRoot.error, jobDetailRoot.data.count > 0 {
                        
                        completion(jobDetailRoot.data[0], nil)
                    }
                    
                } catch {
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}

extension PostedJobDetailVC: JobDetailProvider { }
extension CreateEditPostedJobVC: JobDetailProvider { }
extension ApplicantDetailVC: JobDetailProvider { }

