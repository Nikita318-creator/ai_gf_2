import Foundation

struct StoryOption {
    let text: String
    let nextPageIndex: Int
}

struct StoryPage {
    let imageName: String
    let narrationText: String
    let questionText: String
    let options: [StoryOption]
}

struct Storyline {
    let title: String
    let pages: [StoryPage]
}

class StorylineViewModel {
    
    var stories: [Storyline] = []
    
    var testAImageNames = [
        "storyline1_2",
        "storyline2_1",
        "storyline3_1",
    ]
    
    init() {
        setupStories()
    }
    
    private func setupStories() {
        // --- ИСТОРИЯ 1: THE MAID'S SECRET ---
        let maidPages: [StoryPage] = [
            // 0: Вход
            StoryPage(imageName: "storyline1_1", narrationText: "S1.P0.N".localize(), questionText: "S1.P0.Q".localize(), options: [
                StoryOption(text: "S1.P0.O1".localize(), nextPageIndex: 1),
                StoryOption(text: "S1.P0.O2".localize(), nextPageIndex: 2)
            ]),
            // 1 & 2: Разветвление
            StoryPage(imageName: "storyline1_2", narrationText: "S1.P1.N".localize(), questionText: "S1.P1.Q".localize(), options: [
                StoryOption(text: "S1.P1.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S1.P1.O2".localize(), nextPageIndex: 4)
            ]),
            StoryPage(imageName: "storyline1_2", narrationText: "S1.P2.N".localize(), questionText: "S1.P2.Q".localize(), options: [
                StoryOption(text: "S1.P2.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S1.P2.O2".localize(), nextPageIndex: 4)
            ]),
            // 3 & 4: Схождение
            StoryPage(imageName: "storyline1_3", narrationText: "S1.P3.N".localize(), questionText: "S1.P3.Q".localize(), options: [
                StoryOption(text: "S1.P3.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S1.P3.O2".localize(), nextPageIndex: 6)
            ]),
            StoryPage(imageName: "storyline1_3", narrationText: "S1.P4.N".localize(), questionText: "S1.P4.Q".localize(), options: [
                StoryOption(text: "S1.P4.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S1.P4.O2".localize(), nextPageIndex: 6)
            ]),
            // 5 & 6: Развитие
            StoryPage(imageName: "storyline1_4", narrationText: "S1.P5.N".localize(), questionText: "S1.P5.Q".localize(), options: [
                StoryOption(text: "S1.P5.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S1.P5.O2".localize(), nextPageIndex: 8)
            ]),
            StoryPage(imageName: "storyline1_4", narrationText: "S1.P6.N".localize(), questionText: "S1.P6.Q".localize(), options: [
                StoryOption(text: "S1.P6.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S1.P6.O2".localize(), nextPageIndex: 8)
            ]),
            // 7 & 8: Схождение
            StoryPage(imageName: "storyline1_5", narrationText: "S1.P7.N".localize(), questionText: "S1.P7.Q".localize(), options: [
                StoryOption(text: "S1.P7.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S1.P7.O2".localize(), nextPageIndex: 10)
            ]),
            StoryPage(imageName: "storyline1_5", narrationText: "S1.P8.N".localize(), questionText: "S1.P8.Q".localize(), options: [
                StoryOption(text: "S1.P8.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S1.P8.O2".localize(), nextPageIndex: 10)
            ]),
            // 9 & 10: Поиск улик
            StoryPage(imageName: "storyline1_6", narrationText: "S1.P9.N".localize(), questionText: "S1.P9.Q".localize(), options: [
                StoryOption(text: "S1.P9.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S1.P9.O2".localize(), nextPageIndex: 12)
            ]),
            StoryPage(imageName: "storyline1_6", narrationText: "S1.P10.N".localize(), questionText: "S1.P10.Q".localize(), options: [
                StoryOption(text: "S1.P10.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S1.P10.O2".localize(), nextPageIndex: 12)
            ]),
            // 11 & 12: Напряжение
            StoryPage(imageName: "storyline1_7", narrationText: "S1.P11.N".localize(), questionText: "S1.P11.Q".localize(), options: [
                StoryOption(text: "S1.P11.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S1.P11.O2".localize(), nextPageIndex: 14)
            ]),
            StoryPage(imageName: "storyline1_7", narrationText: "S1.P12.N".localize(), questionText: "S1.P12.Q".localize(), options: [
                StoryOption(text: "S1.P12.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S1.P12.O2".localize(), nextPageIndex: 14)
            ]),
            // 13 & 14: В шкафу
            StoryPage(imageName: "storyline1_8", narrationText: "S1.P13.N".localize(), questionText: "S1.P13.Q".localize(), options: [
                StoryOption(text: "S1.P13.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S1.P13.O2".localize(), nextPageIndex: 16)
            ]),
            StoryPage(imageName: "storyline1_8", narrationText: "S1.P14.N".localize(), questionText: "S1.P14.Q".localize(), options: [
                StoryOption(text: "S1.P14.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S1.P14.O2".localize(), nextPageIndex: 16)
            ]),
            // 15 & 16: Откровенность
            StoryPage(imageName: "storyline1_9", narrationText: "S1.P15.N".localize(), questionText: "S1.P15.Q".localize(), options: [
                StoryOption(text: "S1.P15.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S1.P15.O2".localize(), nextPageIndex: 18)
            ]),
            StoryPage(imageName: "storyline1_9", narrationText: "S1.P16.N".localize(), questionText: "S1.P16.Q".localize(), options: [
                StoryOption(text: "S1.P16.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S1.P16.O2".localize(), nextPageIndex: 18)
            ]),
            // 17 & 18: Кульминация
            StoryPage(imageName: "storyline1_10", narrationText: "S1.P17.N".localize(), questionText: "S1.P17.Q".localize(), options: [
                StoryOption(text: "S1.P17.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S1.P17.O2".localize(), nextPageIndex: 20)
            ]),
            StoryPage(imageName: "storyline1_10", narrationText: "S1.P18.N".localize(), questionText: "S1.P18.Q".localize(), options: [
                StoryOption(text: "S1.P18.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S1.P18.O2".localize(), nextPageIndex: 20)
            ]),
            // 19 & 20: Препятствие
            StoryPage(imageName: "storyline1_11", narrationText: "S1.P19.N".localize(), questionText: "S1.P19.Q".localize(), options: [
                StoryOption(text: "S1.P19.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S1.P19.O2".localize(), nextPageIndex: 22)
            ]),
            StoryPage(imageName: "storyline1_11", narrationText: "S1.P20.N".localize(), questionText: "S1.P20.Q".localize(), options: [
                StoryOption(text: "S1.P20.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S1.P20.O2".localize(), nextPageIndex: 22)
            ]),
            // 21 & 22: Подготовка к финалу
            StoryPage(imageName: "storyline1_12", narrationText: "S1.P21.N".localize(), questionText: "S1.P21.Q".localize(), options: [
                StoryOption(text: "S1.P21.O1".localize(), nextPageIndex: 23),
                StoryOption(text: "S1.P21.O2".localize(), nextPageIndex: 23)
            ]),
            StoryPage(imageName: "storyline1_12", narrationText: "S1.P22.N".localize(), questionText: "S1.P22.Q".localize(), options: [
                StoryOption(text: "S1.P22.O1".localize(), nextPageIndex: 24),
                StoryOption(text: "S1.P22.O2".localize(), nextPageIndex: 24)
            ]),
            // 23: Финал 1
            StoryPage(imageName: "storyline1_13", narrationText: "S1.P23.N".localize(), questionText: "S1.P23.Q".localize(), options: [
                StoryOption(text: "S1.P23.O1".localize(), nextPageIndex: 0),
                StoryOption(text: "S1.P23.O2".localize(), nextPageIndex: -1)
            ]),
            // 24: Финал 2
            StoryPage(imageName: "storyline1_13", narrationText: "S1.P24.N".localize(), questionText: "S1.P24.Q".localize(), options: [
                StoryOption(text: "S1.P24.O1".localize(), nextPageIndex: 0),
                StoryOption(text: "S1.P24.O2".localize(), nextPageIndex: -1)
            ])
        ]

        let tokyoPages: [StoryPage] = [
            /* 0 */ StoryPage(imageName: "storyline2_1", narrationText: "S2.P0.N".localize(), questionText: "S2.P0.Q".localize(), options: [
                StoryOption(text: "S2.P0.O1".localize(), nextPageIndex: 1),
                StoryOption(text: "S2.P0.O2".localize(), nextPageIndex: 2)
            ]),
            /* 1 */ StoryPage(imageName: "storyline2_2", narrationText: "S2.P1.N".localize(), questionText: "S2.P1.Q".localize(), options: [
                StoryOption(text: "S2.P1.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S2.P1.O2".localize(), nextPageIndex: 4)
            ]),
            /* 2 */ StoryPage(imageName: "storyline2_2", narrationText: "S2.P2.N".localize(), questionText: "S2.P2.Q".localize(), options: [
                StoryOption(text: "S2.P2.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S2.P2.O2".localize(), nextPageIndex: 4)
            ]),
            /* 3 */ StoryPage(imageName: "storyline2_3", narrationText: "S2.P3.N".localize(), questionText: "S2.P3.Q".localize(), options: [
                StoryOption(text: "S2.P3.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S2.P3.O2".localize(), nextPageIndex: 6)
            ]),
            /* 4 */ StoryPage(imageName: "storyline2_3", narrationText: "S2.P4.N".localize(), questionText: "S2.P4.Q".localize(), options: [
                StoryOption(text: "S2.P4.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S2.P4.O2".localize(), nextPageIndex: 6)
            ]),
            /* 5 */ StoryPage(imageName: "storyline2_4", narrationText: "S2.P5.N".localize(), questionText: "S2.P5.Q".localize(), options: [
                StoryOption(text: "S2.P5.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S2.P5.O2".localize(), nextPageIndex: 8)
            ]),
            /* 6 */ StoryPage(imageName: "storyline2_4", narrationText: "S2.P6.N".localize(), questionText: "S2.P6.Q".localize(), options: [
                StoryOption(text: "S2.P6.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S2.P6.O2".localize(), nextPageIndex: 8)
            ]),
            /* 7 */ StoryPage(imageName: "storyline2_5", narrationText: "S2.P7.N".localize(), questionText: "S2.P7.Q".localize(), options: [
                StoryOption(text: "S2.P7.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S2.P7.O2".localize(), nextPageIndex: 10)
            ]),
            /* 8 */ StoryPage(imageName: "storyline2_5", narrationText: "S2.P8.N".localize(), questionText: "S2.P8.Q".localize(), options: [
                StoryOption(text: "S2.P8.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S2.P8.O2".localize(), nextPageIndex: 10)
            ]),
            /* 9 */ StoryPage(imageName: "storyline2_6", narrationText: "S2.P9.N".localize(), questionText: "S2.P9.Q".localize(), options: [
                StoryOption(text: "S2.P9.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S2.P9.O2".localize(), nextPageIndex: 12)
            ]),
            /* 10 */ StoryPage(imageName: "storyline2_6", narrationText: "S2.P10.N".localize(), questionText: "S2.P10.Q".localize(), options: [
                StoryOption(text: "S2.P10.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S2.P10.O2".localize(), nextPageIndex: 12)
            ]),
            /* 11 */ StoryPage(imageName: "storyline2_7", narrationText: "S2.P11.N".localize(), questionText: "S2.P11.Q".localize(), options: [
                StoryOption(text: "S2.P11.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S2.P11.O2".localize(), nextPageIndex: 14)
            ]),
            /* 12 */ StoryPage(imageName: "storyline2_7", narrationText: "S2.P12.N".localize(), questionText: "S2.P12.Q".localize(), options: [
                StoryOption(text: "S2.P12.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S2.P12.O2".localize(), nextPageIndex: 14)
            ]),
            /* 13 */ StoryPage(imageName: "storyline2_8", narrationText: "S2.P13.N".localize(), questionText: "S2.P13.Q".localize(), options: [
                StoryOption(text: "S2.P13.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S2.P13.O2".localize(), nextPageIndex: 16)
            ]),
            /* 14 */ StoryPage(imageName: "storyline2_8", narrationText: "S2.P14.N".localize(), questionText: "S2.P14.Q".localize(), options: [
                StoryOption(text: "S2.P14.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S2.P14.O2".localize(), nextPageIndex: 16)
            ]),
            /* 15 */ StoryPage(imageName: "storyline2_9", narrationText: "S2.P15.N".localize(), questionText: "S2.P15.Q".localize(), options: [
                StoryOption(text: "S2.P15.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S2.P15.O2".localize(), nextPageIndex: 18)
            ]),
            /* 16 */ StoryPage(imageName: "storyline2_9", narrationText: "S2.P16.N".localize(), questionText: "S2.P16.Q".localize(), options: [
                StoryOption(text: "S2.P16.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S2.P16.O2".localize(), nextPageIndex: 18)
            ]),
            /* 17 */ StoryPage(imageName: "storyline2_10", narrationText: "S2.P17.N".localize(), questionText: "S2.P17.Q".localize(), options: [
                StoryOption(text: "S2.P17.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S2.P17.O2".localize(), nextPageIndex: 20)
            ]),
            /* 18 */ StoryPage(imageName: "storyline2_10", narrationText: "S2.P18.N".localize(), questionText: "S2.P18.Q".localize(), options: [
                StoryOption(text: "S2.P18.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S2.P18.O2".localize(), nextPageIndex: 20)
            ]),
            /* 19 */ StoryPage(imageName: "storyline2_11", narrationText: "S2.P19.N".localize(), questionText: "S2.P19.Q".localize(), options: [
                StoryOption(text: "S2.P19.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S2.P19.O2".localize(), nextPageIndex: 22)
            ]),
            /* 20 */ StoryPage(imageName: "storyline2_11", narrationText: "S2.P20.N".localize(), questionText: "S2.P20.Q".localize(), options: [
                StoryOption(text: "S2.P20.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S2.P20.O2".localize(), nextPageIndex: 22)
            ]),
            /* 21 */ StoryPage(imageName: "storyline2_12", narrationText: "S2.P21.N".localize(), questionText: "S2.P21.Q".localize(), options: [
                StoryOption(text: "S2.P21.O1".localize(), nextPageIndex: 23),
                StoryOption(text: "S2.P21.O2".localize(), nextPageIndex: 24)
            ]),
            /* 22 */ StoryPage(imageName: "storyline2_12", narrationText: "S2.P22.N".localize(), questionText: "S2.P22.Q".localize(), options: [
                StoryOption(text: "S2.P22.O1".localize(), nextPageIndex: 23),
                StoryOption(text: "S2.P22.O2".localize(), nextPageIndex: 24)
            ]),
            /* 23 */ StoryPage(imageName: "storyline2_13", narrationText: "S2.P23.N".localize(), questionText: "S2.P23.Q".localize(), options: [
                StoryOption(text: "S2.P23.O1".localize(), nextPageIndex: 25),
                StoryOption(text: "S2.P23.O2".localize(), nextPageIndex: 26)
            ]),
            /* 24 */ StoryPage(imageName: "storyline2_13", narrationText: "S2.P24.N".localize(), questionText: "S2.P24.Q".localize(), options: [
                StoryOption(text: "S2.P24.O1".localize(), nextPageIndex: 25),
                StoryOption(text: "S2.P24.O2".localize(), nextPageIndex: 26)
            ]),
            /* 25 */ StoryPage(imageName: "storyline2_14", narrationText: "S2.P25.N".localize(), questionText: "S2.P25.Q".localize(), options: [
                StoryOption(text: "S2.P25.O1".localize(), nextPageIndex: 27),
                StoryOption(text: "S2.P25.O2".localize(), nextPageIndex: 28)
            ]),
            /* 26 */ StoryPage(imageName: "storyline2_14", narrationText: "S2.P26.N".localize(), questionText: "S2.P26.Q".localize(), options: [
                StoryOption(text: "S2.P26.O1".localize(), nextPageIndex: 27),
                StoryOption(text: "S2.P26.O2".localize(), nextPageIndex: 28)
            ]),
            /* 27 */ StoryPage(imageName: "storyline2_15", narrationText: "S2.P27.N".localize(), questionText: "S2.P27.Q".localize(), options: [
                StoryOption(text: "S2.P27.O1".localize(), nextPageIndex: 29),
                StoryOption(text: "S2.P27.O2".localize(), nextPageIndex: 29)
            ]),
            /* 28 */ StoryPage(imageName: "storyline2_15", narrationText: "S2.P28.N".localize(), questionText: "S2.P28.Q".localize(), options: [
                StoryOption(text: "S2.P28.O1".localize(), nextPageIndex: 29),
                StoryOption(text: "S2.P28.O2".localize(), nextPageIndex: 29)
            ]),
            /* 29 */ StoryPage(imageName: "storyline2_16", narrationText: "S2.P29.N".localize(), questionText: "S2.P29.Q".localize(), options: [
                StoryOption(text: "S2.P29.O1".localize(), nextPageIndex: 0),
                StoryOption(text: "S2.P29.O2".localize(), nextPageIndex: -1)
            ])
        ]
        
        let summerPages: [StoryPage] = [
            // 0: Start
            StoryPage(imageName: "storyline3_1", narrationText: "S3.P0.N".localize(), questionText: "S3.P0.Q".localize(), options: [
                StoryOption(text: "S3.P0.O1".localize(), nextPageIndex: 1),
                StoryOption(text: "S3.P0.O2".localize(), nextPageIndex: 2)
            ]),
            // 1-2: Branching
            StoryPage(imageName: "storyline3_2", narrationText: "S3.P1.N".localize(), questionText: "S3.P1.Q".localize(), options: [
                StoryOption(text: "S3.P1.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S3.P1.O2".localize(), nextPageIndex: 4)
            ]),
            StoryPage(imageName: "storyline3_2", narrationText: "S3.P2.N".localize(), questionText: "S3.P2.Q".localize(), options: [
                StoryOption(text: "S3.P2.O1".localize(), nextPageIndex: 3),
                StoryOption(text: "S3.P2.O2".localize(), nextPageIndex: 4)
            ]),
            // 3-4: Merging
            StoryPage(imageName: "storyline3_3", narrationText: "S3.P3.N".localize(), questionText: "S3.P3.Q".localize(), options: [
                StoryOption(text: "S3.P3.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S3.P3.O2".localize(), nextPageIndex: 6)
            ]),
            StoryPage(imageName: "storyline3_3", narrationText: "S3.P4.N".localize(), questionText: "S3.P4.Q".localize(), options: [
                StoryOption(text: "S3.P4.O1".localize(), nextPageIndex: 5),
                StoryOption(text: "S3.P4.O2".localize(), nextPageIndex: 6)
            ]),
            // 5-6: Merging
            StoryPage(imageName: "storyline3_4", narrationText: "S3.P5.N".localize(), questionText: "S3.P5.Q".localize(), options: [
                StoryOption(text: "S3.P5.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S3.P5.O2".localize(), nextPageIndex: 8)
            ]),
            StoryPage(imageName: "storyline3_4", narrationText: "S3.P6.N".localize(), questionText: "S3.P6.Q".localize(), options: [
                StoryOption(text: "S3.P6.O1".localize(), nextPageIndex: 7),
                StoryOption(text: "S3.P6.O2".localize(), nextPageIndex: 8)
            ]),
            // 7-8: Branching
            StoryPage(imageName: "storyline3_5", narrationText: "S3.P7.N".localize(), questionText: "S3.P7.Q".localize(), options: [
                StoryOption(text: "S3.P7.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S3.P7.O2".localize(), nextPageIndex: 10)
            ]),
            StoryPage(imageName: "storyline3_5", narrationText: "S3.P8.N".localize(), questionText: "S3.P8.Q".localize(), options: [
                StoryOption(text: "S3.P8.O1".localize(), nextPageIndex: 9),
                StoryOption(text: "S3.P8.O2".localize(), nextPageIndex: 10)
            ]),
            // 9-10: Branching
            StoryPage(imageName: "storyline3_6", narrationText: "S3.P9.N".localize(), questionText: "S3.P9.Q".localize(), options: [
                StoryOption(text: "S3.P9.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S3.P9.O2".localize(), nextPageIndex: 12)
            ]),
            StoryPage(imageName: "storyline3_6", narrationText: "S3.P10.N".localize(), questionText: "S3.P10.Q".localize(), options: [
                StoryOption(text: "S3.P10.O1".localize(), nextPageIndex: 11),
                StoryOption(text: "S3.P10.O2".localize(), nextPageIndex: 12)
            ]),
            // 11-12: Merging
            StoryPage(imageName: "storyline3_7", narrationText: "S3.P11.N".localize(), questionText: "S3.P11.Q".localize(), options: [
                StoryOption(text: "S3.P11.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S3.P11.O2".localize(), nextPageIndex: 14)
            ]),
            StoryPage(imageName: "storyline3_7", narrationText: "S3.P12.N".localize(), questionText: "S3.P12.Q".localize(), options: [
                StoryOption(text: "S3.P12.O1".localize(), nextPageIndex: 13),
                StoryOption(text: "S3.P12.O2".localize(), nextPageIndex: 14)
            ]),
            // 13-14: Merging
            StoryPage(imageName: "storyline3_8", narrationText: "S3.P13.N".localize(), questionText: "S3.P13.Q".localize(), options: [
                StoryOption(text: "S3.P13.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S3.P13.O2".localize(), nextPageIndex: 16)
            ]),
            StoryPage(imageName: "storyline3_8", narrationText: "S3.P14.N".localize(), questionText: "S3.P14.Q".localize(), options: [
                StoryOption(text: "S3.P14.O1".localize(), nextPageIndex: 15),
                StoryOption(text: "S3.P14.O2".localize(), nextPageIndex: 16)
            ]),
            // 15-16: Branching
            StoryPage(imageName: "storyline3_9", narrationText: "S3.P15.N".localize(), questionText: "S3.P15.Q".localize(), options: [
                StoryOption(text: "S3.P15.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S3.P15.O2".localize(), nextPageIndex: 18)
            ]),
            StoryPage(imageName: "storyline3_9", narrationText: "S3.P16.N".localize(), questionText: "S3.P16.Q".localize(), options: [
                StoryOption(text: "S3.P16.O1".localize(), nextPageIndex: 17),
                StoryOption(text: "S3.P16.O2".localize(), nextPageIndex: 18)
            ]),
            // 17-18: Merging
            StoryPage(imageName: "storyline3_10", narrationText: "S3.P17.N".localize(), questionText: "S3.P17.Q".localize(), options: [
                StoryOption(text: "S3.P17.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S3.P17.O2".localize(), nextPageIndex: 20)
            ]),
            StoryPage(imageName: "storyline3_10", narrationText: "S3.P18.N".localize(), questionText: "S3.P18.Q".localize(), options: [
                StoryOption(text: "S3.P18.O1".localize(), nextPageIndex: 19),
                StoryOption(text: "S3.P18.O2".localize(), nextPageIndex: 20)
            ]),
            // 19-20: Merging
            StoryPage(imageName: "storyline3_11", narrationText: "S3.P19.N".localize(), questionText: "S3.P19.Q".localize(), options: [
                StoryOption(text: "S3.P19.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S3.P19.O2".localize(), nextPageIndex: 22)
            ]),
            StoryPage(imageName: "storyline3_11", narrationText: "S3.P20.N".localize(), questionText: "S3.P20.Q".localize(), options: [
                StoryOption(text: "S3.P20.O1".localize(), nextPageIndex: 21),
                StoryOption(text: "S3.P20.O2".localize(), nextPageIndex: 22)
            ]),
            // 21-22: Merging
            StoryPage(imageName: "storyline3_12", narrationText: "S3.P21.N".localize(), questionText: "S3.P21.Q".localize(), options: [
                StoryOption(text: "S3.P21.O1".localize(), nextPageIndex: 23),
                StoryOption(text: "S3.P21.O2".localize(), nextPageIndex: 24)
            ]),
            StoryPage(imageName: "storyline3_12", narrationText: "S3.P22.N".localize(), questionText: "S3.P22.Q".localize(), options: [
                StoryOption(text: "S3.P22.O1".localize(), nextPageIndex: 23),
                StoryOption(text: "S3.P22.O2".localize(), nextPageIndex: 24)
            ]),
            // 23-24: Merging
            StoryPage(imageName: "storyline3_13", narrationText: "S3.P23.N".localize(), questionText: "S3.P23.Q".localize(), options: [
                StoryOption(text: "S3.P23.O1".localize(), nextPageIndex: 25),
                StoryOption(text: "S3.P23.O2".localize(), nextPageIndex: 26)
            ]),
            StoryPage(imageName: "storyline3_13", narrationText: "S3.P24.N".localize(), questionText: "S3.P24.Q".localize(), options: [
                StoryOption(text: "S3.P24.O1".localize(), nextPageIndex: 25),
                StoryOption(text: "S3.P24.O2".localize(), nextPageIndex: 26)
            ]),
            // 25-26: Merging
            StoryPage(imageName: "storyline3_14", narrationText: "S3.P25.N".localize(), questionText: "S3.P25.Q".localize(), options: [
                StoryOption(text: "S3.P25.O1".localize(), nextPageIndex: 27),
                StoryOption(text: "S3.P25.O2".localize(), nextPageIndex: 28)
            ]),
            StoryPage(imageName: "storyline3_14", narrationText: "S3.P26.N".localize(), questionText: "S3.P26.Q".localize(), options: [
                StoryOption(text: "S3.P26.O1".localize(), nextPageIndex: 27),
                StoryOption(text: "S3.P26.O2".localize(), nextPageIndex: 28)
            ]),
            // 27-28: Finale
            StoryPage(imageName: "storyline3_15", narrationText: "S3.P27.N".localize(), questionText: "S3.P27.Q".localize(), options: [
                StoryOption(text: "S3.P27.O1".localize(), nextPageIndex: 0),
                StoryOption(text: "S3.P27.O2".localize(), nextPageIndex: -1)
            ]),
            StoryPage(imageName: "storyline3_15", narrationText: "S3.P28.N".localize(), questionText: "S3.P28.Q".localize(), options: [
                StoryOption(text: "S3.P28.O1".localize(), nextPageIndex: 0),
                StoryOption(text: "S3.P28.O2".localize(), nextPageIndex: -1)
            ])
        ]

        stories = [
            Storyline(title: "StoryTitle1".localize(), pages: maidPages),
            Storyline(title: "StoryTitle2".localize(), pages: tokyoPages),
            Storyline(title: "StoryTitle3".localize(), pages: summerPages)
        ]
    }
}
