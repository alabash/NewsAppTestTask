//
//  NewsFeedPresenter.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

protocol NewsFeedPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func news(at indexPath: IndexPath) -> News?
    func numberOfItems(at section: Int) -> Int
    func handleNewsTap(at indexPath: IndexPath)
}

class NewsFeedPresenter: NewsFeedPresenterProtocol {
    
    let newsService: NewsService
    let view: NewsFeedVCInterface
    
    var featuredNews: News? = nil
    var feedNews: [News] = []
    
    init(view: NewsFeedVCInterface, newsService: NewsService = NewsService()) {
        self.view = view
        self.newsService = newsService
    }
    
    func onViewDidLoad() {
        Task {
            do {
                featuredNews = try await newsService.getFeaturedNews()
                feedNews = try await newsService.getAllNews()
                
                DispatchQueue.main.async { [weak self] in
                    self?.view.reloadData()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.view.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func handleNewsTap(at indexPath: IndexPath) {
        guard let news = news(at: indexPath) else {
            return
        }
        
        view.openNews(at: news.articleURL)
    }
    
    func news(at indexPath: IndexPath) -> News? {
        if indexPath.section == 0 {
            return featuredNews
        } else {
            return feedNews[indexPath.item]
        }
    }
    
    func numberOfItems(at section: Int) -> Int {
        if section == 0 {
            return featuredNews == nil ? 0 : 1
        } else {
            return feedNews.count
        }
    }
}
