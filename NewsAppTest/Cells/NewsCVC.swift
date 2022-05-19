//
//  NewsCVC.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import UIKit

struct NewsCVCData {
    let title: String
    let content: String
    let date: Date
    let imageURL: URL?
}

class NewsCVC: UICollectionViewCell {
    
    let imageView: UIImageView = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let titleLabel: UILabel = UILabel().with {
        $0.font = UIFont.boldSystemFont(ofSize: 18.0)
        $0.numberOfLines = 2
        $0.textColor = .black
    }
    
    let contentLabel: UILabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.numberOfLines = 2
        $0.textColor = .gray
    }
    
    let dateLabel: UILabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.textColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    var data: NewsCVCData? {
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
            contentLabel.text = data.content
            dateLabel.text = NewsDateFormatter.format(date: data.date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds,cornerRadius: 8.0).cgPath
    }
    
    private func layout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 130.0),
            imageView.heightAnchor.constraint(equalToConstant: 130.0)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12.0),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12.0)
        ])
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12.0),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12.0)
        ])
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12.0),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0)
        ])
    }
}
