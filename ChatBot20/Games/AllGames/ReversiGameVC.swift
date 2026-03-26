import UIKit
import SnapKit

class ReversiGameVC: BaseGameViewController {
    
    // MARK: - State
    enum Piece: Int {
        case user = 1    // White
        case waifu = 2   // Blue
    }
    
    private let gridSize = 8
    private var board: [[Piece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    private var cells: [[UIButton]] = []
    private var isGameOver = false
    private var isUserTurn = true
    
    // AI Difficulty Settings
    private var aiDepth = 1
    
    // UI Elements
    private let currentScoreLabel = UILabel()
    private let boardContainer = UIView()
    
    // Матрица весов (НЕ ТРОГАЛ)
    private let positionWeights: [[Int]] = [
        [100, -20, 10,  5,  5, 10, -20, 100],
        [-20, -50, -2, -2, -2, -2, -50, -20],
        [ 10,  -2,  5,  1,  1,  5,  -2,  10],
        [  5,  -2,  1,  5,  5,  1,  -2,   5],
        [  5,  -2,  1,  5,  5,  1,  -2,   5],
        [ 10,  -2,  5,  1,  1,  5,  -2,  10],
        [-20, -50, -2, -2, -2, -2, -50, -20],
        [100, -20, 10,  5,  5, 10, -20, 100]
    ]

    override var gameRules: String {
        "reversi.rules".localize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameUI()
        loadProgress()
        updateDifficultyBasedOnScore()
        startNewGame(isFirstGame: true)
    }
    
    // MARK: - Restore User Score Logic (НЕ ТРОГАЛ)
    override func updateScore(waifu: Int, user: Int) {
        super.updateScore(waifu: waifu, user: user)
        
        // Обновляем сложность
        updateDifficultyBasedOnScore()

        let imageName: String
        switch userScore {
        case 0: imageName = "roleplay11_1"
        case 1: imageName = "CGameGirls1"
        case 2: imageName = "CGameGirls2"
        case 3: imageName = "CGameGirls3"
        case 4: imageName = "CGameGirls4"
        case 5: imageName = "CGameGirls5"
        case 6: imageName = "CGameGirls6"
        case 7: imageName = "CGameGirls7"
        case 8: imageName = "CGameGirls8"
        case 9: imageName = "CGameGirls9"
        case 10...:
            let suffix = (userScore % 2 == 0) ? "8" : "9"
            imageName = "CGameGirls\(suffix)"
        default:
            imageName = "AGameGirls8"
        }

        guard ConfigService.shared.isTestB else {
            self.waifuImageView.image = UIImage(named: "roleplay11_1")
            return
        }
        UIView.animate(withDuration: 1) {
            self.waifuImageView.image = UIImage(named: imageName)
        }
    }
    
    override func didResetProgress() {
        updateDifficultyBasedOnScore()
        startNewGame(isFirstGame: false)
    }
    
    private func updateDifficultyBasedOnScore() {
        switch userScore {
        case 0: aiDepth = 1 // Но по факту будет рандом (см. логику выше)
        case 1: aiDepth = 1 // Будет Greedy-алгоритм
        case 2: aiDepth = 2 // Начинает думать по матрице весов
        case 3: aiDepth = 3 // Глубже
        default: aiDepth = 4 // Максимальный уровень
        }
    }

    // MARK: - UI Setup
    private func setupGameUI() {
        currentScoreLabel.font = .systemFont(ofSize: 22, weight: .bold)
        currentScoreLabel.textColor = .white
        currentScoreLabel.textAlignment = .center
        currentScoreLabel.layer.shadowColor = UIColor.black.cgColor
        currentScoreLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        currentScoreLabel.layer.shadowOpacity = 0.5
        currentScoreLabel.layer.shadowRadius = 2
        
        gameContainerView.addSubview(currentScoreLabel)
        
        currentScoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        boardContainer.backgroundColor = TelegramColors.bubbleBackground
        boardContainer.layer.cornerRadius = 12
        boardContainer.clipsToBounds = true
        gameContainerView.addSubview(boardContainer)
        
        boardContainer.snp.makeConstraints { make in
            make.top.equalTo(currentScoreLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(min(view.frame.width - 32, 360))
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 2
        boardContainer.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        for r in 0..<gridSize {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 2
            mainStack.addArrangedSubview(rowStack)
            
            var rowButtons: [UIButton] = []
            for c in 0..<gridSize {
                let btn = UIButton()
                btn.backgroundColor = TelegramColors.cardBackground
                btn.tag = r * 10 + c
                btn.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
                
                // Фишка
                let chip = UIView()
                chip.isUserInteractionEnabled = false
                chip.layer.cornerRadius = (min(view.frame.width - 32, 360) / CGFloat(gridSize * 2)) - 6
                chip.tag = 999
                chip.alpha = 0
                btn.addSubview(chip)
                chip.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(5)
                }
                
                // Подсказка
                let hint = UIView()
                hint.isUserInteractionEnabled = false
                hint.backgroundColor = TelegramColors.primary.withAlphaComponent(0.4)
                hint.layer.cornerRadius = 5
                hint.tag = 888
                hint.isHidden = true
                btn.addSubview(hint)
                hint.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.height.equalTo(10)
                }
                
                rowStack.addArrangedSubview(btn)
                rowButtons.append(btn)
            }
            cells.append(rowButtons)
        }
    }

    private func startNewGame(isFirstGame: Bool) {
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        isGameOver = false
        isUserTurn = true
        
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                let cell = cells[r][c]
                cell.viewWithTag(999)?.alpha = 0
                cell.viewWithTag(999)?.transform = .identity
                cell.viewWithTag(888)?.isHidden = true
            }
        }
        
        setInitialPiece(row: 3, col: 3, piece: .waifu)
        setInitialPiece(row: 3, col: 4, piece: .user)
        setInitialPiece(row: 4, col: 3, piece: .user)
        setInitialPiece(row: 4, col: 4, piece: .waifu)
        
        if !isFirstGame {
            setWaifuMessage("reversi.start".localize())
        }
        updateUI()
    }

    private func setInitialPiece(row: Int, col: Int, piece: Piece) {
        board[row][col] = piece
        let chip = cells[row][col].viewWithTag(999)
        chip?.alpha = 1
        chip?.backgroundColor = (piece == .user) ? .white : TelegramColors.primary
    }

    @objc private func cellTapped(_ sender: UIButton) {
        guard isUserTurn, !isGameOver else { return }
        let r = sender.tag / 10
        let c = sender.tag % 10
        
        if canPlace(board: board, row: r, col: c, piece: .user) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            hideAllHints()
            applyMove(row: r, col: c, piece: .user)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            setWaifuMessage("reversi.invalidMove".localize())
        }
    }

    private func applyMove(row: Int, col: Int, piece: Piece) {
        board[row][col] = piece
        animateNewPiece(row: row, col: col, piece: piece)
        
        let toFlip = getFlippablePieces(board: board, row: row, col: col, piece: piece)
        
        // Волна переворотов
        for (index, pos) in toFlip.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                self.board[pos.0][pos.1] = piece
                self.flipAnimation(row: pos.0, col: pos.1, newPiece: piece)
            }
        }
        
        // Задержка перед передачей хода, чтобы анимации успели проиграться
        let totalDelay = Double(toFlip.count) * 0.05 + 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            self.finalizeTurn(after: piece)
        }
    }

    // ИСПРАВЛЕННАЯ ЛОГИКА ПЕРЕДАЧИ ХОДА (FIX DEADLOCK)
    private func finalizeTurn(after currentPiece: Piece) {
        guard !isGameOver else { return }
        
        let nextPlayer: Piece = (currentPiece == .user) ? .waifu : .user
        
        // 1. Проверяем, может ли ходить следующий игрок
        if hasMoves(for: nextPlayer, on: board) {
            isUserTurn = (nextPlayer == .user)
            updateUI()
            
            if !isUserTurn {
                // Ход ИИ
                setWaifuMessage("reversi.waifuThinking".localize())
                runAI()
            } else {
                // Ход Юзера
                setWaifuMessage("reversi.yourTurn".localize())
            }
        }
        // 2. Если у следующего игрока НЕТ ходов (ПАС)
        else {
            // Проверяем, остались ли ходы у текущего игрока (чтобы ходить повторно)
            if hasMoves(for: currentPiece, on: board) {
                setWaifuMessage("reversi.noMoves".localize())
                
                // Ход остается у того же игрока
                isUserTurn = (currentPiece == .user)
                updateUI()
                
                if !isUserTurn {
                    // ИИ ходит снова
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.runAI()
                    }
                }
            }
            // 3. Если ни у кого нет ходов - Конец Игры
            else {
                checkEndGame()
            }
        }
    }
    
    private func runAI() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Гарантируем актуальность сложности
            self.updateDifficultyBasedOnScore()
            let bestMove = self.getBestMoveMinimax()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let move = bestMove {
                    self.applyMove(row: move.0, col: move.1, piece: .waifu)
                } else {
                    // Страховка на случай рассинхрона hasMoves и реального AI
                    self.finalizeTurn(after: .waifu)
                }
            }
        }
    }

    // MARK: - Smart AI (Minimax) - Logic preserved
    private struct MoveScore {
        let r: Int; let c: Int; let score: Int
    }
    
    // MARK: - Smart AI (Minimax) - Progressive Difficulty
    private func getBestMoveMinimax() -> (Int, Int)? {
        let validMoves = getAllValidMoves(for: .waifu, on: board)
        if validMoves.isEmpty { return nil }
        
        // ОБНОВЛЕННАЯ ЛОГИКА СЛОЖНОСТИ
        switch userScore {
        case 0:
            // УРОВЕНЬ 0: Полный рандом. Вайфу поддается.
            return validMoves.randomElement()
            
        case 1:
            // УРОВЕНЬ 1: Жадность (Greedy). Берем ход с макс. количеством переворотов.
            // Игнорируем матрицу весов, просто "едим" как можно больше.
            var bestM = validMoves[0]
            var maxFlips = -1
            for move in validMoves {
                let flips = getFlippablePieces(board: board, row: move.0, col: move.1, piece: .waifu).count
                if flips > maxFlips {
                    maxFlips = flips
                    bestM = move
                }
            }
            return bestM
            
        default:
            // УРОВЕНЬ 2+: Minimax с матрицей весов
            var bestScore = Int.min
            var bestMove = validMoves[0]
            let alpha = Int.min
            let beta = Int.max
            
            // Сортируем ходы, чтобы сначала проверять углы (оптимизация)
            let sortedMoves = validMoves.sorted {
                positionWeights[$0.0][$0.1] > positionWeights[$1.0][$1.1]
            }
            
            for move in sortedMoves {
                var tempBoard = board
                tempBoard[move.0][move.1] = .waifu
                let flippable = getFlippablePieces(board: tempBoard, row: move.0, col: move.1, piece: .waifu)
                for pos in flippable { tempBoard[pos.0][pos.1] = .waifu }
                
                let score = minimax(board: tempBoard, depth: aiDepth - 1, alpha: alpha, beta: beta, maximizingPlayer: false)
                if score > bestScore {
                    bestScore = score
                    bestMove = move
                }
            }
            return bestMove
        }
    }
    
    private func minimax(board: [[Piece?]], depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> Int {
        if depth == 0 { return evaluateBoard(board) }
        
        var currentAlpha = alpha
        var currentBeta = beta
        
        if maximizingPlayer {
            let moves = getAllValidMoves(for: .waifu, on: board)
            if moves.isEmpty {
                return minimax(board: board, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false)
            }
            var maxEval = Int.min
            for move in moves {
                var tempBoard = board
                tempBoard[move.0][move.1] = .waifu
                let toFlip = getFlippablePieces(board: tempBoard, row: move.0, col: move.1, piece: .waifu)
                for pos in toFlip { tempBoard[pos.0][pos.1] = .waifu }
                
                let eval = minimax(board: tempBoard, depth: depth - 1, alpha: currentAlpha, beta: currentBeta, maximizingPlayer: false)
                maxEval = max(maxEval, eval)
                currentAlpha = max(currentAlpha, eval)
                if currentBeta <= currentAlpha { break }
            }
            return maxEval
        } else {
            let moves = getAllValidMoves(for: .user, on: board)
            if moves.isEmpty {
                return minimax(board: board, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true)
            }
            var minEval = Int.max
            for move in moves {
                var tempBoard = board
                tempBoard[move.0][move.1] = .user
                let toFlip = getFlippablePieces(board: tempBoard, row: move.0, col: move.1, piece: .user)
                for pos in toFlip { tempBoard[pos.0][pos.1] = .user }
                
                let eval = minimax(board: tempBoard, depth: depth - 1, alpha: currentAlpha, beta: currentBeta, maximizingPlayer: true)
                minEval = min(minEval, eval)
                currentBeta = min(currentBeta, eval)
                if currentBeta <= currentAlpha { break }
            }
            return minEval
        }
    }
    
    private func evaluateBoard(_ b: [[Piece?]]) -> Int {
        var score = 0
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                if let p = b[r][c] {
                    let val = positionWeights[r][c]
                    if p == .waifu { score += val } else { score -= val }
                }
            }
        }
        return score
    }

    // MARK: - Helper Logic
    private func hideAllHints() {
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                cells[r][c].viewWithTag(888)?.isHidden = true
            }
        }
    }
    
    private func updateUI() {
        let flatBoard = board.flatMap { $0 }
        let uCount = flatBoard.filter { $0 == .user }.count
        let wCount = flatBoard.filter { $0 == .waifu }.count
        currentScoreLabel.text = "⚪️ \(uCount)   vs   🔵 \(wCount)"
        
        if isUserTurn && !isGameOver {
            let validMoves = getAllValidMoves(for: .user, on: board)
            hideAllHints()
            for move in validMoves {
                cells[move.0][move.1].viewWithTag(888)?.isHidden = false
            }
        } else {
            hideAllHints()
        }
    }

    private func getFlippablePieces(board: [[Piece?]], row: Int, col: Int, piece: Piece) -> [(Int, Int)] {
        var toFlip: [(Int, Int)] = []
        let directions = [(0,1),(0,-1),(1,0),(-1,0),(1,1),(-1,-1),(1,-1),(-1,1)]
        
        for dir in directions {
            var r = row + dir.0
            var c = col + dir.1
            var potential: [(Int, Int)] = []
            
            while r >= 0 && r < gridSize && c >= 0 && c < gridSize, let current = board[r][c], current != piece {
                potential.append((r, c))
                r += dir.0
                c += dir.1
            }
            
            if r >= 0 && r < gridSize && c >= 0 && c < gridSize, board[r][c] == piece {
                toFlip.append(contentsOf: potential)
            }
        }
        return toFlip
    }

    private func canPlace(board: [[Piece?]], row: Int, col: Int, piece: Piece) -> Bool {
        if board[row][col] != nil { return false }
        return !getFlippablePieces(board: board, row: row, col: col, piece: piece).isEmpty
    }

    private func hasMoves(for piece: Piece, on board: [[Piece?]]) -> Bool {
        return !getAllValidMoves(for: piece, on: board).isEmpty
    }

    private func getAllValidMoves(for piece: Piece, on board: [[Piece?]]) -> [(Int, Int)] {
        var moves: [(Int, Int)] = []
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                if canPlace(board: board, row: r, col: c, piece: piece) { moves.append((r, c)) }
            }
        }
        return moves
    }

    private func checkEndGame() {
        isGameOver = true
        updateUI()
        
        let flatBoard = board.flatMap { $0 }
        let uCount = flatBoard.filter { $0 == .user }.count
        let wCount = flatBoard.filter { $0 == .waifu }.count
        
        if uCount > wCount {
            userScore += 1
            setWaifuMessage("reversi.win".localize())
        } else if wCount > uCount {
            waifuScore += 1
            setWaifuMessage("reversi.lose".localize())
        } else {
            setWaifuMessage("reversi.draw".localize())
        }
        
        updateScore(waifu: waifuScore, user: userScore)
        showRestartButton()
    }

    private func showRestartButton() {
        let btn = UIButton(type: .system)
        btn.setTitle("reversi.restart".localize(), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.tintColor = .white
        btn.backgroundColor = TelegramColors.primary
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        
        gameContainerView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(boardContainer.snp.bottom).inset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func restartTapped(sender: UIButton) {
        sender.removeFromSuperview()
        startNewGame(isFirstGame: false)
    }
    
    // MARK: - New Professional Animations
    
    private func flipAnimation(row: Int, col: Int, newPiece: Piece) {
        guard let chip = cells[row][col].viewWithTag(999) else { return }
        
        // 1. Сжимаем фишку до линии (имитация поворота боком)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            chip.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
        }) { _ in
            // 2. Меняем цвет в момент "невидимости"
            chip.backgroundColor = (newPiece == .user) ? .white : TelegramColors.primary
            
            // 3. Разжимаем обратно с легким эффектом пружины
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                chip.transform = .identity
            }, completion: nil)
        }
    }
    
    private func animateNewPiece(row: Int, col: Int, piece: Piece) {
        let chip = cells[row][col].viewWithTag(999)
        chip?.backgroundColor = (piece == .user) ? .white : TelegramColors.primary
        chip?.alpha = 1
        // Стартуем с маленького размера
        chip?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        // Эффект удара об доску (Pop-up)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            chip?.transform = .identity
        })
    }
}
