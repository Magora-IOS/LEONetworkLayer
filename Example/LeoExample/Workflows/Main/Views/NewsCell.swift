//
//  NewsCell.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/22/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    static let Identifier = "NewsCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.descriptionLabel.text = nil
    }

    func configureWithNews(_ news: News?) {
        self.titleLabel.text = news?.title
        self.dateLabel.text = news?.createDate?.dateTimeNewsFormat        
    }
}
