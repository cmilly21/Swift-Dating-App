//
//  MatchTableViewCell.swift
//  TinderClone
//
//  Created by Connor Miller on 1/7/19.
//  Copyright © 2019 Connor Miller. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell {

    var recipientObjectId = ""
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendMessageTapped(_ sender: Any) {
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageTextField.text
        
        message.saveInBackground()
        
    }
    
}
