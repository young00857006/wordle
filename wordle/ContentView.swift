//
//  ContentView.swift
//  wordle
//
//  Created by tingyang on 2022/3/23.
//

import SwiftUI
import UIKit
struct Keyboard: Identifiable {
    let name: String
    var color =  Color.white
    var id: String { name }
}

struct Data: Identifiable{
    let id = UUID()
    var color = Color.black
    var name: String
}

struct ContentView: View {
    @State private var array = [Substring]()
    @State var keyboards = [
        Keyboard(name: "A"),Keyboard(name: "B"),Keyboard(name: "C"),Keyboard(name: "D"),Keyboard(name: "E"),
        Keyboard(name: "F"),Keyboard(name: "G"),Keyboard(name: "H"),Keyboard(name: "I"),Keyboard(name: "J"),
        Keyboard(name: "K"),Keyboard(name: "L"),Keyboard(name: "M"),Keyboard(name: "N"),Keyboard(name: "O"),
        Keyboard(name: "P"),Keyboard(name: "Q"),Keyboard(name: "R"),Keyboard(name: "S"),Keyboard(name: "T"),
        Keyboard(name: "U"),Keyboard(name: "V"),Keyboard(name: "W"),Keyboard(name: "X"),Keyboard(name: "Y"),
        Keyboard(name: "Z"),Keyboard(name: "↵"),Keyboard(name: "<-")
    ]
    
    @State var datas = [Data]()
    @State var letter:Double = 4
    @State var grid = 24
    @State var alphatIndex = 0
    @State var Answer:String = "null"
    @State var num = [Substring]()
    @State private var showBingoAlert = false
    @State private var showFailAlert = false
    
    func initialRec (grid: Int){
        datas.removeAll()
        for _ in 1...grid{
            datas.append(Data(name:""))
        }
    }
    
    func initialCir(){
        for i in 0...26{
            keyboards[i].color = .white
        }
    }
    func inputAlphat(index: Int){
        datas[alphatIndex].name = keyboards[index].name
        alphatIndex += 1
    }
    
    func deleteAlphat(){
        if(alphatIndex>0){
            alphatIndex -= 1
        }
        datas[alphatIndex].name = ""
    }
    func answer(){
       
        if let asset = NSDataAsset(name: "fruit"),
        let content = String(data: asset.data, encoding: .utf8) {
            array = content.split(separator: "\n")
        }
        for (index, value) in array.enumerated(){
            if(array[index].count == Int(letter)){
                num.append(array[index])
            }
 
        }
        Answer = String(num.randomElement()!)
    }
    func enter(){
        var enterIndex = alphatIndex - 1
        var correct = Array(Answer)
        var black = true
        var bingo = 0

        for i in stride(from: enterIndex, to: enterIndex-Int(letter), by: -1){
            if(datas[i].name.lowercased() == String(correct[i%Int(letter)])){
                datas[i].color = .green
                bingo += 1
                black = false
            }
            for j in stride(from: Int(letter-1), to: -1, by: -1){
                if(datas[i].name.lowercased() == String(correct[j]) && i%4 != j && datas[i].color != .green){
                    datas[i].color = .yellow
                    black = false
                }
            }
            if(black){
                datas[i].color = .gray
            }
            black = true
        }
        for data in datas {
            for index in 0...26{
                if(keyboards[index].color == .white){
                    if(data.color == .green && data.name == keyboards[index].name){
                        keyboards[index].color = .green
                    }
                    else if(data.color == .yellow && data.name == keyboards[index].name){
                        keyboards[index].color = .yellow
                    }
                    else if(data.color == .gray && data.name == keyboards[index].name){
                        keyboards[index].color = .gray
                    }
                }
                
            }
        }
       
        if(bingo == Int(letter)){
            showBingoAlert = true
        }
        
        if(bingo != Int(letter) && alphatIndex == Int(letter*6)){
            showFailAlert = true
        }
    }
    
    var body: some View {
        Text("answer : \(Answer)")
        Button("start"){
            initialRec(grid: grid)
            initialCir()
            answer()
            showBingoAlert = false
            showFailAlert = false
            alphatIndex = 0
        }
        VStack{ //slider
            Slider(value: $letter, in: 4...6, step:1)
            Text("Letter : \(Int(letter))")
        }
        VStack{ //Recatangle
            let columns = Array(repeating: GridItem(), count: Int(letter))
            LazyVGrid(columns: columns) {
                ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                    Rectangle()
                        .foregroundColor(data.color)
                        .frame(height: 50)
                        .padding(5)
                        .overlay(
                            Text("\(data.name)")
                                .foregroundColor(.white)
                        )
                }
                .onChange(of: letter, perform: {value in
                    grid = Int(value)*6
                    initialRec(grid: grid)
                })
            }
            .alert("You Win!!",isPresented: $showBingoAlert,actions: { Button("OK"){}})
            .alert("Answer : \(Answer)", isPresented: $showFailAlert, actions: { Button("OK"){}})
        }
        
        VStack{//keyboard
            let columns = Array(repeating: GridItem(), count: 7)
            LazyVGrid(columns: columns) {
                ForEach(Array(keyboards.enumerated()), id: \.element.id) { index, keyboard in
                    Circle()
                        .foregroundColor(keyboard.color)
                        .frame(height: 20)
                        .padding(5)
                        .overlay(
                            Text("\(keyboard.name)")
                        )
                        .onTapGesture {
                            if(index == 27){
                                deleteAlphat()
                            }
                            else if(index == 26){
                                enter()
                            }
                            else{
                                inputAlphat(index: index)
                            }
                        }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
