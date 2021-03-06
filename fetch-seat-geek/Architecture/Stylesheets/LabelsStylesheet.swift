//
//  LabelsStylesheet.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

enum LabelsStylesheet {
    static func style(label: UILabel, with style: LabelStyle) {
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
            label.numberOfLines = 2
        case .featuredSportsTeamTitle:
            label.textAlignment = .center
            label.font = R.font.proximaNovaBold(size: 26)
            label.textColor = UIColor.white
            label.numberOfLines = 2
        case .actionButton:
            label.textAlignment = .center
            label.font = R.font.proximaNovaSemibold(size: 16)
            label.textColor = UIColor.white
            label.numberOfLines = 1
        case .eventDetailsTitle:
            label.font = R.font.proximaNovaBold(size: 25)
            label.textColor = UIColor.black
        case .eventDetailsSubtitle:
            label.font = R.font.proximaNovaBold(size: 20)
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor.black.withAlphaComponent(0.7)
        case .eventDetailsLocationTitle:
            label.numberOfLines = 1
            label.font = R.font.proximaNovaSemibold(size: 18)
            label.textColor = UIColor.black
        case .eventDetailsLocationName:
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = UIColor.black
        case .eventDetailsLocation:
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.5)
        case .travelTimeTitle:
            label.numberOfLines = 1
            label.lineBreakMode = .byWordWrapping
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = UIColor.black
        case .travelTimeTime:
            label.numberOfLines = 1
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.4)
        case .seeMoreTitle:
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = R.color.seatGeekBlue()
        case .trackedEventTitle:
            label.font = R.font.proximaNovaSemibold(size: 18)
            label.textColor = .black
        case .trackedEventSubtitle:
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = UIColor.black.withAlphaComponent(0.5)
        case .trackedEventPrice:
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = R.color.dollarGreen()
        case .searchEntryTitle:
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = .black
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
    case actionButton
    case eventDetailsTitle
    case eventDetailsSubtitle
    case eventDetailsLocationTitle
    case eventDetailsLocationName
    case eventDetailsLocation
    case travelTimeTitle
    case travelTimeTime
    case seeMoreTitle
    case trackedEventTitle
    case trackedEventSubtitle
    case trackedEventPrice
    case searchEntryTitle
}

extension UILabel {
    func styled(with style: LabelStyle) -> UILabel {
        LabelsStylesheet.style(label: self, with: style)
        return self
    }
}
