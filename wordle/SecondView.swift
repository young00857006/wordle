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
    @Binding var datas: Array<Data>
    @Binding var letter: Double
    @Binding var showShare:Bool
    
   
    
    var body: some View{
        
        ZStack{
            Color.white
                .ignoresSafeArea()
            if(showBingoView){
                Text("You Win!!\n\n\n")
            }
            else  if(showFailView){
                Text("You Lose!!\n\n\n")
                Text("Answer : \(Answer)")
            }
            VStack{
                let columns = Array(repeating: GridItem(spacing:0), count: Int(letter))
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                        if(data.color == .green){
                            Text("🟩")
                        }
                        else if(data.color == .yellow){
                            Text("🟨")
                        }
                        else if(data.color == .gray){
                            Text("⬛️")
                        }
                      
                    }
                }
            }
            
            
            
        }
        .overlay(alignment: .topTrailing) {
            Button {
                showBingoView = false
                showFailView = false
                showShare = false
            } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(20)
            }
        }
        VStack{
            
        }
    }
}
