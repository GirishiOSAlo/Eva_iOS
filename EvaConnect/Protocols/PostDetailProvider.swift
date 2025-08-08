//
//  PostDetailProvider.swift
//  EvaConnect
//
//  Created by usama on 18/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation
import Alamofire

protocol PostActionProvidable {
    func postDetail(postId: Int, completion: @escaping (PostDetail?, PostType?, Error?) -> Void)
    func updateLikeStatus(postId: Int, action: String, completion: @escaping (Bool?, Error?) -> Void)
    func getComments(postId: Int, completion: @escaping ([Comments]?, Error?) -> Void)
    func addComments(postId: Int, text: String, completion: @escaping (Bool?, Error?) -> Void)
}

extension PostActionProvidable {
    
    func postDetail(postId: Int, completion: @escaping (PostDetail?, PostType?, Error?) -> Void) {
        
        let parameters: AFParameters = [ "user_id" : myUserDefaults.userId,
                                         "post_id" : postId ]
        
        NetworkManagerr.request(EndPoints.postDetails, method: .post, parameters: parameters) { (response) in
            print("\(PostManager.self) postDetail(:) requests for details")
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let postDetailRoot = try jsonDecoder.decode(PostDetailRoot.self, from: response.data!)
                    
                    if !postDetailRoot.error, postDetailRoot.data.count > 0 {
                        
                        let postDetail = postDetailRoot.data[0]
                        print("\(PostManager.self) postDetail(:) calling completion success")
                        
                        var postType: PostType = .simpleText
                        
                        if  postDetail.datumPostImage == [] && postDetail.postVideo == "" && postDetail.postDocument == "" { // && post.postDocument == nil
                            let vc = StoryboardRouter.textPostDetailVC()
                            postType = .simpleText
                        } else if postDetail.postVideo != "" {//Video
                            postType = .video
                        } else if postDetail.postDocument != "" { //document Cell
                            postType = .article
                        } else if (postDetail.datumPostImage?.count ?? 0) > 0 { // Image Cell
                            postType = .image
                        }
                        
                        completion(postDetail, postType, nil)
                    }
                } catch {
                    print("\(PostManager.self) postDetail(:) calling completion catch error")
                    print("\(String(describing: response.result.error?.localizedDescription))")
                    completion(nil, nil,response.result.error)
                }
            } else {
                print("\(PostManager.self) postDetail(:) calling completion api error: \(String(describing: response.result.error))")
                completion(nil, nil,response.result.error)
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    func updateLikeStatus(postId: Int, action: String, completion: @escaping (Bool?, Error?) -> Void) {
        
        let parameters: AFParameters = ["post_id" : postId,
                                        "created_by_id" : LoggedUserDetails.shared.user?.id ?? 0,
                                        "status": "pending",
                                        "action": action ]
        
        NetworkManagerr.request(EndPoints.likePost, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericResponse.error {
                        completion(true, nil)
                    }
                    
                } catch {
                    completion(nil, response.result.error)
                    
                }
            }
        }
    }
    
    func getComments(postId: Int, completion: @escaping ([Comments]?, Error?) -> Void) {
        
        let parameters: AFParameters = ["post_id": postId]
        NetworkManagerr.request(EndPoints.getCommentByFilterId, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let commentsRoot = try! jsonDecoder.decode(CommentDetailRoot.self, from: response.data!)
                    completion(commentsRoot.data, nil)
                    if commentsRoot.data.count > 0 {
                        completion(commentsRoot.data, nil)
                    }
                } catch {
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func addComments(postId: Int, text: String, completion: @escaping (Bool?, Error?) -> Void) {
         
         let parameters: AFParameters = [ "post_id": postId,
                                          "created_by_id" : myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id,
                                          "status": "pending",
                                          "content": text.encodeEmoji ]
        
        NetworkManagerr.request(EndPoints.addComment, method: .post, parameters: parameters) { (result: Result<GenericResponse>) in
            switch result {
            case .success(_):
                completion(true, nil)
            case .failure(let failure):
                completion(true, failure)
            }
        }
        
     }
}

extension PostManager: PostActionProvidable { }
extension TextPostDetailVC: PostActionProvidable { }
extension OtherCommentVC: PostActionProvidable { }
extension UrlCommentVC: PostActionProvidable { }
//extension EventCommentVC: PostActionProvidable { }
extension NewsCommentVC: PostActionProvidable { }
