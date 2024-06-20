//
//  MovieDetailsView.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 05/06/2024.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @StateObject var viewModel: MovieViewModel
    var movie : Movie
    var isUpcoming: Bool = false
    
    
    var body: some View {
        
        
        ZStack (alignment: .bottom){
            
            
            AsyncImage(url: URL(string: getImageURL())){ image in
                image.resizable()  // Allow image resizing
                    .aspectRatio(contentMode: .fill)  // Fill the frame
                    .edgesIgnoringSafeArea(.all)
                
            }
        placeholder: {
            ZStack{
                Image("placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView().frame(maxWidth: .infinity)
            }
        }
            
            
        }
        .toolbar(.hidden,for: .tabBar)
        .overlay(alignment: .bottom) {
            
            
            VStack {
                
                Text(movie.title ?? "")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.system(size: 27))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity)
                    .padding([.top],20)
                    .padding([.horizontal],15)
                
                if isUpcoming {
                    
                    HStack  {
                        Text("Coming Soon")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                                    .padding([.vertical],-7)
                                    .padding([.horizontal],-12)
                            )
                            .font(.system(size: 15))
                            .frame(height: 40)
                    }
                    .padding([.bottom],10)
                    
                } else {
                    HStack  {
                        
                        HStack(alignment: .center)  {
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 13,height: 13)
                                .frame(maxWidth: .zero)
                                .padding([.leading],10)
                            
                            let rate = String(format: "%.1f", movie.vote_average ?? 0.0)
                            
                            
                            Text(rate)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(width: 30)
                                .padding([.trailing],5)
                            
                            
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.black)
                                .opacity(0.5)
                                .padding([.vertical],-7)
                                .padding([.leading],-5)
                                .frame(width: 55)
                            
                        )
                        .padding([.trailing],10)
                        .frame( height: 40)
                        
                        
                        Text(movie.release_date?.getYear() ?? "" )
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                                    .padding([.vertical],-7)
                                    .padding([.horizontal],-12)
                            )
                            .font(.system(size: 15))
                            .frame(height: 40)
                            .padding([.leading],10)
                        
                    }
                    .padding([.bottom],10)
                }
                
                
                
                Text(movie.overview ?? "" )
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal],25)
                    .padding([.bottom],40)
                
                
                
                
            }
            .background{
                RoundedRectangle(cornerRadius: 30)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .opacity(0.95)
                
            }
            .padding([.horizontal],25)
            .padding([.bottom],-35)
            
        }
        
    }
    
    private func getImageURL()  -> String {
        //        guard movie != nil else { return "" }
        let base = NetworkConstants.imageUrl
        let path = movie.poster_path ?? ""
        return base + path
    }
}

#Preview {
    MovieDetailsView(
        viewModel: MovieViewModel(
            movieRepo: MovieRepositoryImpl(
                networkManager: NetworkManager()
            )
        ), movie: Movie()
    )
}

