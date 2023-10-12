//
//  ContentView-ViewModel.swift
//  anagram-solver-ios
//
//  Created by Harry Witcomb on 26/08/2022.
//

import Foundation

extension StringProtocol{
    subscript(offset: Int) -> Character{
        self[index(startIndex, offsetBy: offset)]
    }
}

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        @Published private(set) var anagram : String = ""
        @Published private(set) var matches : Int = 0
        @Published private(set) var words: [String] = []
        
        private var wordsCap: Int = 1000
        
        /*
         This method reads in the dictionary and returns an array
         containing all the words which can be queried later
         */
        func readDictionary() -> [String]{
            var dictionaryWords = [String]()
            
            let file = "dictionary"
            
            if let path = Bundle.main.path(forResource: file, ofType: "txt"){
                do{
                    let data = try String(contentsOfFile: path, encoding: .utf8)
                    let myStrings = data.components(separatedBy: .newlines)
                    //let text = myStrings.joined(separator: "\n")
                    dictionaryWords = myStrings.filter{$0 != ""}
                    //print("\(text)")
                } catch{
                    print(error)
                }
            }
            return dictionaryWords
        }
        
        /*
         This function determines which type of anagram the user
         has entered and calls the corresponding method
         */
        func readAnagram(anagram: String, checkedState: Bool){
            let dictionaryWords = readDictionary()
            
            let tempCount = anagram.count
            
            var filteredDictionary = dictionaryWords.filter{word in
                return word.count <= tempCount
            }
            
            if checkedState {
                filteredDictionary = dictionaryWords.filter{word in
                    return word.count <= tempCount
                }
            }else{
                filteredDictionary = dictionaryWords.filter{word in
                    return word.count == tempCount
                }
            }
            
            
            
            
            let cleanedAnagram = anagram.lowercased()
            
            if anagram.contains("+"){
                clearList()
                solveAnagramMissing(anagram: cleanedAnagram, filteredDictionary: filteredDictionary)
                matches = words.count
            }else if anagram.contains("."){
                clearList()
                solveAnagramCrossword(anagram: cleanedAnagram, filteredDictionary: filteredDictionary)
                matches = words.count
            }else if checkedState{
                clearList()
                solveAnagramScrabble(anagram: cleanedAnagram, filteredDictionary: filteredDictionary)
                matches = words.count
            }
            else{
                clearList()
                solveAnagramComplete(anagram: cleanedAnagram, filteredDictionary: filteredDictionary)
                matches = words.count
            }
        }
        
        /*
         This method clears the list of solutions to a previously
         solved anagram so it can be repopulated with new results
         */
        func clearList(){
            words.removeAll()
        }
        
        /*
         This takes a complete anagram and fins the solutions to it
         */
        func solveAnagramComplete(anagram: String, filteredDictionary: [String]){
            for word in filteredDictionary{
                if hasCorrectLettersComplete(anagram: anagram, word: word){
                    if !words.contains(word) && words.count < wordsCap {
                        words.append(word)
                        print(word)
                    }
                }
            }
        }
        
        /*
         This takes an anagram where some letters are missing
         and finds all the possible solutions to it
         */
        func solveAnagramMissing(anagram: String, filteredDictionary: [String]){
            for word in filteredDictionary {
                if hasCorrectLettersMising(anagram: anagram, word: word){
                    if !words.contains(word) && words.count < wordsCap {
                        words.append(word)
                    }
                }
            }
        }
        
        
        /*
         This takes an anagram where some letters are missing but the letters
         present must appear in the samne position in the solution as in the anagram
         */
        func solveAnagramCrossword(anagram: String, filteredDictionary: [String]){
            for word in filteredDictionary{
                if hasCorrectLettersCrossword(anagram: anagram, word: word){
                    if !words.contains(word) && words.count < wordsCap{
                        words.append(word)
                    }
                }
            }
        }
        
        func solveAnagramScrabble(anagram: String, filteredDictionary: [String]){
            var wordFound = false
            
            for word in filteredDictionary{
                for letter in word{
                    if countLetterOccurances(string: word, char: letter) <= countLetterOccurances(string: anagram, char: letter){
                        wordFound = true
                    }else{
                        wordFound = false
                        break
                    }
                }
                if wordFound{
                    if !words.contains(word) && words.count < wordsCap{
                        words.append(word)
                    }
                }
            }
        }
        
        /*
         This method checks if a word has all the correct letters
         to be a solution to a comoplete anagram
         */
        func hasCorrectLettersComplete(anagram: String, word: String)-> Bool{
            var lettersFoundCount = 0
            
            for letter in anagram where countLetterOccurances(string: anagram, char: letter) == countLetterOccurances(string: word, char: letter){
                lettersFoundCount += 1
            }
            return lettersFoundCount == anagram.count
        }
        
        /*
         This mewthod checks if a word is a solution to an anagram
         where some of the letters are missing
         */
        func hasCorrectLettersMising(anagram: String, word: String) -> Bool{
            var wordFound = true
            
            for letter in anagram{
                if letter != "+"{
                    if !word.contains(letter){
                        wordFound = false
                        break
                    }
                }
            }
            
            return wordFound
        }
        
        /*
         This method checks if a word is a solution to an anagram
         where some letters are missing and the letters present must
         appear in the word at the same position as they do in the anagram
         */
        func hasCorrectLettersCrossword(anagram: String, word: String) -> Bool{
            var wordFound = true
            
            for i in 0...anagram.count - 1{
                if anagram[i] != "."{
                    if anagram[i] != word[i]{
                        wordFound = false
                        break
                    }
                }
            }
            
            return wordFound
        }
        
        /*
         This method counts the opccurrences of a given character in a given string
         */
        private func countLetterOccurances(string: String, char: Character) -> Int{
            return string.filter({ $0 == char}).count
        }
        
        /*
         This method checks if a word is the same length as the anagram
         */
        private func isCorrectLength(word: String, anagram: String) -> Bool{
            return word.count == anagram.count
        }
        
        
        
        func sortWords(sortType: Int){
            /*
             Sort types
             1 = Alphabetically
             2 = Reverse Alphabetically
             3 = Length Asc
             4 = Length Desc
             */
            switch sortType {
            case 1: words.sort()
            
            case 2: words = words.sorted().reversed()
                
            case 3: words.sort(by: {$0.count < $1.count})
                
            case 4: words = words.sorted(by: {$0.count < $1.count}).reversed()
                
            default: words.sort()
                
            }
        }
        
    }
    
    
}
