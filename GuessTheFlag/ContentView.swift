//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Theo Luciano on 10/14/24.
//

import SwiftUI

struct FlagImageView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var chosenAnswer = -1
    @State private var userScore = 0
    @State private var currentRound = 1
    
    @State private var showingScore = false
    @State private var gameIsComplete = false
    
    @State private var scoreTitle = ""
    @State private var incorrectMessage = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.7, green: 0.6, blue: 0.9), location: 0.3),
                .init(color: Color(red: 0.9, green: 0.8, blue: 0.4), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text("Round \(currentRound) of 8")
                    .font(.callout)
                    .foregroundStyle(.white)
                    
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            chosenAnswer = number
                            flagTapped(number)
                        } label: {
                            FlagImageView(imageName: countries[number])
                                .rotation3DEffect(
                                    .degrees(chosenAnswer == number ? 180 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(chosenAnswer != number && chosenAnswer != -1 ? 0.4 : 1)
                                .saturation(chosenAnswer != number && chosenAnswer != -1 ? 0.2 : 1)
                                .animation(.bouncy, value: chosenAnswer)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.secondary)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore).\(incorrectMessage)")
        }
        
        .alert("Game over", isPresented: $gameIsComplete) {
            Button("Play again", action: askQuestion)
        } message: {
            Text("You got \(userScore) out of 8 correct.")
        }
    }
    
    func flagTapped(_ number: Int) {
        if currentRound == 8 {
            if number == correctAnswer {
                incorrectMessage = ""
                userScore += 1
            }
            
            gameIsComplete = true
            
        } else if number == correctAnswer {
            scoreTitle = "Correct!"
            incorrectMessage = ""
            userScore += 1
            showingScore = true
            
        } else {
            scoreTitle = "Oops, that's not right!"
            incorrectMessage = "\n \n You chose the flag for \(countries[number])"
            showingScore = true
        }
    }
    
    func askQuestion() {
        if gameIsComplete == true {
            userScore = 0
            currentRound = 0
            gameIsComplete = false
        }
        
        currentRound += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        chosenAnswer = -1
    }
}

#Preview {
    ContentView()
}
