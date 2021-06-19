//
//  LabelsStylesheet.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

enum LabelsStylesheet {
    static func style(label: UILabel, with style: LabelStyle) {
        //TODO: Handle
        switch style {
        case .largeEventTitle:
            label.font = R.font.proximaNovaBold(size: 20)
            label.textColor = .white
        case .largeEventSubtitle:
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.white.withAlphaComponent(0.8)
        case .smallEventTitle:
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = UIColor.black
        case .smallEventSubtitle:
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.55)
        case .eventSummaryBanner:
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.white
        case .priceBanner:
            label.font = R.font.proximaNovaSemibold(size: 13)
            label.textColor = UIColor.white
        case .navBarLargeTitle:
            label.font = R.font.proximaNovaBold(size: 26)
            label.textColor = UIColor.black
        case .navBarLargeSubtitle:
            label.font = R.font.proximaNovaSemibold(size: 18)
            label.textColor = UIColor.black.withAlphaComponent(0.6)
        case .navBarCompactTitle:
            label.textAlignment = .center
            label.font = R.font.proximaNovaBold(size: 15)
            label.textColor = UIColor.black
        case .navBarCompactSubtitle:
            label.textAlignment = .center
            label.font = R.font.proximaNovaRegular(size: 13)
            label.textColor = UIColor.black.withAlphaComponent(0.6)
        case .viewMoreHeaderTitle:
            label.font = R.font.proximaNovaSemibold(size: 16)
            label.textColor = UIColor.black
        case .viewMoreHeaderAction:
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.4)
        case .genreTitle:
            label.font = R.font.proximaNovaSemibold(size: 15)
            label.textColor = UIColor.white
        case .searchResultTitle:
            break
        case .searchResultSubtitle:
            break
        case .featuredPerformerTitle:
            label.textAlignment = .center
            label.font = R.font.proximaNovaBold(size: 32)
            label.textColor = UIColor.white
        case .featuredSportsTeamTitle:
            label.textAlignment = .center
            label.font = R.font.proximaNovaBold(size: 26)
            label.textColor = UIColor.white
        }
    }
}

enum LabelStyle {
    case largeEventTitle
    case largeEventSubtitle
    case smallEventTitle
    case smallEventSubtitle
    case eventSummaryBanner
    case priceBanner
    case genreTitle
    case searchResultTitle
    case searchResultSubtitle
    case navBarLargeTitle
    case navBarLargeSubtitle
    case navBarCompactTitle
    case navBarCompactSubtitle
    case viewMoreHeaderTitle
    case viewMoreHeaderAction
    case featuredPerformerTitle
    case featuredSportsTeamTitle
}

extension UILabel {
    func styled(with style: LabelStyle) -> UILabel {
        LabelsStylesheet.style(label: self, with: style)
        return self
    }
}
