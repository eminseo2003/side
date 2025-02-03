//import SwiftUI
//
//struct TodoInfoView: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    @Binding var todo: TodoItem
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("할 일 정보")) {
//                    TextField("제목", text: $todo.title)
//                    TextField("메모", text: $todo.memo)
//                }
//                
//                Section(header: Text("우선순위")) {
//                    Picker("우선순위", selection: $todo.priority) {
//                        Text("낮음").tag(Priority.low)
//                        Text("보통").tag(Priority.medium)
//                        Text("높음").tag(Priority.high)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//                
//                Section(header: Text("날짜 및 시간")) {
//                    Toggle("날짜 설정", isOn: $todo.dateEnabled)
//                    if $todo.dateEnabled {
//                        DatePicker("날짜", selection: Binding($todo.date, default: Date()), displayedComponents: .date)
//                    }
//
//                    Toggle("시간 설정", isOn: $todo.timeEnabled)
//                    if $todo.timeEnabled {
//                        DatePicker("시간", selection: Binding($todo.time, default: Date()), displayedComponents: .hourAndMinute)
//                    }
//                }
//
//                
//                Section(header: Text("반복 설정")) {
//                    Toggle("반복 설정", isOn: $todo.daterepeatEnabled)
//                    if $todo.daterepeatEnabled {
//                        Picker("반복 주기", selection: $todo.daterepeat) {
//                            Text("없음").tag(RepeatFrequency.none)
//                            Text("매일").tag(RepeatFrequency.daily)
//                            Text("매주").tag(RepeatFrequency.weekly)
//                            Text("매월").tag(RepeatFrequency.monthly)
//                        }
//                    }
//                    Toggle("반복 종료", isOn: $todo.repeatendEnabled)
//                    if $todo.repeatendEnabled {
//                        DatePicker("반복 종료일", selection: Binding($todo.repeatend, default: Date()), displayedComponents: .date)
//                    }
//                }
//                
//                Section(header: Text("위치 설정")) {
//                    Toggle("위치 설정", isOn: $todo.locationEnabled)
//                    if $todo.locationEnabled {
//                        TextField("위치", text: Binding($todo.location, default: ""))
//                    }
//                }
//            }
//            .navigationTitle("할 일 수정")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("취소") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("저장") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension Binding {
//    init(_ source: Binding<Value?>, default defaultValue: Value) {
//        self.init(
//            get: { source.wrappedValue ?? defaultValue },
//            set: { source.wrappedValue = $0 }
//        )
//    }
//}
//
