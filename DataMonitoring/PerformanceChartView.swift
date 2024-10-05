import SwiftUI
import Charts

struct PerformanceChartView: View {
    var machines: [MachineData]
    
    var body: some View {
        Chart {
            ForEach(machines) { machine in
                LineMark(
                    x: .value("Máquina", machine.name),
                    y: .value("Pacotes", machine.packetsPerMinute)
                )
                .foregroundStyle(machine.status == "Rodando" ? .green : .red)
            }
        }
        .frame(height: 200)
        .padding()
    }
}