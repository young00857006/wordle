//
//  SecondView.swift
//  wordle
//
//  Created by tingyang on 2022/4/9.
//

import SwiftUI
import UIKit

struct SecondView: View{
    @Binding var showBingoView: Bool
    @Binding var showFailView: Bool
    @Binding var Answer: String
    
    var body: some View{
        if(showBingoView){
            ZStack{
                Color.white
                .ignoresSafeArea()
                Text("You Win!!")
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    showBingoView = false
                } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(20)
                }
            }
        }
        if(showFailView){
            ZStack{
                Color.white
                .ignoresSafeArea()
                Text("You Lose!!\n\n")
                Text("Answer : \(Answer)")
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    showFailView = false
                } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(20)
                }
            }
        }
        
        
    }
}
