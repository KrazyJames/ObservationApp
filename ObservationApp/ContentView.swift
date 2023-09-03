//
//  ContentView.swift
//  ObservationApp
//
//  Created by Jaime Escobar on 19/08/23.
//

import SwiftUI

/// @Observable macro makes all properties observables
/// You dont need @Published property wrapper in all your properties
@Observable final class GlobalState {
    var presentAlert = false
}

@Observable final class AppState {
    var counter = 1
    var presentSheet = false
    var foregroundColor: Color {
        [Color.red, .yellow, .green].randomElement() ?? .pink
    }
    var height: CGFloat {
        presentSheet ? 2/3 : 1
    }
}

/// If no mutation is needed you dont use any property wrapper
/// Observable macro will mutate the state and redraw the view
struct DisplayerView: View {
    let appState: AppState
    var body: some View {
        Text(appState.counter, format: .number)
            .font(.title.bold())
            .foregroundStyle(appState.foregroundColor)
    }
}

/// Use @State for local state that will only mutate within the view
struct ContentView: View {
    @State private var appState = AppState()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                DisplayerView(appState: appState)
                Button("Present Incrementer") {
                    withAnimation {
                        appState.presentSheet.toggle()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * appState.height)
        }
        .padding()
        .sheet(isPresented: $appState.presentSheet) {
            IncrementerView(appState: appState)
                .presentationDetents([.fraction(1/3)])
                .interactiveDismissDisabled(true)
        }
    }
}

/// When you need to mutate the same state among views
/// Use @Bindable wrapper to bind between parent and child views
struct IncrementerView: View {
    @Bindable var appState: AppState
    var body: some View {
        VStack {
            Stepper("Counter: \(appState.counter)", value: $appState.counter)
            Button("Return") {
                withAnimation {
                    appState.presentSheet.toggle()
                }
            }
            AlertPresenterView()
        }
        .padding()

    }
}

/// When access to global state through the whole app
/// @Environment captures the Observable object sent from the parent
struct AlertPresenterView: View {
    @Environment(GlobalState.self) private var globalState
    var body: some View {
        Button("Present alert") {
            globalState.presentAlert.toggle()
        }
        .alert(
            "Global alert",
            isPresented: .init(
                get: {
                    globalState.presentAlert
                },
                set: { value in
                    globalState.presentAlert = value
                }
            )
        ) {
            Button("Ok") {
                globalState.presentAlert.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(GlobalState())
}
