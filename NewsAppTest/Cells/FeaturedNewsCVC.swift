//
//  FeaturedNewsCVC.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import UIKit

struct FeaturedNewsCVCData {
    let title: String
    let date: Date
    let imageURL: URL?
}

class FeaturedNewsCVC: UICollectionViewCell {
    
    let imageView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    
    var data: FeaturedNewsCVCData? {
        didSet {
            guard let data = data else {
                return
            }
            
            if let imageURL = data.imageURL {
                Task {
                    do {
                        imageView.image = try await SimpleImageLoader.loadImageFrom(urlString: imageURL)
                    } catch {
                        imageView.image = nil
                    }
                }
            } else {
                imageView.image = nil
            }
            
            titleLabel.text = data.title
            dateLabel.text = NewsDateFormatter.format(date: data.date)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -16.0)
        ])
    }
}
