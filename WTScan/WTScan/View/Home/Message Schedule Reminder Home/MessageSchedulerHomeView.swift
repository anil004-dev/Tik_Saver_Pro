//
//  MessageSchedulerHomeView.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import SwiftUI

struct MessageSchedulerHomeView: View {
    
    @StateObject var viewModel = MessageSchedulerHomeViewModel()
    @EnvironmentObject var alertManager: WTAlertManager
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    schedulerReminderSection
                }
                //.background(Color.lightGreenBg)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .onTapGesture {
                    Utility.hideKeyboard()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, 10)
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(15)
                        .frame(width: 55, height: 55)
                        .background(AppColor.Pink)
                        .clipShape(Circle())
                        .onTapGesture {
                            viewModel.btnCreateReminderAction()
                        }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)

                BannerAdContentView()
            }
            
            WTToastView()
                .zIndex(9999)
        }
        .navigationTitle("Scheduled Reminders")
        .onAppear {
            ReminderdManager.shared.context = context
            viewModel.onAppear()
        }
    }
    
    private var schedulerReminderSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    WTText(title: "⏰ Scheduled Reminders", color: .white, font: .system(size: 18, weight: .bold, design: .default), alignment: .leading)
                    
                    WTText(title: "Your upcoming message reminders", color: .white, font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                }
                .padding(.horizontal, 16)
              
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        if viewModel.arrReminders.isEmpty {
                            ContentUnavailableView("No Reminders", image: "", description: Text("You have no pending reminders. Add a reminder to stay on track."))
                                .preferredColorScheme(.dark)
                        } else {
                            ScrollView(.vertical) {
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(viewModel.arrReminders, id: \.id) { reminder in
                                        reminderRow(reminder: reminder)
                                    }
                                    
                                    VStack{}.frame(height: 50)
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                    .padding(16)
                }
                .background(AppColor.Gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, paddingFromBannerAd())
    }
}

extension MessageSchedulerHomeView {
    
    @ViewBuilder
    private func reminderRow(reminder: WTMessageReminder) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                WTText(title: reminder.messageText, color: .white, font: .system(size: 21, weight: .semibold, design: .default), alignment: .leading)
                
                WTText(title: Utility.formatteDate(date: reminder.scheduleDate, formate: "MMMM d, yyyy 'at' h:mm a"), color: .white, font: .system(size: 17, weight: .light, design: .default), alignment: .leading)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.Gray.opacity(0.12))
                .stroke(Color.lightBorderGrey, lineWidth: 1)
                .padding(1)
                .frame(maxHeight: .infinity)
        }
    }
}
