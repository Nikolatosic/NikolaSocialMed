//
//  Post.swift
//  NikolaSocialMed
//
//  Created by Nikola Tosic on 7/19/17.
//  Copyright © 2017 Nikola Tosic. All rights reserved.
//

import Foundation
// Model for Post Object

class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String { // <- "caption" is a name of key value in json object
            self._caption = caption
        }
        if let imageURL = postData["imageURL"] as? String{
            self._imageURL = imageURL
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
    }
    
}
