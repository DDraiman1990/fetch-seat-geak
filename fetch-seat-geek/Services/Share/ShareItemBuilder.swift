//
//  ShareItemBuilder.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

/// Responsible for building the Activitiy item for the required sharing of
/// the app.
///
class ShareItemBuilder {
    
    // MARK: - Properties
    
    //Components to be turned into Activity Items.
    private var components: URLComponents?
    var method: ShareMethod? = nil {
        didSet {
            updateQueryItems()
            updatePath()
        }
    }
    
    var baseUrl: URL{
        didSet {
            updateQueryItems()
            updatePath()
        }
    }
    var subpath: String? {
        didSet {
            updatePath()
        }
    }
    var queryItems: [URLQueryItem]{
        didSet {
            updateQueryItems()
        }
    }
    
    // MARK: - Lifecycle
    
    init(baseUrl: URL, subpath: String?, queryItems: [URLQueryItem]) {
        self.baseUrl = baseUrl
        self.subpath = subpath
        self.queryItems = queryItems
        updateUrl()
    }
    
    private func updateUrl() {
        self.components = URLComponents(
            url: baseUrl,
            resolvingAgainstBaseURL: false)
        updateQueryItems()
        updatePath()
    }
    
    private func updateQueryItems() {
        components?.queryItems = queryItems
        components?.query = nil
    }
    
    private func updatePath() {
        if let path = subpath {
            components?.path = path
        }
    }
    
    // MARK: - Build
    
    /// Will build the required activity items for a Share Activity.
    ///
    /// - Parameters:
    ///   - activityType: the actual share method (usually returned by the
    /// activity delegate.
    ///   - shareBody: the share body for the item.
    /// - Returns: String representing all the share items combined together.
    func buildActivityItem(
        activityType: UIActivity.ActivityType,
        shareBody: String?) -> String {
        self.method = activityType.toShareMethod()
        let componentsUrl = components?.url?.absoluteString ?? ""
        if let body = shareBody {
            return "\(body) \n\n \(componentsUrl)"
        } else {
            return componentsUrl
        }
    }
    
}

private extension UIActivity.ActivityType {
    func toShareMethod() -> ShareMethod {
        switch self {
        case UIActivity.ActivityType.mail: return .email
        case UIActivity.ActivityType.message: return .messages
        case UIActivity.ActivityType.copyToPasteboard: return .pasteBoard
        case UIActivity.ActivityType.postToFacebook: return .facebook
        case UIActivity.ActivityType.postToTwitter: return .twitter
        default: return .other
        }
    }
}
