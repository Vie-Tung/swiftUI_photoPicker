//
//  ContentView.swift
//  Camera Photo
//
//  Created by Tung Viet on 29/08/2024.
//

import SwiftUI
import SwiftData

struct PhotoListView: View {
    @Query(sort: \SampleModel.name) var samples: [SampleModel]
    @Environment(\.modelContext) private var modelContext
    @State private var formType: ModelFormType?
    
    var body: some View {
        
        NavigationStack {
            Group {
                if samples.isEmpty {
                    ContentUnavailableView("Add your first photo", image: "photo.artframe")
                } else {
                    List(samples) { sample in
                        NavigationLink(value: sample) {
                            HStack {
                                Image(uiImage: sample.image == nil ? Constants.placeholder: sample.image!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding()
                                Text(sample.name)
                                    .font(.title)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(sample)
                                try? modelContext.save()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(for: SampleModel.self) { sample in
                SampleView(sample: sample)
            }
            .navigationTitle("Picker or Camera")
            .toolbar {
                Button {
                    formType = .new
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(item: $formType) { $0
                }
            }
        }
    }
}

#Preview {
    PhotoListView()
        .modelContainer(SampleModel.preview)
}
