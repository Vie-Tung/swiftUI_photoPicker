//
//  UpdateEditFormView.swift
//  Camera Photo
//
//  Created by Tung Viet on 29/08/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateEditFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var vm: UpdateEditFormViewModel
    @State private var imagePicker = ImagePicker()
    @State private var showCamera: Bool = false
    @State private var cameraError: CameraPermission.CameraError?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $vm.name)
                VStack {
                    if vm.data != nil {
                        Button("Clear image") {
                            vm.clearImage()
                        }
                        .buttonStyle(.bordered)
                    }
                    HStack {
                        Button("Camera", systemImage: "camera") {
                            if let error = CameraPermission.checkPermissions() {
                                cameraError = error
                            } else {
                                showCamera.toggle()
                            }
                    
                        }
                        .alert(isPresented: .constant(cameraError != nil), error: cameraError) { _ in
                            Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "Try again later")
                        }
                        .sheet(isPresented: $showCamera) {
                            UIKitCamera(selectedImage: $vm.cameraImage)
                                .ignoresSafeArea()
                        }
                        
                        PhotosPicker(selection: $imagePicker.imageSelection) {
                            Label("Photo", systemImage: "photo")
                        }
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    Image(uiImage: vm.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
            }
            .onAppear {
                imagePicker.setup(vm)
            }
            .onChange(of: vm.cameraImage) {
                if let image = vm.cameraImage {
                    vm.data = image.jpegData(compressionQuality: 0.8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if vm.isUpdating {
                            if let sample = vm.sample {
                                if vm.image != Constants.placeholder {
                                    sample.data = vm.image.jpegData(compressionQuality: 0.8)
                                } else {
                                    sample.data = nil
                                }
                                sample.name = vm.name
                                dismiss()
                            }
                        } else {
                            let newSample = SampleModel(name: vm.name)
                            if vm.image != Constants.placeholder {
                                newSample.data = vm.image.jpegData(compressionQuality: 0.8)
                            }
                            modelContext.insert(newSample)
                            dismiss()
                        }
                    } label: {
                        Text(vm.isUpdating ? "Update" : "Add")
                    }
                    .disabled(vm.isDisabled)
                }
            }
        }
    }
}

#Preview {
    UpdateEditFormView(vm: UpdateEditFormViewModel())
}
