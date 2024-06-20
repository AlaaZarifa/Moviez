//
//  MovieCardView.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 04/06/2024.
//

import SwiftUI

struct MovieCardView: View {
    
    let movie : Movie
    
    
    
    var body: some View {
        
        AsyncImage(url: URL(string: getImageURL())){ image in
            image.resizable()
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            
        } placeholder: {
            ProgressView().frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .tint(.gray)
            .frame(height: 250)
            .background{
                
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
    
                    .shadow(color: Color.gray.opacity(0.05), radius: 10, x: 5, y: 5)
                    .padding(5)
            }
        }
        
    }
    
    
    private func getImageURL()  -> String {
        let base = NetworkConstants.imageUrl
        let path = movie.poster_path ?? ""
        return base + path
    }
}


#Preview {
    MovieCardView(movie: Movie())
}
