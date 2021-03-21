//
//  ContentView.swift
//  Japanese-listening-pratice
//
//  Created by Victor Lau on 7/3/2021.
//

import SwiftUI
import AVFoundation

func openFile(wordList: wordlist) -> Void {
    wordList.list.removeAll()
    let dialog = NSOpenPanel()
    dialog.allowedFileTypes = ["txt"]
    dialog.allowsMultipleSelection = false
    dialog.canChooseDirectories = false
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        let url = dialog.url
        // print(url ?? "")
        if let unwrappedURL = url {
            let FS = FileManager()
            guard let data = FS.contents(atPath: unwrappedURL.path) else {return}
            guard let dataString = String(data: data, encoding: .utf8) else {
                return
            }
            let stringList = dataString.split(separator: "\n")
            for str in stringList {
                wordList.list.append(String(str))
            }
            wordList.list.shuffle()
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var wordList: wordlist
    var body: some View {
        if (wordList.list.isEmpty) {
            OpenFileView()
        }
        else {
            MainView()
        }
    }
}

struct OpenFileView: View {
    @EnvironmentObject var wordList: wordlist
    var body: some View {
        Button("Open File") {
            openFile(wordList: wordList)
        }
    }
}

struct MainView: View {
    @EnvironmentObject var wordList: wordlist
    @State var question: Int = 0
    @State private var answerVis = false
    @State private var answer: String = ""
    @State private var wrongAns = false
    @State private var mark: Int = 0
    @State private var endOfFile: Bool = false
    
    func playSound() {
        guard question < wordList.list.count else {return}
        let utt = AVSpeechUtterance(string: wordList.list[question])
        utt.voice = AVSpeechSynthesisVoice(language: "ja")
        utt.rate = 0.1
        let syn = AVSpeechSynthesizer()
        syn.speak(utt)
    }
    
    func checkAns() {
        if (answer != wordList.list[question]) {
            wrongAns = true
            answer = ""
        }
        else {
            if (!wrongAns && !answerVis) {
                mark += 1
            }
            wrongAns = false
            answerVis = false
            //question += 1
            answer = ""
            checkEndOfFile()
        }
    }
    
    func checkEndOfFile() {
        if (wordList.list.count <= question + 1) {
            endOfFile = true
        }
        else {
            question += 1
            playSound()
        }
    }
    
    func reset() {
        question = 0
        wrongAns = false
        mark = 0
        answerVis = false
        wordList.list.shuffle()
    }
    
    func checkWordType(str: String) -> String {
        guard let unwrappedFir: Character = str.first else {
            return "?"
        }
        let hiragana: Character = "あ"
        let katakana: Character = "ア"
        if (unwrappedFir >= hiragana && unwrappedFir < katakana){
            return "Hiragana"
        }
        else if (unwrappedFir >= katakana && unwrappedFir <= "ヺ") {
            return "Katakana"
        }
        else {
            return "?"
        }
        
    }
    
    var questionRow: some View {
        return VStack {
            Text(checkWordType(str: wordList.list[question]))
            Text(wordList.list[question]).opacity(answerVis ? 1 : 0).padding()
            HStack {
                Button("Listen", action: playSound)
                Button("Show Answer") {
                    answerVis = true
                }
            }
        }.alert(isPresented: $endOfFile, content: {
            Alert(title: Text("Reached end of file"), message: Text(""), primaryButton: Alert.Button.default( Text("Reset")) {
                reset()
            }, secondaryButton: Alert.Button.default(Text("Open New File")) {
                openFile(wordList: wordList)
            })
        })
    }
    
    var body: some View {
        VStack {
            //Text(wordList.list[question])
            questionRow
            Divider().padding()
            HStack {
                TextField("Answer", text: $answer,
                          onCommit: {
                            checkAns()
                          }
                    )
                    .border(Color.red, width: wrongAns ? 2 : 0)
                Button("Submit") {
                    checkAns()
                }
            }
            Divider().padding()
            HStack {
                Text("Score: " + String(mark) + "/" + String(question))
                /*Button("Open New File") {
                    reset()
                    openFile(wordList: wordList)
                }*/
            }
            
        }
        .padding()
    }
}

struct Menubar : Commands {
    var wordList: wordlist    
    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button("Open File") {
                
                openFile(wordList: wordList)
            }
        }
    }
}


struct ContentView_Previews:
    PreviewProvider {
    static var Preview_wordList = wordlist()
    static var previews: some View {
        MainView().frame(width: 300.0, height: 300.0).environmentObject(Preview_wordList)
    }
}

