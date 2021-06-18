//
//  MainState.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 28/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

enum MainState: CustomState {
    
    case noInternet
    case noSearch

    var image: UIImage? {
        switch self {
        case .noInternet: return UIImage(named: "Empty Inbox _Outline")
        case .noSearch: return UIImage(named: "Search Engine_Outline")
        }
    }
    
    var title: String? {
        switch self {
        case .noInternet: return ""
        case .noSearch: return ""

        }
    }
    
    var description: String? {
        switch self {
        case .noInternet: return "Start creating your document library".language
        case .noSearch: return "No results found".language

        }
    }
    
    var titleButton: String? {
        switch self {
         case .noInternet: return nil
        case .noSearch: return nil

        }
    }
    
}
