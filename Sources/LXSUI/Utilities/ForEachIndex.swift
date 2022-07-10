//
//  ForEachIndex.swift
//  LXSCommons
//
//  Created by Alex Rote on 7/9/22.
//

import SwiftUI

/// The ForEachIndex utility wraps around a ForEach structure, where the content is identified by index alone. This kind of structure is insufficient for elements that can modify their place in the array, which is typically tracked by identifiers instead. For constant arrays and for arrays that can only grow by appending, this utility can simplify the structure.
public struct ForEachIndex<Data, Content>: View where Data: RandomAccessCollection, Data.Index: Hashable, Content: View {
    
    /// The collection of underlying identified data that SwiftUI uses to create views dynamically.
    public let data: Data
    /// A function to create content on demand using the underlying data.
    public let content: (Data.Element) -> Content
    
    /// Initializes a new ForEachIndex view, using the input array and content creation function.
    public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        ForEach(data.indices, id: \.self) { idx in
            content(data[idx])
        }
    }
}

struct ForEachIndex_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ForEachIndex(["2", "3", "5", "8", "2", "2", "2"]) { value in
                Text(value)
            }
        }
    }
}
