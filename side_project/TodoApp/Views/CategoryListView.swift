////
////  CategoryListView.swift
////  TodoApp
////
////  Created by Jungman Bae on 1/21/25.
////
//
//import SwiftUI
//import SwiftData
//
//// 카테고리 목록을 보여주고, 수정 및 삭제 기능을 제공하는 뷰
//struct CategoryListView: View {
//    // SwiftData의 모델 컨텍스트를 사용하여 데이터베이스 작업 수행
//    @Environment(\.modelContext) private var modelContext
//    // Category 객체 배열을 쿼리하여 가져옴
//    @Query private var categories: [Category]
//    
//    // 현재 선택된 카테고리
//    @State private var selectedCategory: Category?
//    @State private var isEditingCategory = false // 카테고리 이름을 편집 중인지 여부를 추적
//    @State private var editCategoryName: String = "" // 수정 중인 카테고리 이름을 저장
//    
//    var body: some View {
//        // 네비게이션 스택을 사용하여 뷰 내에서 탐색 가능
//        NavigationStack {
//            // 카테고리 목록을 보여주는 리스트
//            List {
//                // 각 카테고리 항목을 표시
//                ForEach(categories) { category in
//                    HStack {
//                        // 카테고리 이름을 텍스트로 표시 (기본값은 "-")
//                        Text(category.name ?? "-")
//                        Spacer()
//                    }
//                    // 카테고리 항목을 길게 누르면 편집 모드로 전환
//                    .onLongPressGesture {
//                        selectedCategory = category
//                        editCategoryName = category.name ?? "-"
//                        isEditingCategory = true
//                    }
//                    
//                }
//                // 삭제 동작을 처리
//                .onDelete(perform: deleteCategories)
//            }
//            // 네비게이션 바의 제목을 "Categories"로 설정
//            .navigationTitle("Categories")
//            // 카테고리 수정 알림 창
//            .alert("카테고리 수정",
//                   isPresented: $isEditingCategory
//            ) {
//                // 이름을 입력할 수 있는 텍스트 필드
//                TextField("카테고리 이름", text: $editCategoryName)
//                HStack {
//                    // 취소와 저장 버튼
//                    Button("취소") {
//                        editCategoryName = ""
//                    }
//                    Button("저장") {
//                        // 선택된 카테고리가 존재하고 이름이 비어 있지 않을 때만 저장
//                        if let category = selectedCategory, !editCategoryName.isEmpty {
//                            category.name = editCategoryName
//                            try? modelContext.save()
//                        }
//                    }
//                }
//            } message: {
//                Text("카테고리 이름을 입력하세요.")
//            }
//        }
//    }
//    // 카테고리를 삭제하는 함수
//    func deleteCategories(at offsets: IndexSet) {
//        for index in offsets {
//            let category = categories[index] // 삭제할 카테고리 가져오기
//            modelContext.delete(category) // 데이터베이스에서 삭제
//        }
//    }
//}
//
////#Preview {
////    CategoryListView()
////        .modelContainer(PreviewContainer.shared.container)
////}
