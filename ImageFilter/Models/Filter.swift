//
//  Filter.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 04.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

struct Filter {
    var filterName: String
    var filterEffectValue: Any?
    var filterEffectValueName: String?
    
    init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?) {
        self.filterName = filterName
        self.filterEffectValue = filterEffectValue
        self.filterEffectValueName = filterEffectValueName
    }
}
