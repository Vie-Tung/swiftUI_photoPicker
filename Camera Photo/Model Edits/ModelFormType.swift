//
//  ModelFormType.swift
//  Camera Photo
//
//  Created by Tung Viet on 29/08/2024.
//

import Foundation
import SwiftUI

enum ModelFormType: Identifiable, View {
    case new
    case update(SampleModel)
    var id: String {
        String(describing: self)
    }
    
    var body: some View {
        switch self {
        case .new:
            UpdateEditFormView(vm: UpdateEditFormViewModel())
        case .update(let sample):
            UpdateEditFormView(vm: UpdateEditFormViewModel(sample: sample))
        }
    }
}
