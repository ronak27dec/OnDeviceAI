//
//  ContentView.swift
//  OnDeviceAI
//
//  Created by Ronak Malick on 03/11/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var content: String = ""
    @State private var response: String = ""

    var body: some View {
        VStack {
            TextEditor(text: $content)
                .foregroundColor(Color.black)
                .font(.custom("HelveticaNeue", size: 16))
            Button("Summerize") {
                Task {
                    do {
                        response = try await summarize() ?? ""
                    } catch {
                        print(error)
                    }
                }
            }

            TextEditor(text: $response)
            let _ = print(response)
        }
        .padding()
    }

    private func summarize() async throws -> String? {
        if isIntellegenceAvailable() {
            let session = LanguageModelSession(instructions: """
                You are a text summarization assistant. 
                Generate concise, accurate summaries. 
                Preserve the important information. 
                """)

            let resp = try await session.respond(to: content)
            return resp.content
        }
        return nil
    }

    private func isIntellegenceAvailable() -> Bool {
        let model = SystemLanguageModel.default

        switch model.availability {
            case .available:
                print("Model is available")
                return true

            case .unavailable(.deviceNotEligible):
                print("Device not eligible")
                return false

            case .unavailable(.modelNotReady):
                print("Model not ready")
                return false

            case .unavailable(.appleIntelligenceNotEnabled):
                print("AI not enabled")
                return false

            default:
                return false
        }
    }
}

#Preview {
    ContentView()
}
