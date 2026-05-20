# Pomo 🍅

A minimal Pomodoro timer for iOS — built with SwiftUI and SwiftData.  
Focus on your work, track your sessions, and build better habits.

## Demo

![](Pomo1080.mov)
## Overview

Pomo is a clean, no-fuss Pomodoro timer that helps you stay focused during work sessions. Start a timer, give it a task name, and get into flow. Completed sessions are saved locally so you can review your productivity over time.

## Features

- **Custom durations** — 5, 25, 30, 45, or 60 minute focus sessions
- **Live progress ring** — a circular countdown that shows time remaining at a glance
- **Task naming** — label each session so you know what you worked on
- **Pause & Resume** — take a break without losing your progress
- **Session history** — all completed sessions are saved and viewable in a list
- **Clear all sessions** — wipe history with a single tap
- **Light & Dark Mode** — adapts to your system appearance automatically

## Built With

| Technology | Purpose |
|---|---|
| **SwiftUI** | All user interface — declarative views, navigation, animations |
| **SwiftData** | Local persistence — save and query completed sessions |
| **Foundation** | Timer class for the countdown, Date for timestamps |

**Zero external dependencies.** Pure Apple SDKs.

## Getting Started

### Running the App

#### Automatic
- Click on `Code` button above, then choose `Open with Xcode`

#### Manual
1. Clone the repository:
   ```bash
   git clone https://github.com/ammarsaber-dev/Pomo.git
   ```
2. Open `Pomo.xcodeproj` in Xcode.
3. Select an iOS 26+ simulator or connected device.
4. Press **Cmd+R** to build and run.

## Architecture

The project follows a **feature-based** folder layout:

```
Pomo/
├── App/
│   ├── PomoApp.swift         # @main entry, SwiftData container setup
│   └── ContentView.swift     # Root TabView (Timer + Sessions tabs)
└── Features/
    ├── Timer/
    │   ├── TimerView.swift       # Progress ring, controls, duration picker
    │   └── TimerViewModel.swift  # Countdown logic, pause/resume, session saving
    └── Session/
        ├── Session.swift         # SwiftData @Model for completed sessions
        └── SessionsView.swift    # @Query-driven list with clear-all
```

### Key Patterns

- **ViewModel pattern** — `TimerViewModel` is an `@Observable` class that owns all timer state and logic, keeping the view focused on layout
- **SwiftData for persistence** — `Session` models are `@Model` objects, queried with `@Query` and written via `modelContext`
- **Foundation Timer** — a 1-second repeating `Timer` drives the countdown; no Combine or async/await overhead
- **No navigation framework** — a simple `TabView` switches between Timer and Sessions

### Data Flow

```
User taps "Start" → TimerViewModel.toggleTimer()
  → Foundation Timer fires every 1s → tick() decrements timerSeconds
  → Reaches 0 → stop() → saveSession() writes a Session via modelContext
  → Completion alert shown → timer resets to selected duration
```

## The Story Behind Pomo

I'm learning iOS development by building real apps. Pomo is my first SwiftUI project — a simple Pomodoro timer I built from scratch with the help of **Claude** (Anthropic's AI assistant).

The goal was straightforward: learn SwiftUI and SwiftData by making something useful. Every commit represents a new concept I was figuring out — the `@Observable` macro, how SwiftData models work, why `@Environment(\.modelContext)` matters, and how to structure a SwiftUI app without getting lost in abstraction.

It's not perfect, and that's the point. This is a learning artifact — something I can look back on as I build more complex apps and see how far I've come.

## Status

🟢 **Active development** — Built as a learning project. Features will evolve as I learn more.
