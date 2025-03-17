//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Ali Syed on 2024-10-25.
//

import SwiftUI

struct FlagImage: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}
