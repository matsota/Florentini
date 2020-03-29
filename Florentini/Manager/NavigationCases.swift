//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class NavigationCases {
    
    //MARK: - Enums for ViewControllers
    enum IDVC: String, CaseIterable {
        
        //for clients
        case MenuVC
        
        case UsersCartVC
        case CatalogVC
        case FeedbackVC
        case FAQVC
        
        case UserCatalogTVCell
        case UsersCartTVCell
        case UserHomeTVCell
        
        //for workers
        case WorkMenuVC
        
        case LoginWorkSpaceVC
        case MainWorkSpaceVC
        case WorkerCatalogVC
        case WorkerProfileVC
        case WorkersFAQVC
        case WorkersChatVC
        case NewProductSetVC
    
        case WorkerMessagesTVCell
        case WorkerCatalogTVCell
        case WorkerOrdersTVCell
        case WorkerOrdersDetailTVCell
    }

}


