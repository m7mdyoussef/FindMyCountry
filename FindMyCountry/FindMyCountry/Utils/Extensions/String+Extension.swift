//
//  String+Extension.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

extension String {
    var image: Image {
        return Image(self)
    }
    
    var color: Color {
        return Color(self)
    }
    
    var systemImage: Image {
        return Image(systemName: self)
    }
}
