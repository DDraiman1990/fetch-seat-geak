//
//  AppConstants.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import UIKit

enum AppConstants {
    enum Database {
        static let suiteName = "com.nexxmark.fetch-seat-geek"
    }
    enum Keys {
        static let seatGeekStoredClientId = "seat-geek-client"
        static let seatGeekClientIdParamName = "client_id"
    }
    
    enum Logs {
        static let category = "fetch-seat-geak"
        static let logFormat = LogFormat()
    }
    
    enum Dates {
        enum Formats {
            static let dayWithShortSlashDate = "EEE, M/d"
            static let shortDate = "MMM d"
        }
    }
    
    enum DateFormatters {
        static let fullDateAndTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d, yyyy 'at' h:mm aa"
            return formatter
        }()
    }
    
    enum Collections {
        enum Layouts {
            static func basicHorizontal(spacing: CGFloat = 0) -> UICollectionViewLayout {
                let flowlayout = UICollectionViewFlowLayout()
                flowlayout.minimumInteritemSpacing = 0
                flowlayout.minimumLineSpacing = spacing
                flowlayout.scrollDirection = .horizontal
                return flowlayout
            }
            
            static func horizontalSnap() -> UICollectionViewLayout {
                return ZoomAndSnapFlowLayout()
            }
        }
    }
}
