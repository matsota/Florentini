//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
class NavigationManager {
    
    //MARK: - Системные переменные
    static let shared = NavigationManager()
    
    //    let transition = SlideInTransition()
    
    
    //MARK: - Enums for ViewControllers
    enum IDVC: String, CaseIterable {
        
        //for clients
        case CatalogVC
        case FeedbackVC
        case FAQVC
        
        case UserCatalogTVCell
        
        case MenuVC
        
        case CartVC
        case CartTVCell
        
        case UserHomeTVCell
        
        //for workers
        case LoginWorkSpaceVC
        case MainWorkSpaceVC
        case WorkerCatalogVC
        case WorkerProfileVC
        case WorkersFAQVC
        case WorkersChatVC
        
        case WorkMenuVC
        case WorkerMessagesTVCell
        case WorkerCatalogTVCell
    }

}


