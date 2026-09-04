import SwiftUI

struct Catagory: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("Categories")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 12) {

                    Text("🎓 Study")
                        .font(.title2)
                        .bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {

                            // Timetable
                            Button {
                                print("Timetable clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📅")
                                        .font(.title)

                                    Text("Timetable")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Flashcards
                            Button {
                                print("Flashcards clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🃏")
                                        .font(.title)

                                    Text("Flashcards")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Assignments
                            Button {
                                print("Assignments clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📝")
                                        .font(.title)

                                    Text("Assignments")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Exams
                            Button {
                                print("Exams clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🎓")
                                        .font(.title)

                                    Text("Exams")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {

                    Text("💼 Work")
                        .font(.title2)
                        .bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {

                            // Meetings
                            Button {
                                print("Meetings clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📅")
                                        .font(.title)

                                    Text("Meetings")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Tasks
                            Button {
                                print("Tasks clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("✅")
                                        .font(.title)

                                    Text("Tasks")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Deadlines
                            Button {
                                print("Deadlines clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("⏰")
                                        .font(.title)

                                    Text("Deadlines")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {

                    Text("🏥 Health")
                        .font(.title2)
                        .bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {

                            // Appointments
                            Button {
                                print("Appointments clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📅")
                                        .font(.title)

                                    Text("Appointments")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Medicine
                            Button {
                                print("Medicine clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("💊")
                                        .font(.title)

                                    Text("Medicine")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Reports
                            Button {
                                print("Reports clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🧪")
                                        .font(.title)

                                    Text("Reports")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Checkups
                            Button {
                                print("Checkups clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🩺")
                                        .font(.title)

                                    Text("Checkups")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {

                    Text("💰 Finance")
                        .font(.title2)
                        .bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {

                            // Bills
                            Button {
                                print("Bills clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🧾")
                                        .font(.title)

                                    Text("Bills")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Payments
                            Button {
                                print("Payments clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("💳")
                                        .font(.title)

                                    Text("Payments")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // IPO
                            Button {
                                print("IPO clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("🏦")
                                        .font(.title)

                                    Text("IPO")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Stocks
                            Button {
                                print("Stocks clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📈")
                                        .font(.title)

                                    Text("Stocks")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            // Portfolio
                            Button {
                                print("Portfolio clicked")
                            } label: {
                                VStack(spacing: 8) {
                                    Text("📊")
                                        .font(.title)

                                    Text("Portfolio")
                                        .font(.headline)
                                }
                                .frame(width: 115, height: 90)
                                .background(.gray.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
