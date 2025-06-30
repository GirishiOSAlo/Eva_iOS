//
//  PostManager.swift
//  EvaConnect
//  Created by usama on 26/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD
import SVProgressHUD

class PostManager {
    
    func postDetailType(postDetail: PostDetail) -> UIViewController {
        
        if postDetail.postImage?.count == 0 && postDetail.postVideo.isNil && postDetail.postDocument.isNil {
            return StoryboardRouter.textPostDetailVC()
        } else if !postDetail.postDocument.isNil{
            return StoryboardRouter.urlComment()
        } else {
            return StoryboardRouter.otherComment()
        }
    }
    
    // If post id is not null then, the request will be patch otherwise post
    func createUpdatePost<T: Codable>(contents: [PostContent], postId: Int?, completion: @escaping (Result<T>) -> Void) {
        let user = LoggedUserDetails.shared.user!
        var parameters: AFParameters = ["user_id" : user.id ?? 0, "created_by_id" :  user.id ?? 0, "status": "pending", "content": contents.first?.text.trim ?? "",
                                        "is_url": contents.contains(where: { $0.isDocument })]
        
        var url = EndPoints.newPost
        if let postId = postId {
            parameters["modified_by_id"] = myUserDefaults.userId  //LoggedUserDetails.shared.user!.id
            parameters["modified_datetime"] = Date().toString(formatter: .standardDateWithTime)
            url = "\(EndPoints.updatePost)\(postId)/"
        }
        
        SVProgressHUD.show()
        let headers = HTTPHeaders()
        var defaultHeaders = ["Os" : "iOS", "Content-Type": "application/json" ]
        if let token = (UserDefaults.standard.value(forKey: "UserToken")) { defaultHeaders["Authorization"] = "Bearer \(token)" }
        headers.forEach({ defaultHeaders[$0.key] = $0.value })
        
        Alamofire.upload(multipartFormData: { multiFormData in
            parameters.forEach({ multiFormData.append("\($0.value)".data(using: String.Encoding.utf8)!, withName: $0.key) })
            contents.forEach({ content in
                switch content {
                case .image(_, let image):
                    if let image = image, let data = image.jpegData(compressionQuality: 0.5) {
                        multiFormData.append(data, withName: "post_image", fileName: "Chat_image\(Date().millisecondsSince1970).jpg", mimeType: "image/png")
                    }
                case .video(let url, _):
                    multiFormData.append(url, withName: "post_video")
                case .document(let url):
                    guard let pdfData = try? Data(contentsOf: url) else { return }
                    multiFormData.append(pdfData, withName: "post_document", fileName: url.lastPathComponent, mimeType: "pdf")
                default:
                    print("none")
                }
            })
        }, to: url, method: postId.isNil ? .post : .patch, headers: SharedHeaders.headers) { request in
            switch request {
            case .success(let request,_,_):
                request.responseJSON { response in
                    guard let data = response.data else { return }
                    print(String(data: data, encoding: .utf8) ?? "invalid json")
                    do { completion(.success(try JSONDecoder().decode(T.self, from: data))) }
                    catch let error { completion(.failure(error)) }
                    SVProgressHUD.dismiss()
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion(.failure(error))
            }
        }
    }
}
