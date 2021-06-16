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
            label.font = R.font.proximaNovaRegular(size: 16)
            label.textColor = UIColor.black
        case .smallEventSubtitle:
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.55)
        case .eventSummaryBanner:
            label.font = R.font.proximaNovaRegular(size: 14)
            label.textColor = UIColor.white
        case .priceBanner:
            label.font = R.font.proximaNovaSemibold(size: 13)
            label.textColor = UIColor.white
        case .genreTitle:
            break
        case .searchResultTitle:
            break
        case .searchResultSubtitle:
            break
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
}

extension UILabel {
    func styled(with style: LabelStyle) -> UILabel {
        LabelsStylesheet.style(label: self, with: style)
        return self
    }
}
