//
//  ContentView.swift
//  anagram-solver-ios
//
//  Created by Harry Witcomb on 21/08/2022.
//

import SwiftUI

struct AppColor{
    static let main = Color.white
    static let main2 = Color(red: 200/255, green: 244/255, blue: 249/255)

    static let accent = Color(red: 60/255, green: 172/255, blue: 174/255)
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var anagram: String = ""
    
    @State private var checkedState = false
    
    @State private var isPresenting = false
    

    private var gridItemLayout = [GridItem(.fixed(1))]
    
    var body: some View {
        
        //let mainColor = Color(red: 13/255, green: 71/255, blue: 161/255)
        //let toolbarColor = Color(red: 0/255, green: 33/255, blue: 113/255)
        
        //let codecademyBlue = Color(red: 20/255, green: 28/255, blue: 58/255)
        //let accentColor = Color(red: 0/255, green: 119/255, blue: 182/255)
        
        NavigationView{
            ZStack{
                AppColor.main.ignoresSafeArea()
                VStack(){
                    HStack(){
                        Spacer()
                        TextField("Enter anagram here", text: $anagram)
                            .padding()
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        Spacer()
                        Button(action: {
                            viewModel.readAnagram(anagram: anagram, checkedState: checkedState)
                            print("Solve button tapped")
                        }){
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .padding()
                                .background(AppColor.accent)
                                .clipShape(Capsule())
                        }
                        
                        
                        Spacer()
                    }
                    .padding(4)
                    HStack(){
                        Text("Matches: \(viewModel.matches)").foregroundColor(.black)
                    }
                    .padding()
                    ScrollView (){
                        VStack(){
                            ForEach(viewModel.words, id: \.self){ word in
                                WordCard(word: word)
                            }
                        }
                    }
                    
                }
                .padding()
                .navigationTitle("Anagram Solver")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isPresenting, content: {
                    ZStack{
                        AppColor.main.ignoresSafeArea()
                        VStack(alignment: .leading){
                            HStack{
                                Text("Instructions")
                            }
                            .padding(EdgeInsets(top: 32, leading: 0, bottom: 8, trailing: 0))
                            VStack(alignment: .leading){
                                Text("Anagrams")
                                    .fontWeight(.light)
                                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                Text("Enter all the letters in the anagram and tap solve")
                                    .fontWeight(.ultraLight)
                            }
                            VStack(alignment: .leading){
                                Text("Anagrams with Missing Letters")
                                    .fontWeight(.light)
                                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                Text("Enter all the letters you know followed by a plus (+) for every letter that you do not know and tap solve")
                                    .fontWeight(.ultraLight)
                            }
                            VStack(alignment: .leading){
                                Text("Crossword Puzzles")
                                    .fontWeight(.light)
                                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                Text("Enter all the known letters in their position with a period (.) in the positions where the letter is unkown and tap solve")
                                    .fontWeight(.ultraLight)
                            }
                            VStack(alignment: .leading){
                                Text("Sorting")
                                    .fontWeight(.light)
                                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                Text("Use the sort button in the toolbar to organise results either alphabetically, reverse alphabetically, or by size either increasing or decreasing")
                                    .fontWeight(.ultraLight)
                            }
                            VStack(alignment: .leading){
                                Text("Sub-Anagrams")
                                    .fontWeight(.light)
                                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                Text("Use the sub-anagrams button in the toolbar to toggle whether or not to be shown sub-anagrams of the anagram you have entered")
                                    .fontWeight(.ultraLight)
                            }
                            Spacer()
                            
                        }
                        .padding()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .confirmationAction, content: {
                            Button("Close"){
                                isPresenting.toggle()
                            }
                        })
                    })
                })
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Menu{
                            Button("A - Z", action: sortWordsAlpha)
                            Button("Z - A", action: sortWordsReverseAlpha)
                            Button("Length - Asc", action: sortWordsLengthAsc)
                            Button("Length - Desc", action: sortWordsLengthDesc)
                        }
                    label:{
                        Label("Sort", systemImage: "arrow.up.and.down.text.horizontal").foregroundColor(.black)
                    }
                    }
                    ToolbarItem(placement:.navigationBarLeading){
                        Button{
                            print("Information")
                            isPresenting.toggle()
                        } label: {
                            Image(systemName: "info.circle.fill").foregroundColor(.black)
                        }
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Menu{
                            Toggle("Show sub anagrams", isOn: $checkedState)
                        }
                    label:{
                        Label("Settings", systemImage: "gear").foregroundColor(.black)
                    }
                    }
                    
                }
            }
            
        }
    }
    
    func sortWordsAlpha(){viewModel.sortWords(sortType: 1)}
    func sortWordsReverseAlpha(){viewModel.sortWords(sortType: 2)}
    func sortWordsLengthAsc(){viewModel.sortWords(sortType: 3)}
    func sortWordsLengthDesc(){viewModel.sortWords(sortType: 4)}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 14")
        }
    }
}

func buttonPress(anagram: String,  using solveAnagram: (String) -> Void){
    solveAnagram(anagram)
}

struct WordCard: View {
    
    let word: String
    
    var body: some View{
    
        //let accentColor = Color(red: 62/255, green: 67/255, blue: 101/255)
        
        HStack{
            Text(word)
                .font(.system(size: 36))
                .fontWeight(Font.Weight.thin)
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 0))
                
            Spacer()
            Button{
                webSearchWord(word: word)
                print("Information")
            } label: {
                Image(systemName: "magnifyingglass").foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 16))
        }
        .background(AppColor.accent)
        .clipShape(Capsule())
        
        
    }
}

struct SortMenu: View{
    
    var body: some View{
        
        Menu("Sort"){
            Button("A - Z", action: sortWords)
            Button("Z - A", action: sortWords)
            Button("Length - Asc", action: sortWords)
            Button("Length - Desc", action: sortWords)
        }
    }
    
    
    func sortWords(){}
    
    
}

func webSearchWord(word: String){
    if let url = URL(string: "https://www.google.co.uk/search?q=\(word)"){
        UIApplication.shared.open(url)
    }
        
    
}






