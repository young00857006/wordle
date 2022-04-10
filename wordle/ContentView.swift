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
    @State var keyboards = [Keyboard]()
//        Keyboard(name: "A"),Keyboard(name: "B"),Keyboard(name: "C"),Keyboard(name: "D"),Keyboard(name: "E"),
//        Keyboard(name: "F"),Keyboard(name: "G"),Keyboard(name: "H"),Keyboard(name: "I"),Keyboard(name: "J"),
//        Keyboard(name: "K"),Keyboard(name: "L"),Keyboard(name: "M"),Keyboard(name: "N"),Keyboard(name: "O"),
//        Keyboard(name: "P"),Keyboard(name: "Q"),Keyboard(name: "R"),Keyboard(name: "S"),Keyboard(name: "T"),
//        Keyboard(name: "U"),Keyboard(name: "V"),Keyboard(name: "W"),Keyboard(name: "X"),Keyboard(name: "Y"),
//        Keyboard(name: "Z"),Keyboard(name: "↵"),Keyboard(name: "<-")
//    ]
    
    @State var datas = [Data]()
    @State var letter:Double = 4
    @State var grid = 24
    @State var alphatIndex = 0
    @State var Answer:String = "null"
    @State var num = [Substring]()
    @State private var showBingoView = false
    @State private var showFailView = false
    @State private var showSecondView = false
    @State private var showEnoughAlert = false
    @State private var showWordListAlert = false
    @State private var showShare = false
    @State var share = false
    @State var click = 0
    
    func initialCircle(){
        keyboards = [
            Keyboard(name: "A",color: .white),Keyboard(name: "B",color: .white),
            Keyboard(name: "C",color: .white),Keyboard(name: "D",color: .white),
            Keyboard(name: "E",color: .white),Keyboard(name: "F",color: .white),
            Keyboard(name: "G",color: .white),Keyboard(name: "H",color: .white),
            Keyboard(name: "I",color: .white),Keyboard(name: "J",color: .white),
            Keyboard(name: "K",color: .white),Keyboard(name: "L",color: .white),
            Keyboard(name: "M",color: .white),Keyboard(name: "N",color: .white),
            Keyboard(name: "O",color: .white),Keyboard(name: "P",color: .white),
            Keyboard(name: "Q",color: .white),Keyboard(name: "R",color: .white),
            Keyboard(name: "S",color: .white),Keyboard(name: "T",color: .white),
            Keyboard(name: "U",color: .white),Keyboard(name: "V",color: .white),
            Keyboard(name: "W",color: .white),Keyboard(name: "X",color: .white),
            Keyboard(name: "Y",color: .white),Keyboard(name: "Z",color: .white),
            Keyboard(name: "↵",color: .white),Keyboard(name: "<-",color: .white)
        ]
    }
    func initialRec (grid: Int){
        datas.removeAll()
        for _ in 1...grid{
            datas.append(Data(name:""))
        }
    }
    
    func clean(){
        for _ in 0..<Int(letter){
            datas[alphatIndex-1].name = ""
            alphatIndex -= 1
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
        num.removeAll()
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
    func judgeWordList()->Bool{
        var enterIndex = alphatIndex
        var temp = [String]()
        var tempString: String
        var isHave = false
        for i in stride(from: enterIndex-Int(letter), to: enterIndex, by: 1){
            temp.append(datas[i].name.lowercased())
        }
        tempString = temp.joined()
        for (index,value) in num.enumerated(){
            if(String(num[index]) == tempString){
                isHave = true
            }
        }
        return isHave
        
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
            showBingoView = true
            showShare = true
            share = true
        }
        
        if(bingo != Int(letter) && alphatIndex == Int(letter*6)){
            showFailView = true
        }
    }
    
    var body: some View {
//        Text("answer : \(Answer)")
        Text("WORDLE - FRUIT")
        if(share){
            Button("share"){showShare = true}
            .fullScreenCover(isPresented: $showShare){
                SecondView(showBingoView: $showBingoView, showFailView: $showFailView, Answer: $Answer,datas: $datas,letter:$letter,showShare:$showShare)
            }
        }
        Button("start"){
            initialRec(grid: grid)
            initialCircle()
            answer()
            showBingoView = false
            showFailView = false
            alphatIndex = 0
            click = 0
            share = false
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
                    initialCircle()
                    alphatIndex = 0
                    answer()
                    click = 0
                    share = false
                })
            }
//            .alert("You Win!!",isPresented: $showBingoAlert,actions: { Button("OK"){}})
//            .alert("Answer : \(Answer)", isPresented: $showFailAlert, actions: { Button("OK"){}})
            .fullScreenCover(isPresented: $showBingoView){
                SecondView(showBingoView: $showBingoView, showFailView: $showFailView, Answer: $Answer,datas: $datas,letter:$letter, showShare: $showShare)
            }
            .fullScreenCover(isPresented: $showFailView){
                SecondView(showBingoView: $showBingoView, showFailView: $showFailView, Answer: $Answer,datas: $datas,letter:$letter,showShare: $showShare)
            }
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
                                if(click > 0){
                                    click -= 1
                                }
                            }
                            else if(index == 26 && click == Int(letter)){
                                if(judgeWordList()){
                                    enter()
                                }
                                else{
                                    showWordListAlert = true
                                    clean()
                                }
                                click = 0
                            }
                            else if(index == 26 && click<Int(letter)){
                                showEnoughAlert = true
                            }
                            else if(click < Int(letter) && index != 27 && index != 26){
                                inputAlphat(index: index)
                                click += 1
                            }
                           
                        }
                        .alert("not enough letters", isPresented: $showEnoughAlert, actions: {Button("OK"){}})
                        .alert("not in word list", isPresented: $showWordListAlert, actions: {Button("OK"){}})
                    
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
