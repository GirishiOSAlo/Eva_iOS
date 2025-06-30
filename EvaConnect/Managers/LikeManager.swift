//
//  LikeManager.swift
//  EvaConnect
//
//  CreindexAted by Metis on 05/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class LikeManager {
    
    func homeLikeManager(homePosts: [DashboardItem], indexAt: Int, likeType: TypePostEnum) -> [DashboardItem] {
        
        var modelData = homePosts
        switch likeType {
        case .post:
            if modelData[indexAt].isPostLike == nil || modelData[indexAt].isPostLike == 0{
                modelData[indexAt].isPostLike = 1
                if modelData[indexAt].likeCount != 0{
                    modelData[indexAt].likeCount = 1 + (modelData[indexAt].likeCount ?? 0) 
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                modelData[indexAt].isPostLike = 1
            } else {
                modelData[indexAt].isPostLike = nil
                if modelData[indexAt].likeCount != 0 {
                    modelData[indexAt].likeCount = modelData[indexAt].likeCount! - 1
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
            }
           return modelData
        case .event:
            if modelData[indexAt].isEventLike == nil || modelData[indexAt].isEventLike == 0 {
                modelData[indexAt].isEventLike = 1
                if modelData[indexAt].likeCount != 0{
                    modelData[indexAt].likeCount = 1 + modelData[indexAt].likeCount!
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                modelData[indexAt].isEventLike = 1
            }
            else{
                modelData[indexAt].isEventLike = nil
                if modelData[indexAt].likeCount != 0 {
                    modelData[indexAt].likeCount = modelData[indexAt].likeCount! - 1
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
            }
          return  modelData
        case .job:
            if modelData[indexAt].isJobLike == nil || modelData[indexAt].isJobLike == 0{
                modelData[indexAt].isJobLike = 1
                if modelData[indexAt].likeCount != 0{
                    modelData[indexAt].likeCount = 1 + modelData[indexAt].likeCount!
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                modelData[indexAt].isJobLike = 1
            }
            else{
                modelData[indexAt].isJobLike = nil
                if modelData[indexAt].likeCount != 0 {
                    modelData[indexAt].likeCount = modelData[indexAt].likeCount! - 1
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                
            }
           return modelData
        default:
            if modelData[indexAt].isNewsLike == nil || modelData[indexAt].isNewsLike == 0{
                modelData[indexAt].isNewsLike = 1
                if modelData[indexAt].likeCount != 0{
                    modelData[indexAt].likeCount = 1 + modelData[indexAt].likeCount!
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                modelData[indexAt].isEventLike = 1
            }
            else{
                modelData[indexAt].isNewsLike = nil
                if modelData[indexAt].likeCount != 0 {
                    modelData[indexAt].likeCount = modelData[indexAt].likeCount! - 1
                }
                else{
                    modelData[indexAt].likeCount = 1
                }
                
            }
           return modelData
        }
    }
    
    func dashboardPostLikeManager(homePosts: [DashboardPostData], indexAt: Int) -> [DashboardPostData] {
        
        var modelData = homePosts
        if modelData[indexAt].isPostLike == nil || modelData[indexAt].isPostLike == 0{
            modelData[indexAt].isPostLike = 1
            if modelData[indexAt].likeCount != 0{
                modelData[indexAt].likeCount = 1 + (modelData[indexAt].likeCount ?? 0)
            }
            else{
                modelData[indexAt].likeCount = 1
            }
            modelData[indexAt].isPostLike = 1
        } else {
            modelData[indexAt].isPostLike = nil
            if modelData[indexAt].likeCount != 0 {
                modelData[indexAt].likeCount = modelData[indexAt].likeCount! - 1
            }
            else{
                modelData[indexAt].likeCount = 1
            }
        }
        return modelData
    }
}
