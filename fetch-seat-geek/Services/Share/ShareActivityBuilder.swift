//
//  ShareActivityBuilder.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import Foundation
import UIKit

/// Responsible for building a UIActivitiyViewController for sharing
/// content in the app.
class ShareActivityBuilder: NSObject {
    
    // MARK: - Properties

    private var data: ShareData
    private var image: UIImage?
    private var body: String?
    private let shareUrlBuilder: ShareItemBuilder
    private var placeholder: String?
    private let defaultActivity = UIActivity.ActivityType.message
    
    // MARK: - Lifecycle
    
    
    /// Init with all the required and optional components for an activity.
    ///
    /// - Parameter shareData: the required data for an activity.
    init(shareData: ShareData) {
        shareUrlBuilder = ShareItemBuilder(
            baseUrl: shareData.baseUrl,
            subpath: shareData.subUrlPath,
            queryItems: shareData.queryItems)
        self.data = shareData
        super.init()
        set(body: data.body)
        set(image: data.image)
    }
    
    // MARK: - Configure
    
    
    /// Set the Share Body for the share activity.
    /// This will be the bottom text, below the subject and above the URL.
    ///
    /// - Parameter body: share body for the share activity.
    func set(body: String?) {
        self.body = body
    }
    
    /// Set the Share Placeholder for the share activity.
    ///
    /// - Parameter body: share placeholder for the share activity.
    func set(placeholder: String?) {
        self.placeholder = placeholder
    }
    
    /// Set the Share Image for the share activity.
    /// This will be included on the top of the message
    ///
    /// - Parameter body: share body for the share activity.
    func set(image: UIImage?) {
        self.image = image
    }
    
    // MARK: - Build

    /// Build and return the UIActivityViewController responsible for sharing.
    ///
    /// - Parameter onDismissed: callback which will be called on the activity
    /// dismissal (whether successful or not).
    /// - Returns: UIActivityViewController responsible for sharing.
    func buildActivityViewController(onDismissed: @escaping (Bool) -> Void) -> UIActivityViewController {
        var items: [Any] = [self]
        //Making sure image is the top of the share.
        if let image = data.image {
            items.insert(image, at: 0)
        }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.completionWithItemsHandler = { (_, success, _, _) in
            onDismissed(success)
        }
        
        return vc
    }
}

// MARK: - UIActivityItemSource

extension ShareActivityBuilder: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return placeholder ?? ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let activity = activityType ?? defaultActivity
        var bodyString = data.body
        let spaceString = (0..<data.spacesAfterTitle).map{_ in "\n"}.joined()
        if !data.subject.isEmpty {
            bodyString = "\(data.subject)\(spaceString)\(data.body ?? "")"
        }
        return shareUrlBuilder.buildActivityItem(activityType: activity, shareBody: bodyString)
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return data.subject
    }
}
