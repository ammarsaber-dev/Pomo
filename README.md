# Pomo 🍅

A minimal Pomodoro timer for iOS — built with SwiftUI and SwiftData.  
Focus on your work, track your sessions, and build better habits.

## Demo

https://github.com/user-attachments/assets/77a58273-77c2-43dd-a2dc-c5e334954331

## Overview

Pomo is a clean Pomodoro timer that helps you stay focused during work sessions. Start a timer, give it a task name, and get into flow. Completed sessions are saved locally so you can review your productivity over time.

## Features

- **Custom durations** — 1, 5, 25, 30, 45, or 60 minute focus sessions
- **Live progress ring** — circular countdown showing time remaining
- **Task naming** — label each session so you know what you worked on
- **Pause & Resume** — take breaks without losing your progress
- **Completion overlay** — on-screen "Session Complete" with green checkmark, tap to dismiss
- **Sound effects** — soft tick each second and a completion chime
- **Session history** — all completed sessions saved and viewable in a list
- **Clear all sessions** — wipe history with confirmation dialog
- **Light & Dark Mode** — adapts to system appearance automatically

## Built With

| Technology | Purpose |
|---|---|
| **SwiftUI** | All user interface — declarative views, navigation, animations |
| **SwiftData** | Local persistence — save and query completed sessions |
| **Foundation** | Timer for countdown, Date for timestamps |
| **AVFoundation** | Sound effects via AVAudioPlayer |

Zero external dependencies. Pure Apple SDKs.

## Getting Started

### Automatic
- Click `Code` button above, then choose `Open with Xcode`

### Manual
1. Clone the repository
2. Open `Pomo.xcodeproj` in Xcode
3. Select an iOS 26+ simulator or connected device
4. Press **Cmd+R** to build and run

## Architecture

Feature-based folder layout (MVVM):

```
Pomo/
├── App/
│   ├── PomoApp.swift         # @main entry, SwiftData container
│   └── ContentView.swift     # Root TabView (Timer + Sessions)
├── Features/
│   ├── Timer/
│   │   ├── TimerView.swift       # Progress ring, controls, picker
│   │   └── TimerViewModel.swift  # Countdown logic, session saving
│   └── Session/
│       ├── Session.swift         # SwiftData @Model
│       └── SessionsView.swift    # @Query list with swipe-to-delete
└── Resources/
    ├── clock-tick.mp3
    └── completed.mp3
```

### Key Patterns

- **MVVM** — `TimerView` (View) delegates all state and logic to `TimerViewModel` (ViewModel), an `@Observable` class (iOS 17+ macro); `Session` is the Model
- **SwiftData** — `@Model` objects, `@Query` for live updates, `modelContext` for writes
- **Foundation Timer** — 1-second repeating `Timer` drives countdown; no Combine or async/await overhead
- **AVAudioPlayer** — reusable instance for tick and completion sounds

## Status

Built as a learning project.
