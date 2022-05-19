//
//  NewsFeedVC.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import UIKit
import SafariServices

protocol NewsFeedVCInterface: AnyObject {
    func reloadData()
    func showError(message: String)
    func openNews(at url: URL)
}

class NewsFeedVC: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "News"
    }
    
    var presenter: NewsFeedPresenter!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).with {
        $0.register(cellWithClass: FeaturedNewsCVC.self)
        $0.register(cellWithClass: NewsCVC.self)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        presenter.onViewDidLoad()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension NewsFeedVC: NewsFeedVCInterface {
    func openNews(at url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension NewsFeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let news = presenter.news(at: indexPath) else {
            preconditionFailure()
        }

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: FeaturedNewsCVC.self, for: indexPath)
            cell.data = FeaturedNewsCVCData(title: news.title, date: news.date, imageURL: news.imageURL)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: NewsCVC.self, for: indexPath)
            cell.data = NewsCVCData(title: news.title, content: news.description, date: news.date, imageURL: news.imageURL)
            return cell
        }
    }

    private var padding: Double { 12.0 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let coef: Double = 3.0 / 5.0
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width * coef)
        } else {
            return CGSize(width: collectionView.bounds.width - padding * 2.0, height: 130.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        presenter.handleNewsTap(at: indexPath)
        return false
    }
}
