//
//  BarChart.swift
//  Progress
//
//  Created by Andreas Hörberg on 2019-09-13.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import SwiftUI

public struct BarChart: View  {
    
    private var verticalMax: Int = 0
    private var bars: [Bar] = []
    private var verticalRange: Range<Int> { 0..<verticalMax }
    private var barRange: Range<Int> { 0..<bars.count }
    private var barUnit: CGFloat {
        return CGFloat(1) / CGFloat(verticalRange.upperBound)
    }
    private var withShadow = false
    
    @State private var animatableBarUnit: CGFloat = 0.0
    
    public func bar(color: Color?, scale: Int) -> some View {
        return Rectangle()
            .fill(color ?? .white)
            .scaleEffect(x: 1, y: self.animatableBarUnit*CGFloat(scale), anchor: .bottom)
            .shadow(radius: self.withShadow ? 10 : 0)
            .onAppear {
                withAnimation(.spring()) {
                    self.animatableBarUnit = self.barUnit
                }
        }
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(alignment: .bottom) {
                VStack {
                    ForEach(self.verticalRange) { index in
                        self.axisLabel(for: index)
                    }
                }
                
                HStack {
                    ForEach(self.barRange) { index in
                        ZStack {
                            if self.bars[index].goal != nil {
                                self.bar(color: Color.yellow.opacity(0.5), scale: self.bars[index].goal!)
                            }
                            self.bar(color: self.isGoalFulfilled(index) ? Color.green : Color.yellow, scale: self.bars[index].value)
                        }
                    }
                }
            }
            
            HStack {
                ForEach(self.barRange) { index in
                    Spacer()
                    Text(self.bars[index].label ?? "")
                    if index == self.barRange.upperBound {
                        Spacer()
                    }
                }
            }
            .offset(x: 0, y: 24)
        }
        
    }

    private func isGoalFulfilled(_ index: Int) -> Bool {
        self.bars[index].value >= self.bars[index].goal ?? 0
    }
    
    public func verticalRange(_ value: Int) -> Self {
        var copy = self
        copy.verticalMax = value
        return copy
    }
    
    public func bars(_ value: [Bar]) -> Self {
        var copy = self
        copy.bars = value
        return copy
    }
    
    public func shadow() -> Self {
        var copy = self
        copy.withShadow = true
        return copy
    }
    
    private func axisLabel(for index: Int) -> AxisLabel {
        AxisLabel(labelValue: "\(self.verticalRange[self.verticalRange.endIndex-index-1])")
    }
}

public struct Bar {
    public var value: Int
    public var goal: Int?
    public var label: String?

    public init(value: Int, goal: Int?, label: String?) {
        self.value = value
        self.goal = goal
        self.label = label
    }
}

public struct AxisLabel: View, Identifiable, Hashable {
    public let id = UUID()
    public let labelValue: String
    
    public var body: some View {
        Text(labelValue)
    }

    public init(labelValue: String) {
        self.labelValue = labelValue
    }
}

public struct BarChart_Previews: PreviewProvider {
    public static var previews: some View {
        BarChart()
    }
}
