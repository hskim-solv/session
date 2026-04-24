import SwiftUI

final class AppContainer: ObservableObject {
    let repository: SessionRepository
    let settingsStore: SettingsStore
    let timerViewModel: TimerViewModel
    let historyViewModel: HistoryViewModel
    let settingsViewModel: SettingsViewModel

    init(
        repository: SessionRepository = JSONFileSessionRepository(),
        settingsStore: SettingsStore = UserDefaultsSettingsStore()
    ) {
        self.repository = repository
        self.settingsStore = settingsStore
        self.timerViewModel = TimerViewModel(engine: TimerEngine(), repository: repository)
        self.historyViewModel = HistoryViewModel(repository: repository)
        self.settingsViewModel = SettingsViewModel(store: settingsStore)

        self.timerViewModel.apply(settings: settingsViewModelCurrentSettings())
        self.timerViewModel.onSessionSaved = { [weak historyViewModel] in
            historyViewModel?.loadToday()
        }
        self.settingsViewModel.onSaved = { [weak timerViewModel] settings in
            timerViewModel?.apply(settings: settings)
        }
    }

    private func settingsViewModelCurrentSettings() -> PomodoroSettings {
        PomodoroSettings(
            focusMinutes: settingsViewModel.focusMinutes,
            shortBreakMinutes: settingsViewModel.shortBreakMinutes,
            longBreakMinutes: settingsViewModel.longBreakMinutes
        )
    }
}

struct PomodoroSampleRootView: View {
    @StateObject private var container = AppContainer()

    var body: some View {
        TabView {
            TimerView(viewModel: container.timerViewModel)
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }

            HistoryView(viewModel: container.historyViewModel)
                .tabItem {
                    Label("기록", systemImage: "list.bullet")
                }

            SettingsView(viewModel: container.settingsViewModel)
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                }
        }
    }
}
