//
//  HomeModel.swift
//  PinkBook
//
//  Created by mac on 2023/4/21.
//

import UIKit

enum HomesCategory: Int, CaseIterable {
    case follow = 1
    case discover = 2
    case nearby = 3
    
    var title: String {
        switch self {
        case .follow: return NSLocalizedString("Follow", comment: "首页的关注标签")
        case .discover: return "Discover"
        case .nearby: return "Nearby"
        }
    }
}

enum DiscoverCategory: Int, CaseIterable {
    case topNews = 1
    case sports = 2
    case business = 3
    case opinions = 4
    case culture = 5
    case photos = 6
    case world = 7
    case travel = 8
    case tech = 9
    
    var title: String {
        switch self {
        case .topNews: return "TOP NEWS"
        case .sports: return "SPORTS"
        case .business: return "BUSINESS"
        case .opinions: return "OPINIONS"
        case .culture: return "CULTURE"
        case .photos: return "PHOTOS"
        case .world: return "WORLD"
        case .travel: return "TRAVEL"
        case .tech: return "TECH"
        }
    }
}
