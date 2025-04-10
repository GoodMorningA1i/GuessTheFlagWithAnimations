//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ali Syed on 2024-09-10.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var numQuetionsAnswered = 0
    let totalNumOfQuestions = 8
    @State private var gameComplete = false
    
    @State private var animationAmounts = [0.0, 0.0, 0.0]
    @State private var flagSelected: Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagSelected = number
                            flagTapped(number)
                            withAnimation {
                                animationAmounts[number] += 360
                            }
                        } label: {
                            FlagImage(countryName: countries[number])
                        }
                        .rotation3DEffect(Angle(degrees: animationAmounts[number]), axis: (x:0, y:1, z:0))
                        .opacity(setOpacity(number))
                        .scaleEffect(shrinkFlag(number))
                        .animation(.default, value: shrinkFlag(number))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()

                
                Text("Score: \(userScore)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert("Game Complete", isPresented: $gameComplete) {
            Button("Reset", action: reset)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
        }
        numQuetionsAnswered += 1
        showingScore = true
    }
    
    func askQuestion() {
        if numQuetionsAnswered == totalNumOfQuestions {
            gameComplete = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            flagSelected = nil
        }
    }
    
    func reset() {
        numQuetionsAnswered = 0
        userScore = 0
        
        askQuestion()
    }
    
    func setOpacity(_ number: Int) -> Double {
        guard flagSelected != nil else {
            return 1.0
        }
        return flagSelected != number ? 0.25 : 1.0
    }
    
    func shrinkFlag(_ number: Int) -> Double {
        guard flagSelected != nil else {
            return 1.0
        }
        return flagSelected != number ? 0.5 : 1.0
    }
}

#Preview {
    ContentView()
}
