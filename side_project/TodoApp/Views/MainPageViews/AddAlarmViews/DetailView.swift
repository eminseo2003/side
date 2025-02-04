import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var priority: Priority
    @Binding var dateEnabled: Bool
    @Binding var date: Date?
    @Binding var timeEnabled: Bool
    @Binding var time: Date?
    @Binding var daterepeatEnabled: Bool
    @Binding var daterepeat: RepeatFrequency
    @Binding var repeatendEnabled: Bool
    @Binding var repeatend: Date?
    @Binding var locationEnabled: Bool
    @Binding var location: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        iconBox(systemImage: "calendar", backgroundColor: .red)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Toggle("날짜", isOn: $dateEnabled)
                            
                            
                            if dateEnabled {
                                Text(date == nil ? "오늘" : formattedDate(date!))
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                                    .padding(.top, -5)
                            }
                        }
                        .padding(.leading, 10)
                    }
                    
                    if dateEnabled {
                        DatePicker("", selection: Binding(get: {
                            date ?? Date()
                        }, set: { date = $0 }),
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(-10)
                        .labelsHidden()
                    }
                    HStack {
                        iconBox(systemImage: "clock.fill", backgroundColor: .blue)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Toggle("시간", isOn: $timeEnabled)
                            
                            
                            if timeEnabled {
                                Text(formattedTime(time ?? Date()))
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                                    .padding(.top, -5)
                            }
                        }
                        .padding(.leading, 10)
                    }
                    
                    if timeEnabled {
                        DatePicker("", selection: Binding(get: {
                            time ?? Date()
                        }, set: { time = $0 }),
                                   displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .padding(-10)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko_KR")) //gpt 사용
                    }
                    
                }
                Section {
                    
                    if dateEnabled {
                        NavigationLink(destination: RepeatView(
                            
                            daterepeatEnabled: $daterepeatEnabled,
                            daterepeat: $daterepeat
                            
                        )) {
                            HStack {
                                iconBox(systemImage: "repeat", backgroundColor: .gray)
                                Text("반복")
                                
                                Spacer()
                                
                                Text(daterepeat.rawValue)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        
                    }
                    if daterepeatEnabled {
                        NavigationLink(destination: RepeatEndView(
                            
                            repeatendEnabled: $repeatendEnabled,
                            repeatend: $repeatend
                            
                        )) {
                            HStack {
                                Text("반복 종료")
                                
                                Spacer()
                                
                                if !repeatendEnabled {
                                    Text("안 함")
                                        .foregroundColor(.gray)
                                } else {
                                    Text(repeatend != nil ? formattedDate2(repeatend!) : "날짜 선택 안 됨")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                    }
                }
                
                
                Section {
                    settingRow(
                        title: "위치",
                        systemImage: "location.fill",
                        backgroundColor: .blue,
                        toggleBinding: $locationEnabled
                    )
                    if locationEnabled {
                        TextField("위치 입력", text: Binding(get: {
                            location ?? ""
                        }, set: { location = $0 }))
                    }
                }
                Section {
                    Picker(
                        selection: $priority,
                        label: HStack {
                            Image(systemName: "exclamationmark.square.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.red)
                            Text("우선 순위")
                                .padding(.leading, 10)
                        }
                    ) {
                        //gpt 사용 - 열거형의 모든 케이스를 배열(Array) 형태로 가져오는 기능
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.title).tag(priority)
                        }
                    }
                    
                }
            }
            .navigationTitle("세부사항")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func iconBox(systemImage: String, backgroundColor: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 32, height: 32)
            Image(systemName: systemImage)
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
    }
    private func settingRow(title: String, systemImage: String, backgroundColor: Color, toggleBinding: Binding<Bool>) -> some View {
        HStack {
            iconBox(systemImage: systemImage, backgroundColor: backgroundColor)
            Toggle(title, isOn: toggleBinding)
                .padding(.leading, 10)
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 E요일"
        return formatter.string(from: date)
    }
    func formattedDate2(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. M. d. (E)"
        return formatter.string(from: date)
    }
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    
}
//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}
