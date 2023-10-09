//
//  HomeSubView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/25/23.
//

import SwiftUI

struct HomeReusableView: View {
    var imageName = ""
    var title = ""
    var description = ""
    
    var body: some View {
        Image(systemName: imageName)
            .font(.largeTitle)
            .foregroundColor(.buttonBackgroundColor)
        
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .customText(true)
            
            Text(description)
                .customText()
        }
    }
}

struct HomeSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeReusableView()
    }
}
