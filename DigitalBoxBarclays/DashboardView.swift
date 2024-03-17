//
//  Dashboardview.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 17/03/24.
//

import SwiftUI
import Charts

struct Transaction: Identifiable {
    let id = UUID()
    let party: String
    let amount: Double
    let dt: Date
}

struct AccountData: Identifiable {
    let id = UUID()
    let name: String
    let balance: Double
    let transactions: [Transaction]
}

struct DashboardView: View {

    func generateRandomTransaction(withTrend trend: Double = 0.0) -> Transaction {
        let parties = ["Alice", "Bob", "Charlie", "David", "Eve", "Alice", "Alice", "Bob"]
        let randomParty = parties.randomElement()!
        let randomAmount = Double.random(in: -1000.0...1000.0) + trend
        let randomDate = Date(timeIntervalSinceNow: TimeInterval.random(in: -31536000.0...0.0)) // Within the last year
        return Transaction(party: randomParty, amount: randomAmount, dt: randomDate)
    }

    func generateAccountData(accountIndex: Int, trend: Double = 0.0) -> AccountData {
        let accountNames = ["Savings", "Current", "Business", "Credit Card"]
        let accountName = accountNames[accountIndex - 1]
        var transactions = [Transaction]()
        for i in 0..<120 {
            let transactionTrend = Double(i) * trend
            transactions.append(generateRandomTransaction(withTrend: transactionTrend))
        }
        transactions.sort { $0.dt < $1.dt }
        return AccountData(name: accountName, balance: transactions.reduce(0, { $0 + $1.amount }) + 80000, transactions: transactions)
    }

    var accounts = [AccountData]()
    
    init() {
        for i in 1...4 {
            let accountTrend = Double.random(in: -10.0...10.0)
            accounts.append(generateAccountData(accountIndex: i, trend: accountTrend))
        }
    }
    
    @State var selectedAccount = 0
    @State var numTransactions = 40
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Welcome Chinmay")
                    .bold()
                    .font(.title2)
                    .padding()
                Text("ACCOUNT")
                    .padding(.leading)
                    .font(.subheadline.smallCaps())
                    .foregroundColor(.secondary)
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(0 ..< accounts.count, id:\.self) { i in
                        Rectangle()
                            .fill(i == selectedAccount ? Color.accentColor : Color.clear)
                            .background(Material.regular)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(height: 75)
                            .overlay(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text(accounts[i].name)
                                        .font(.title3)
                                    Text("Balance: \(accounts[i].balance, specifier: "%.2f")")
                                        .font(.caption)
                                }
                                .padding(.horizontal)
                            }
                            .onTapGesture {
                                selectedAccount = i
                            }
                    }
                }
                .padding(.horizontal)
                Text("Transactions")
                    .padding(.leading)
                    .font(.subheadline.smallCaps())
                    .foregroundColor(.secondary)
                Picker("Transactions", selection: $numTransactions) {
                    ForEach([20, 40, 80, 120], id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                HStack {
                    GroupBox {
                        VStack {
                            SummaryView(
                                transactions: Array(accounts[selectedAccount].transactions[0 ..< numTransactions])
                            )
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 250)
                    }
                    GroupBox {
                        VStack {
                            Text("Your Spending Habits")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .bold()
                            PartyPieChartView(
                                transactions: Array(accounts[selectedAccount].transactions[0 ..< numTransactions])
                            )
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 250)
                    }
                    
                }
                
                .animation(.easeInOut, value: numTransactions)
                .padding()
            }
            .animation(.snappy(duration: 0.2), value: selectedAccount)
        }
    }
}

struct SummaryView: View {
    let transactions: [Transaction]
    var totalIncome: Double {
        transactions.filter { $0.amount > 0 }.reduce(0, { $0 + $1.amount })
    }
    var totalExpenditure: Double {
        transactions.filter { $0.amount < 0 }.reduce(0, { $0 + $1.amount })
    }
    var netChange: Double {
        transactions.reduce(0, { $0 + $1.amount })
    }
    
    var body: some View {
        VStack {
            Text("Total Income")
                .font(.caption)
            Text("\(totalIncome, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .foregroundColor(.green)

            Text("Total Expenditure")
                .font(.caption)
            Text("\(totalExpenditure, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .foregroundColor(.red)

            Text("Net Change")
                .font(.caption)
            Text("\(netChange, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .foregroundColor(netChange >= 0 ? .green : .red)
        }
        .padding(4)
    }
}

struct PartyPieChartView: View {
    let transactions: [Transaction]
    var partyAmountData: [(String, Double)] {
        var partyAmountData = [String : Double]()
        for transaction in transactions {
            if partyAmountData[transaction.party] == nil {
                partyAmountData[transaction.party] = 0
            }
            partyAmountData[transaction.party]! += transaction.amount.magnitude
        }
        return partyAmountData.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 })
    }
    var totalAmmount: Double {
        transactions.reduce(0, { $0 + $1.amount.magnitude })
    }
    
    func colorFor(party: String) -> Color {
        switch party {
        case "Alice": return .red
        case "Bob": return .blue
        case "Charlie": return .green
        case "David": return .yellow
        case "Eve": return .purple
        default: return .gray
        }
    }
    var body: some View {
        VStack {
            Chart(partyAmountData, id: \.0) { dataItem in
                if dataItem.1 > (totalAmmount / 72) {
                    SectorMark(
                        angle: .value("Type", dataItem.1 / totalAmmount),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                        
                    )
                    .foregroundStyle(by: .value("category", dataItem.0))
                        .cornerRadius(5)
                }
            }
        }
        
    }
}

#Preview {
    DashboardView()
}

public extension Color {
    static func random(randomOpacity: Bool = false) -> Color {
        Color(red: .random(in: 0...1),
              green: .random(in: 0...1),
              blue: .random(in: 0...1),
              opacity: randomOpacity ? .random(in: 0...1) : 1)
    }
}
