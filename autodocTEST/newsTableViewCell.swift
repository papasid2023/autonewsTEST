//
//  newsTableViewCell.swift
//  autodocTEST
//
//  Created by Руслан Сидоренко on 26.06.2024.
//

import Foundation
import UIKit

class newsTableViewCellModel {
    var imageURL: URL?
    let title: String
    var imageData: Data?
    
    init(imageURL: URL?, title: String) {
        self.imageURL = imageURL
        self.title = title
    }
}

class newsTableViewCell: UITableViewCell {
    
    static let identifier = "newsTableViewCell"
    
    private let newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.contentMode = .scaleAspectFill
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 5
        return newsImage
    }()
    
    private let newsTitle: UILabel = {
        let newsTitle = UILabel()
        newsTitle.numberOfLines = 0
        newsTitle.lineBreakMode = .byWordWrapping
        newsTitle.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return newsTitle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsTitle)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImage.frame = CGRect(x: 5, y: 5, width: 95, height: 95)
        
        newsTitle.frame = CGRect(x: 110, y: 5, width: 200, height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
        newsTitle.text = nil
    }
    
    func configure(with viewModel: newsTableViewCellModel){
        newsTitle.text = viewModel.title
        
        if let data = viewModel.imageData {
            newsImage.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
}
