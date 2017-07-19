//
//  FeedCell.swift
//  NikolaSocialMed
//
//  Created by Nikola Tosic on 7/18/17.
//  Copyright © 2017 Nikola Tosic. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var profileImag: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var caption: UITextView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
    }
    
}
