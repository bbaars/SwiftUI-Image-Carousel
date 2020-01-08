//
//  ImageCarouselView.swift
//  ImageCarousel
//
//  Created by Brandon Baars on 1/7/20.
//  Copyright © 2020 Brandon Baars. All rights reserved.
//

import SwiftUI
import Combine

struct ImageCarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content

    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            // 1
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    self.content
                }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                    .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                    .animation(.spring())
                    .onReceive(self.timer) { _ in
                        self.currentIndex = (self.currentIndex + 1) % 3
                }
                
                // 2
                HStack(spacing: 3) {
                    // 3
                    ForEach(0..<self.numberOfImages, id: \.self) { index in
                         // 4
                        Circle()
                            .frame(width: index == self.currentIndex ? 10 : 8,
                                   height: index == self.currentIndex ? 10 : 8)
                            .foregroundColor(index == self.currentIndex ? Color.blue : .white)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 8)
                            .animation(.spring())
                    }
                }
            }
        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        
        // 8
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: 3) {
                Image("image_carousel_1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("image_carousel_2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("image_carousel_3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}
