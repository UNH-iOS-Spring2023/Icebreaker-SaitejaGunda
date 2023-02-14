//
//  ContentView.swift
//  Icebreaker-swiftui
//
//  Created by Saiteja Gunda on 1/31/23.
//

import SwiftUI
import FirebaseFirestore


struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtQuestion: String = ""
    @State var txtAnswer: String = ""
    
    @State var questions = [Question]()
    
    var body: some View {
        VStack{
            Text("Icebreaker")
                .font(.system(size: 40))
                .bold()
            
            Text("By Saiteja Gunda")
                .padding(.bottom)
                
            
            TextField("First Name", text: $txtFirstName)
            
            TextField("Last Name", text: $txtLastName)
            
            TextField("Pref Name", text: $txtPrefName)
            
            Button(action: setQuestion){
                Text("Get Question")
                    .padding(5)
                
            }
            
            Text(txtQuestion)
            
            TextField("Answer", text: $txtAnswer)
            
            Button(action: sendAnswerToFirebase){
                Text("Submit")
                    .padding(5)
                
            }
            
        }
        .multilineTextAlignment(.center)
        .disableAutocorrection(true)
        .onAppear(){
            // Execute this code
            getQuestionsFromFirebase() // Fetch questions from database
        }
        
            
    }
    
    func getQuestionsFromFirebase(){ // Fetches questions from firebase
        db.collection("questions")
            .getDocuments() { (querySnapshot,err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("Document ID Fetched: \(document.documentID)")
                        print("\(document.data())")
                        let question = Question(id: document.documentID, data: document.data())
                        
                        self.questions.append(question!)
                    }
                    
                }
                
                
            }
    }
    
    func setQuestion(){ // Randomly pick a question from my questions array
        txtQuestion = questions.randomElement()!.text
        // Track previous question so next question is different
        
    }
    
    func sendAnswerToFirebase(){
        let data = ["FirstName": txtFirstName,
                    "LastName": txtLastName,
                    "PrefName": txtPrefName,
                    "Question": txtQuestion,
                    "Answer": txtAnswer,
                    "course": "ios-spring-2023"]
        as [String: Any]
        var ref: DocumentReference? = nil
        ref = db.collection("students")
            .addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
                
            }
        
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtQuestion = ""
        txtAnswer = ""
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
