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
            StoryPage(imageName: "storyline1_1", narrationText: "The mansion is silent as you return. A faint light flickers in your study. You find Elena, your quietest maid, nervously tidying your desk at 2 AM.", questionText: "Approach her?", options: [
                StoryOption(text: "Elena, why aren't you in bed?", nextPageIndex: 1),
                StoryOption(text: "(Watch from the shadows)", nextPageIndex: 2)
            ]),
            // 1 & 2: Разветвление (Начало)
            StoryPage(imageName: "storyline1_2", narrationText: "She gasps, dropping a feather duster. 'Sir! I... I couldn't sleep. The dust was bothering me.' She looks pale and won't meet your eyes.", questionText: "Believe her?", options: [
                StoryOption(text: "It's too late for cleaning", nextPageIndex: 3),
                StoryOption(text: "You're a dedicated worker", nextPageIndex: 4)
            ]),
            StoryPage(imageName: "storyline1_2", narrationText: "You watch as she pulls a small silver key from her apron. She stares at it with a mix of longing and fear before noticing your shadow.", questionText: "Step forward?", options: [
                StoryOption(text: "What is that key, Elena?", nextPageIndex: 3),
                StoryOption(text: "Explain yourself immediately", nextPageIndex: 4)
            ]),
            // 3 & 4: Схождение (Странное поведение)
            StoryPage(imageName: "storyline1_3", narrationText: "She trembles. 'This house... it has so many secrets, sir. Sometimes they weigh me down.' She points toward the old safe behind your bookshelf.", questionText: "Ask about the safe?", options: [
                StoryOption(text: "Does the key belong there?", nextPageIndex: 5),
                StoryOption(text: "The safe is off-limits", nextPageIndex: 6)
            ]),
            StoryPage(imageName: "storyline1_3", narrationText: "She tries to hide the key, but it falls. 'I'm not a thief, I promise! I just... I saw it in the hallway and thought it was yours.'", questionText: "Pick up the key?", options: [
                StoryOption(text: "(Pick it up)", nextPageIndex: 5),
                StoryOption(text: "Let's see what it opens", nextPageIndex: 6)
            ]),
            // 5 & 6: Развитие (Тайна семьи)
            StoryPage(imageName: "storyline1_4", narrationText: "The key fits a hidden compartment inside the safe. Elena watches with bated breath as you reveal a stack of old, yellowed letters tied with a black ribbon.", questionText: "Read the top letter?", options: [
                StoryOption(text: "Read it aloud", nextPageIndex: 7),
                StoryOption(text: "Ask Elena what she knows", nextPageIndex: 8)
            ]),
            StoryPage(imageName: "storyline1_4", narrationText: "Elena's voice drops to a whisper. 'My mother was a maid here too. She told me the Master kept a record of a girl he once loved. A girl who looked like me.'", questionText: "Wait, what?", options: [
                StoryOption(text: "Tell me everything", nextPageIndex: 7),
                StoryOption(text: "This is impossible", nextPageIndex: 8)
            ]),
            // 7 & 8: Схождение (Углубление связи)
            StoryPage(imageName: "storyline1_5", narrationText: "The letters describe a forbidden romance. Elena steps closer, the moonlight catching her tears. 'I didn't want to steal. I wanted to know if I belonged here.'", questionText: "Comfort her?", options: [
                StoryOption(text: "Put a hand on her shoulder", nextPageIndex: 9),
                StoryOption(text: "Give her some space", nextPageIndex: 10)
            ]),
            StoryPage(imageName: "storyline1_5", narrationText: "She explains her mother's diary mentioned a hidden truth in this room. 'I've lived in this house my whole life, sir, but I feel like a ghost.'", questionText: "Make a promise?", options: [
                StoryOption(text: "I'll help you find the truth", nextPageIndex: 9),
                StoryOption(text: "We will solve this together", nextPageIndex: 10)
            ]),
            // 9 & 10: Поиск улик (Середина)
            StoryPage(imageName: "storyline1_6", narrationText: "You spend the next hour digging through the records. You find a birth certificate with a familiar name, but the father's section is blank.", questionText: "Look at Elena?", options: [
                StoryOption(text: "Could it be my uncle?", nextPageIndex: 11),
                StoryOption(text: "Maybe it's best not to know", nextPageIndex: 12)
            ]),
            StoryPage(imageName: "storyline1_6", narrationText: "The search grows intense. Elena finds a jewelry box hidden behind the letters. Inside is a locket with a portrait of a woman who is her twin.", questionText: "Show her?", options: [
                StoryOption(text: "Look at this locket", nextPageIndex: 11),
                StoryOption(text: "Is this your mother?", nextPageIndex: 12)
            ]),
            // 11 & 12: Нарастание напряжения
            StoryPage(imageName: "storyline1_7", narrationText: "Suddenly, a floorboard creaks outside. Someone is in the hallway. Elena's eyes go wide with panic. 'If the Butler finds us...!'", questionText: "Hide?", options: [
                StoryOption(text: "Hide in the closet with her", nextPageIndex: 13),
                StoryOption(text: "Stay and face them", nextPageIndex: 14)
            ]),
            StoryPage(imageName: "storyline1_7", narrationText: "Footsteps approach. Elena grabs your sleeve. 'Please, sir, no one can know we found these. It's dangerous for me.'", questionText: "Reaction?", options: [
                StoryOption(text: "Douse the lights", nextPageIndex: 13),
                StoryOption(text: "Lock the door", nextPageIndex: 14)
            ]),
            // 13 & 14: Интимный момент (в шкафу/темноте)
            StoryPage(imageName: "storyline1_8", narrationText: "The room is pitch black. In the tight space, you can hear Elena's rapid heartbeat and the scent of rose petals on her skin. She is incredibly close.", questionText: "Whisper to her?", options: [
                StoryOption(text: "You're safe with me", nextPageIndex: 15),
                StoryOption(text: "(Stay silent and wait)", nextPageIndex: 16)
            ]),
            StoryPage(imageName: "storyline1_8", narrationText: "You hold the door shut. The person outside lingers for a moment, then walks away. Elena leans against you, trembling with adrenaline.", questionText: "Reassure her?", options: [
                StoryOption(text: "They're gone now", nextPageIndex: 15),
                StoryOption(text: "Are you okay?", nextPageIndex: 16)
            ]),
            // 15 & 16: Схождение (Откровенность)
            StoryPage(imageName: "storyline1_9", narrationText: "She pulls away slightly, but her hand lingers on your chest. 'Sir... I've always admired you from afar. This secret... it's too much to carry alone.'", questionText: "Your feelings?", options: [
                StoryOption(text: "I've noticed you too", nextPageIndex: 17),
                StoryOption(text: "You're more than a maid", nextPageIndex: 18)
            ]),
            StoryPage(imageName: "storyline1_9", narrationText: "'I thought I was just a servant to you,' she whispers. 'Just part of the furniture. But tonight feels like the start of something real.'", questionText: "Agree?", options: [
                StoryOption(text: "It is real, Elena", nextPageIndex: 17),
                StoryOption(text: "Let's see where this leads", nextPageIndex: 18)
            ]),
            // 17 & 18: Кульминация (Выбор судьбы)
            StoryPage(imageName: "storyline1_10", narrationText: "She opens the locket. Inside is a small note: 'For my daughter, the true heir.' Elena gasps. The mansion might actually belong to her.", questionText: "The implications?", options: [
                StoryOption(text: "We must reveal this", nextPageIndex: 19),
                StoryOption(text: "We should keep it secret", nextPageIndex: 20)
            ]),
            StoryPage(imageName: "storyline1_10", narrationText: "The note proves Elena is the rightful owner of the estate. She looks around the room, stunned. 'I... I don't want the house. I just want a family.'", questionText: "What do you want?", options: [
                StoryOption(text: "You have me now", nextPageIndex: 19),
                StoryOption(text: "What will you do?", nextPageIndex: 20)
            ]),
            // 19 & 20: Последнее препятствие
            StoryPage(imageName: "storyline1_11", narrationText: "She looks at the fireplace. 'If I burn this, I'm just Elena again. If I keep it, everything changes. Sir, what should I do?'", questionText: "Give advice?", options: [
                StoryOption(text: "Burn it and stay with me", nextPageIndex: 21),
                StoryOption(text: "Keep it and take your place", nextPageIndex: 22)
            ]),
            StoryPage(imageName: "storyline1_11", narrationText: "Elena holds the proof of her lineage. 'The family name is cursed, sir. I’d rather be a happy nobody than a miserable lady.'", questionText: "Your choice?", options: [
                StoryOption(text: "Follow your heart", nextPageIndex: 21),
                StoryOption(text: "Think about your future", nextPageIndex: 22)
            ]),
            // 21 - 24: Разные финальные сцены (подготовка к финалам)
            StoryPage(imageName: "storyline1_12", narrationText: "She tosses the paper into the dying embers. The secret turns to ash. Elena smiles, looking more free than ever before.", questionText: "The future?", options: [
                StoryOption(text: "A new beginning", nextPageIndex: 23),
                StoryOption(text: "Just the two of us", nextPageIndex: 23)
            ]),
            StoryPage(imageName: "storyline1_12", narrationText: "She tucks the paper into her bodice. 'Then I will become the Lady of this house. And I'll need a partner by my side.'", questionText: "Are you ready?", options: [
                StoryOption(text: "Always", nextPageIndex: 24),
                StoryOption(text: "It will be a long road", nextPageIndex: 24)
            ]),
            // 25: ФИНАЛ 1 (Любовь превыше всего)
            StoryPage(imageName: "storyline1_13", narrationText: "Elena is no longer your maid. She is your equal, your partner, and your secret. The mansion remains yours, but the heart of it belongs to her.", questionText: "THE END", options: [
                StoryOption(text: "Restart Story", nextPageIndex: 0),
                StoryOption(text: "Finish", nextPageIndex: -1)
            ]),
            // 26: ФИНАЛ 2 (Власть и страсть)
            StoryPage(imageName: "storyline1_13", narrationText: "The truth comes out. Elena becomes the head of the household. The power dynamic has shifted, but the bond you forged that night is unbreakable.", questionText: "THE END", options: [
                StoryOption(text: "Restart Story", nextPageIndex: 0),
                StoryOption(text: "Finish", nextPageIndex: -1)
            ]),
        ]

        // --- ИСТОРИЯ 2: MIDNIGHT TOKYO ---
        let tokyoPages: [StoryPage] = [
            // --- АКТ 1: ВСТРЕЧА И ПОБЕГ ---
            /* 0 */ StoryPage(imageName: "storyline2_1", narrationText: "Rain hits the neon streets of Shinjuku. You're sitting in a quiet bar when a woman in a wet trench coat sits next to you. She smells like jasmine and gunpowder.", questionText: "How do you start a conversation?", options: [
                StoryOption(text: "Buy her a drink", nextPageIndex: 1),
                StoryOption(text: "Rough night, huh?", nextPageIndex: 2)
            ]),
                    /* 1 */ StoryPage(imageName: "storyline2_2", narrationText: "She looks at the glass, then at you. 'You're brave,' she whispers. She slides a small data chip across the counter.", questionText: "Take the chip?", options: [
                        StoryOption(text: "Take it and hide it", nextPageIndex: 3),
                        StoryOption(text: "I don't want trouble", nextPageIndex: 4)
                    ]),
                    /* 2 */ StoryPage(imageName: "storyline2_2", narrationText: "She gives a bitter laugh. 'You have no idea.' She looks over her shoulder. Two men in black suits just entered the bar.", questionText: "Help her hide?", options: [
                        StoryOption(text: "Follow me to the back door", nextPageIndex: 3),
                        StoryOption(text: "Pretend we're a couple", nextPageIndex: 4)
                    ]),
                    /* 3 */ StoryPage(imageName: "storyline2_3", narrationText: "You pull her close. The men scan the room and leave. She looks relieved but her hands are trembling. 'I'm Mia,' she whispers.", questionText: "Ask about the danger?", options: [
                        StoryOption(text: "Who was that, Mia?", nextPageIndex: 5),
                        StoryOption(text: "Are we safe now?", nextPageIndex: 6)
                    ]),
                    /* 4 */ StoryPage(imageName: "storyline2_3", narrationText: "The men approach, but you play it cool. They walk past. She whispers: 'You saved me. I'm Mia. But this chip... it's worth a million lives.'", questionText: "Ask about the chip?", options: [
                        StoryOption(text: "What's on it?", nextPageIndex: 5),
                        StoryOption(text: "We should get out of here", nextPageIndex: 6)
                    ]),
                    /* 5 */ StoryPage(imageName: "storyline2_4", narrationText: "Mia looks at the door. 'Corporation 'Arasaka' wants this. It's not just data, it's a digital soul.'", questionText: "Believe her?", options: [
                        StoryOption(text: "A digital soul? Really?", nextPageIndex: 7),
                        StoryOption(text: "I've heard rumors...", nextPageIndex: 8)
                    ]),
                    /* 6 */ StoryPage(imageName: "storyline2_4", narrationText: "Mia grabs your hand. 'Nowhere is safe until we upload this. We need to reach the Tech-District.'", questionText: "Go with her?", options: [
                        StoryOption(text: "I'll take you there", nextPageIndex: 7),
                        StoryOption(text: "Only if you tell me more", nextPageIndex: 8)
                    ]),
                    /* 7 */ StoryPage(imageName: "storyline2_5", narrationText: "You slip out the back. The alley is dark and smells of ozone. Suddenly, a drone buzzes overhead, searching for heat signatures.", questionText: "How to avoid the drone?", options: [
                        StoryOption(text: "Hide under the canopy", nextPageIndex: 9),
                        StoryOption(text: "Run for the subway", nextPageIndex: 10)
                    ]),
                    /* 8 */ StoryPage(imageName: "storyline2_5", narrationText: "Mia stops in the rain. 'If they catch me, they'll erase me. And you too, for helping.'", questionText: "Reassure her?", options: [
                        StoryOption(text: "I'm in this with you", nextPageIndex: 9),
                        StoryOption(text: "Let's just move, fast", nextPageIndex: 10)
                    ]),
                    /* 9 */ StoryPage(imageName: "storyline2_6", narrationText: "The drone passes. You reach your car. Mia looks at you with a mix of fear and gratitude.", questionText: "Start the engine?", options: [
                        StoryOption(text: "Punch it!", nextPageIndex: 11),
                        StoryOption(text: "Drive slowly, blend in", nextPageIndex: 12)
                    ]),
                    /* 10 */ StoryPage(imageName: "storyline2_6", narrationText: "You barely make it to the station. The crowd is huge, providing perfect cover. Mia stays close, her shoulder brushing yours.", questionText: "Keep moving?", options: [
                        StoryOption(text: "Take the express train", nextPageIndex: 11),
                        StoryOption(text: "Walk through the tunnels", nextPageIndex: 12)
                    ]),
                    
                    // --- АКТ 2: ПУТЬ ЧЕРЕЗ ГОРОД ---
                    /* 11 */ StoryPage(imageName: "storyline2_7", narrationText: "You're moving through the high-rise district. The holographic advertisements illuminate Mia's face in pink and blue.", questionText: "Break the silence?", options: [
                        StoryOption(text: "Why me, Mia?", nextPageIndex: 13),
                        StoryOption(text: "Tell me about the chip", nextPageIndex: 14)
                    ]),
                    /* 12 */ StoryPage(imageName: "storyline2_7", narrationText: "The city feels like a labyrinth. You stop at a hidden ramen shop to rest for a minute.", questionText: "Watch the street?", options: [
                        StoryOption(text: "Check for tails", nextPageIndex: 13),
                        StoryOption(text: "Talk to Mia", nextPageIndex: 14)
                    ]),
                    /* 13 */ StoryPage(imageName: "storyline2_8", narrationText: "Mia looks down. 'You were the only one who didn't look like a predator tonight. I needed a human, not a mercenary.'", questionText: "Respond kindly?", options: [
                        StoryOption(text: "I'm glad I was there", nextPageIndex: 15),
                        StoryOption(text: "I'm just a guy in a bar", nextPageIndex: 16)
                    ]),
                    /* 14 */ StoryPage(imageName: "storyline2_8", narrationText: "Mia taps the chip. 'This is my sister's consciousness. She was a netrunner who saw too much. They 'killed' her body.'", questionText: "Express sympathy?", options: [
                        StoryOption(text: "That's horrible...", nextPageIndex: 15),
                        StoryOption(text: "Can she be saved?", nextPageIndex: 16)
                    ]),
                    /* 15 */ StoryPage(imageName: "storyline2_9", narrationText: "She wipes a tear. 'The upload point is in the old TV tower. But the bridge is blocked by a police checkpoint.'", questionText: "How to cross?", options: [
                        StoryOption(text: "Use your hacker skills", nextPageIndex: 17),
                        StoryOption(text: "Bribe the guards", nextPageIndex: 18)
                    ]),
                    /* 16 */ StoryPage(imageName: "storyline2_9", narrationText: "Mia shows you a map. 'If we go through the sewers, it's safer, but it's a long way.'", questionText: "Choose the path?", options: [
                        StoryOption(text: "Let's take the sewers", nextPageIndex: 17),
                        StoryOption(text: "No, we need speed", nextPageIndex: 18)
                    ]),
                    /* 17 */ StoryPage(imageName: "storyline2_10", narrationText: "It's dirty and dark, but effective. Mia relies on your guidance. You feel the weight of her trust.", questionText: "Help her over a gap?", options: [
                        StoryOption(text: "Give her a hand", nextPageIndex: 19),
                        StoryOption(text: "Lead the way", nextPageIndex: 20)
                    ]),
                    /* 18 */ StoryPage(imageName: "storyline2_10", narrationText: "The bridge is chaotic. You use the confusion to slip past. Mia's heart is racing so fast you can almost hear it.", questionText: "Keep her calm?", options: [
                        StoryOption(text: "We're almost there", nextPageIndex: 19),
                        StoryOption(text: "Stay focused, Mia", nextPageIndex: 20)
                    ]),
                    /* 19 */ StoryPage(imageName: "storyline2_11", narrationText: "The TV tower looms ahead. It's a relic of the old world, surrounded by modern steel. Mia looks exhausted.", questionText: "Offer a break?", options: [
                        StoryOption(text: "Rest for 5 minutes", nextPageIndex: 21),
                        StoryOption(text: "Push through to the end", nextPageIndex: 22)
                    ]),
                    /* 20 */ StoryPage(imageName: "storyline2_11", narrationText: "You reach the base of the tower. 'The elevator is dead,' Mia sighs. 'We have to climb.'", questionText: "Encourage her?", options: [
                        StoryOption(text: "One step at a time", nextPageIndex: 21),
                        StoryOption(text: "I'll carry the gear", nextPageIndex: 22)
                    ]),
                    
                    // --- АКТ 3: ФИНАЛ ---
                    /* 21 */ StoryPage(imageName: "storyline2_12", narrationText: "You sit on the stairs. Mia leans against you. 'If we make it... what will you do tomorrow?'", questionText: "Think about the future?", options: [
                        StoryOption(text: "Maybe we can get coffee", nextPageIndex: 23),
                        StoryOption(text: "I'll just be happy to sleep", nextPageIndex: 24)
                    ]),
                    /* 22 */ StoryPage(imageName: "storyline2_12", narrationText: "The climb is brutal. Halfway up, you hear sirens below. They've found your car.", questionText: "Hurry up?", options: [
                        StoryOption(text: "Double the pace!", nextPageIndex: 23),
                        StoryOption(text: "Find a place to hide", nextPageIndex: 24)
                    ]),
                    /* 23 */ StoryPage(imageName: "storyline2_13", narrationText: "You reach the server room. The air is cold and hums with power. Mia connects the chip. 'Initialising...' she says.", questionText: "Watch the screen?", options: [
                        StoryOption(text: "Guard the door", nextPageIndex: 25),
                        StoryOption(text: "Stay by Mia's side", nextPageIndex: 26)
                    ]),
                    /* 24 */ StoryPage(imageName: "storyline2_13", narrationText: "The terminal is ancient but functional. Mia's fingers fly across the keys. 'The firewall is huge!'", questionText: "Help her hack?", options: [
                        StoryOption(text: "Override the power", nextPageIndex: 25),
                        StoryOption(text: "Keep her steady", nextPageIndex: 26)
                    ]),
                    /* 25 */ StoryPage(imageName: "storyline2_14", narrationText: "The doors hiss. Arasaka's tactical team is here. You draw your weapon. 'Just two more minutes!' Mia screams.", questionText: "Hold the line?", options: [
                        StoryOption(text: "Open fire!", nextPageIndex: 27),
                        StoryOption(text: "Barricade the door", nextPageIndex: 28)
                    ]),
                    /* 26 */ StoryPage(imageName: "storyline2_14", narrationText: "Mia's eyes glow blue. She's deep in the net. The soldiers are breaking through the glass ceiling.", questionText: "Protect Mia?", options: [
                        StoryOption(text: "Cover her with your body", nextPageIndex: 27),
                        StoryOption(text: "Pull her to cover", nextPageIndex: 28)
                    ]),
                    /* 27 */ StoryPage(imageName: "storyline2_15", narrationText: "A blinding flash of light. The upload is 100%. The soldiers freeze—their cybernetics have been jammed from the net.", questionText: "Check on Mia?", options: [
                        StoryOption(text: "Is it done?", nextPageIndex: 29),
                        StoryOption(text: "Are you okay?", nextPageIndex: 29)
                    ]),
                    /* 28 */ StoryPage(imageName: "storyline2_15", narrationText: "Everything goes dark. Then, every screen in Tokyo lights up with a single message: 'FREEDOM'. Mia collapses into your arms.", questionText: "Wake her up?", options: [
                        StoryOption(text: "Mia! Speak to me!", nextPageIndex: 29),
                        StoryOption(text: "Hold her tight", nextPageIndex: 29)
                    ]),
                    /* 29 */ StoryPage(imageName: "storyline2_16", narrationText: "The sun begins to rise over a different Tokyo. Mia smiles, her eyes normal again. 'She's safe. We're safe.'", questionText: "THE END", options: [
                        StoryOption(text: "Restart Story", nextPageIndex: 0),
                        StoryOption(text: "Finish", nextPageIndex: -1)
                    ])
        ]

        // --- ИСТОРИЯ 3: SUMMER CAMP ---
        let summerPages: [StoryPage] = [
            // 0: Start
            StoryPage(imageName: "storyline3_1", narrationText: "The last night of summer camp. The crackling bonfire is dying down, and the smell of pine needles is everywhere. Yuki, usually shy, catches your eye and gestures toward the dark path leading to the lake.", questionText: "Will you follow her into the night?", options: [
                StoryOption(text: "I've been waiting for this", nextPageIndex: 1),
                StoryOption(text: "Sure, let's go", nextPageIndex: 2)
            ]),
            
            // 1-2: The Forest Path (Branching)
            StoryPage(imageName: "storyline3_2", narrationText: "You catch up to her. The forest is alive with the sound of crickets. Yuki's hand occasionally brushes yours as you walk. She seems nervous.", questionText: "How do you break the silence?", options: [
                StoryOption(text: "Grab her hand firmly", nextPageIndex: 3),
                StoryOption(text: "Ask what's on her mind", nextPageIndex: 4)
            ]),
            StoryPage(imageName: "storyline3_2", narrationText: "You walk side by side. The moonlight barely pierces the thick canopy. Yuki looks at you sideways, smiling faintly. 'I didn't think you'd actually come,' she whispers.", questionText: "What's your answer?", options: [
                StoryOption(text: "I wouldn't miss it", nextPageIndex: 3),
                StoryOption(text: "I was curious", nextPageIndex: 4)
            ]),
            
            // 3-4: The Lake Edge (Merging)
            StoryPage(imageName: "storyline3_3", narrationText: "You reach the pier. The water is like a dark mirror, reflecting the vast sea of stars. Yuki takes off her shoes and sits on the edge, dangling her feet.", questionText: "Sit close to her?", options: [
                StoryOption(text: "Sit right next to her", nextPageIndex: 5),
                StoryOption(text: "Give her some space", nextPageIndex: 6)
            ]),
            StoryPage(imageName: "storyline3_3", narrationText: "The pier creaks under your weight. The cold air from the lake makes Yuki shiver slightly. She doesn't move away as you approach.", questionText: "Offer your jacket?", options: [
                StoryOption(text: "Put your jacket on her", nextPageIndex: 5),
                StoryOption(text: "Just sit and talk", nextPageIndex: 6)
            ]),
            
            // 5-6: The First Secret (Merging)
            StoryPage(imageName: "storyline3_4", narrationText: "Yuki looks at the stars. 'Do you remember our first day here?' she asks. 'You helped me with my bags when everyone else was busy.'", questionText: "Do you remember?", options: [
                StoryOption(text: "I remember every detail", nextPageIndex: 7),
                StoryOption(text: "It feels like forever ago", nextPageIndex: 8)
            ]),
            StoryPage(imageName: "storyline3_4", narrationText: "She laughs softly. 'I was so scared back then. But seeing you made me feel like I belonged here.' She looks at the water.", questionText: "Admit your own feelings?", options: [
                StoryOption(text: "I felt the same way", nextPageIndex: 7),
                StoryOption(text: "I'm glad I could help", nextPageIndex: 8)
            ]),
            
            // 7-8: Into the Water? (Branching)
            StoryPage(imageName: "storyline3_5", narrationText: "The night is perfectly still. Suddenly, Yuki stands up. 'The water looks so inviting. Should we... go in?' she asks with a mischievous glint.", questionText: "Are you brave enough?", options: [
                StoryOption(text: "Let's dive in!", nextPageIndex: 9),
                StoryOption(text: "It's too cold, Yuki", nextPageIndex: 10)
            ]),
            StoryPage(imageName: "storyline3_5", narrationText: "She looks at the lake, then at you. 'I want to do something brave tonight. Something I'll remember all winter.'", questionText: "Encourage her?", options: [
                StoryOption(text: "Jump in with me?", nextPageIndex: 9),
                StoryOption(text: "Let's stay here", nextPageIndex: 10)
            ]),
            
            // 9-10: The Splash / The Huddle (Branching)
            StoryPage(imageName: "storyline3_6", narrationText: "SPLASH! The water is freezing but exhilarating. You and Yuki surface, gasping and laughing, splashing each other like kids.", questionText: "Swim closer to her?", options: [
                StoryOption(text: "Pull her into a hug", nextPageIndex: 11),
                StoryOption(text: "Keep splashing!", nextPageIndex: 12)
            ]),
            StoryPage(imageName: "storyline3_6", narrationText: "You stay on the pier. You talk for hours about everything—school, parents, and the future. The bond between you grows stronger in the silence.", questionText: "Lean in closer?", options: [
                StoryOption(text: "Rest your head on hers", nextPageIndex: 11),
                StoryOption(text: "Look into her eyes", nextPageIndex: 12)
            ]),
            
            // 11-12: The Confession (Merging)
            StoryPage(imageName: "storyline3_7", narrationText: "The mood shifts. Yuki stops talking. In the dim light, her eyes are searching yours. 'I don't want to go back to the city tomorrow,' she whispers.", questionText: "What do you say?", options: [
                StoryOption(text: "We'll see each other there", nextPageIndex: 13),
                StoryOption(text: "Let's not think about tomorrow", nextPageIndex: 14)
            ]),
            StoryPage(imageName: "storyline3_7", narrationText: "Yuki takes a deep breath. 'If I don't say this now, I never will. I've liked you since that first day at the bus stop.'", questionText: "How do you react?", options: [
                StoryOption(text: "I've liked you too", nextPageIndex: 13),
                StoryOption(text: "Finally, the truth!", nextPageIndex: 14)
            ]),
            
            // 13-14: The Gift (Merging)
            StoryPage(imageName: "storyline3_8", narrationText: "She reaches into her pocket and pulls out a handmade friendship bracelet. It's blue and white, the colors of the lake. 'I made this for you,' she says shyly.", questionText: "Accept the gift?", options: [
                StoryOption(text: "Let her tie it on you", nextPageIndex: 15),
                StoryOption(text: "Give her a kiss instead", nextPageIndex: 16)
            ]),
            StoryPage(imageName: "storyline3_8", narrationText: "The bracelet is simple, but you know it took her hours to make. She waits for your reaction, her bottom lip trembling slightly.", questionText: "What's your move?", options: [
                StoryOption(text: "Thank her with a hug", nextPageIndex: 15),
                StoryOption(text: "Tell her it's perfect", nextPageIndex: 16)
            ]),
            
            // 15-16: The Vow (Branching)
            StoryPage(imageName: "storyline3_9", narrationText: "Yuki smiles, a real, radiant smile. 'I was so worried you'd think it was childish.' She looks up at the moon, looking more confident now.", questionText: "Make a promise?", options: [
                StoryOption(text: "Promise to call every day", nextPageIndex: 17),
                StoryOption(text: "Promise to visit her soon", nextPageIndex: 18)
            ]),
            StoryPage(imageName: "storyline3_9", narrationText: "The atmosphere is electric. Yuki is staring at your lips. The world around you disappears; it's just you two and the summer night.", questionText: "Is this the moment?", options: [
                StoryOption(text: "Lean in for a kiss", nextPageIndex: 17),
                StoryOption(text: "Whisper something sweet", nextPageIndex: 18)
            ]),
            
            // 17-18: The Shooting Star (Merging)
            StoryPage(imageName: "storyline3_10", narrationText: "Just then, a shooting star streaks across the sky, leaving a trail of silver. Yuki gasps. 'Quick! Make a wish!' she cries out.", questionText: "What do you wish for?", options: [
                StoryOption(text: "Wish for a future together", nextPageIndex: 19),
                StoryOption(text: "Wish for this night to last", nextPageIndex: 20)
            ]),
            StoryPage(imageName: "storyline3_10", narrationText: "The star disappears as quickly as it came. Yuki closes her eyes tight. 'I wished for something important,' she says, blushing.", questionText: "Ask what it was?", options: [
                StoryOption(text: "Tell me your wish", nextPageIndex: 19),
                StoryOption(text: "I think I know what it was", nextPageIndex: 20)
            ]),
            
            // 19-20: The Walk Back (Merging)
            StoryPage(imageName: "storyline3_11", narrationText: "The fire at the camp has completely gone out now. You begin the walk back, hand in hand. The forest feels different now—less scary, more magical.", questionText: "Walk slowly?", options: [
                StoryOption(text: "Take the long way back", nextPageIndex: 21),
                StoryOption(text: "Enjoy the silence", nextPageIndex: 22)
            ]),
            StoryPage(imageName: "storyline3_11", narrationText: "You pass the old oak tree where you first met. Yuki stops for a second. 'Everything is about to change, isn't it?' she asks softly.", questionText: "Comfort her?", options: [
                StoryOption(text: "Change can be good", nextPageIndex: 21),
                StoryOption(text: "Not everything has to change", nextPageIndex: 22)
            ]),
            
            // 21-22: Near the Cabins (Merging)
            StoryPage(imageName: "storyline3_12", narrationText: "The camp cabins are in sight. The other campers are asleep. Yuki stops at her door. She doesn't want to let go of your hand.", questionText: "One last thing?", options: [
                StoryOption(text: "Ask for a final kiss", nextPageIndex: 23),
                StoryOption(text: "Ask for her phone number", nextPageIndex: 24)
            ]),
            StoryPage(imageName: "storyline3_12", narrationText: "Yuki lingers in the doorway. The porch light casts a soft glow on her face. 'Thank you for tonight. It was the best night of my life.'", questionText: "Say goodbye?", options: [
                StoryOption(text: "See you in the morning", nextPageIndex: 23),
                StoryOption(text: "Goodnight, Yuki", nextPageIndex: 24)
            ]),
            
            // 23-24: The Morning After (Merging)
            StoryPage(imageName: "storyline3_13", narrationText: "Sunrise. The camp is bustling with people packing bags and boarding buses. You look for Yuki in the crowd, your heart racing.", questionText: "Can you find her?", options: [
                StoryOption(text: "Look by the bus", nextPageIndex: 25),
                StoryOption(text: "Check the pier one last time", nextPageIndex: 26)
            ]),
            StoryPage(imageName: "storyline3_13", narrationText: "The engines of the buses are humming. You see her! She's standing by the gate, looking around frantically until she sees you.", questionText: "Run to her?", options: [
                StoryOption(text: "Run and hug her", nextPageIndex: 25),
                StoryOption(text: "Wave and smile", nextPageIndex: 26)
            ]),
            
            // 25-26: The Final Vow (Merging)
            StoryPage(imageName: "storyline3_14", narrationText: "You reach her just in time. She whispers something in your ear that you'll never forget. 'Don't let this be just a summer memory.'", questionText: "Give your answer?", options: [
                StoryOption(text: "It's a promise", nextPageIndex: 27),
                StoryOption(text: "I'll see you next weekend", nextPageIndex: 28)
            ]),
            StoryPage(imageName: "storyline3_14", narrationText: "The bus driver honks. Yuki has to go. She blows you a kiss as she steps up. You stand there, watching the bus disappear into the dust.", questionText: "How do you feel?", options: [
                StoryOption(text: "Happy and hopeful", nextPageIndex: 27),
                StoryOption(text: "Sad but satisfied", nextPageIndex: 28)
            ]),
            
            // 27-28: Epilogue / Finale
            StoryPage(imageName: "storyline3_15", narrationText: "Months later. You're in the city, and your phone buzzes. It's a photo from Yuki—she's wearing the bracelet you shared. Summer never really ended.", questionText: "The End. Good Ending.", options: [
                StoryOption(text: "Restart Story", nextPageIndex: 0),
                StoryOption(text: "Finish", nextPageIndex: -1)
            ]),
            StoryPage(imageName: "storyline3_15", narrationText: "You look at the bracelet on your wrist. It's a bit worn out, but the memories are fresh. Sometimes, one summer is enough to last a lifetime.", questionText: "The End. Bitter-Sweet Ending.", options: [
                StoryOption(text: "Try Again", nextPageIndex: 0),
                StoryOption(text: "Finish", nextPageIndex: -1)
            ])
        ]

        stories = [
            Storyline(title: "StoryTitle1".localize(), pages: maidPages),
            Storyline(title: "StoryTitle2".localize(), pages: tokyoPages),
            Storyline(title: "StoryTitle3".localize(), pages: summerPages)
        ]
    }
}
