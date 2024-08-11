import 'package:flutter/material.dart';
import 'dart:math';

class Move {
  final int row;
  final int col;
  Move(this.row, this.col);
}

int evaluateBoard(List<List<int>> board) {
  int score = 0;
  for (int row = 0; row < board.length; row++) {
    for (int col = 0; col < board[row].length; col++) {
      if (board[row][col] == 2) {
        score++; // AI's piece
      } else if (board[row][col] == 1) {
        score--; // Player's piece
      }
    }
  }
  return score;
}

bool isAdjacent(List<List<int>> board, int row, int col, int player) {
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (row + i >= 0 &&
          row + i < board.length &&
          col + j >= 0 &&
          col + j < board[row].length) {
        if (board[row + i][col + j] == player) {
          return true;
        }
      }
    }
  }
  return false;
}

bool isGameOver(List<List<int>> board) {
  for (var row in board) {
    for (var cell in row) {
      if (cell == 0) return false;
    }
  }
  return true;
}

int minimax(
    List<List<int>> board, int depth, bool isMaximizing, int alpha, int beta) {
  int score = evaluateBoard(board);
  if (depth == 0 || isGameOver(board)) {
    return score;
  }
  if (isMaximizing) {
    int bestScore = -1000;
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0 && isAdjacent(board, row, col, 2)) {
          board[row][col] = 2;
          bestScore =
              max(bestScore, minimax(board, depth - 1, false, alpha, beta));
          board[row][col] = 0;
          alpha = max(alpha, bestScore);
          if (beta <= alpha) break;
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0 && isAdjacent(board, row, col, 1)) {
          board[row][col] = 1;
          bestScore =
              min(bestScore, minimax(board, depth - 1, true, alpha, beta));
          board[row][col] = 0;
          beta = min(beta, bestScore);
          if (beta <= alpha) break;
        }
      }
    }
    return bestScore;
  }
}

// Move findBestMove(List<List<int>> board, int movnumber) {
//   int bestScore = -1000;
//   Move bestMove = Move(-1, -1);
//   bool hasValidMove = false;
//   for (int row = 0; row < board.length; row++) {
//     for (int col = 0; col < board[row].length; col++) {
//       // ... (existing code for checking empty cell and valid adjacent AI piece)
//       if (board[row][col] == 0 && movnumber == 1 ||
//           board[row][col] == 0 && isAdjacent(board, row, col, 2)) {
//         board[row][col] = 2;
//         int moveScore = minimax(board, 6, false, -1000, 1000);
//         board[row][col] = 0;

//         if (moveScore > bestScore) {
//           bestMove = Move(row, col);
//           bestScore = moveScore;
//           hasValidMove = true;
//         }
//       }
//     }
//   }

//   // if (hasValidMove) {
//   //   print("${bestMove.row},${bestMove.col}");
//   //   // You can return a special move object here to indicate deadlock (optional)
//   // }

//   return bestMove;
// }
Move findBestMove(List<List<int>> board, int movnumber) {
  int bestScore = -1000;
  Move bestMove = Move(-1, -1);
  bool hasValidMove = false;

  // Perform Iterative Deepening with a maximum depth limit
  for (int depth = 1; depth <= 6; depth++) {
    // Adjust maximum depth as needed
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0 && movnumber == 1 || // Initial move condition
            board[row][col] == 0 && isAdjacent(board, row, col, 2)) {
          // Valid adjacent AI piece condition
          board[row][col] = 2;
          int moveScore = alphaBeta(board, depth, -1000, 1000, false);
          board[row][col] = 0;

          if (moveScore > bestScore) {
            bestMove = Move(row, col);
            bestScore = moveScore;
            hasValidMove = true;
          }
        }
      }
    }

    // Check if time limit is exceeded, adjust as per requirement
    // if (time exceeds limit) break;
  }

  // if (hasValidMove) {
  //   print("${bestMove.row},${bestMove.col}");
  //   // You can return a special move object here to indicate deadlock (optional)
  // }

  return bestMove;
}

int alphaBeta(
    List<List<int>> board, int depth, int alpha, int beta, bool isMaximizing) {
  if (depth == 0 || isGameOver(board)) {
    return evaluateBoard(board);
  }

  if (isMaximizing) {
    int maxScore = -1000;
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0 && isAdjacent(board, row, col, 2)) {
          board[row][col] = 2;
          int score = alphaBeta(board, depth - 1, alpha, beta, false);
          board[row][col] = 0;
          maxScore = max(maxScore, score);
          alpha = max(alpha, score);
          if (beta <= alpha) {
            break; // Beta cutoff
          }
        }
      }
    }
    return maxScore;
  } else {
    int minScore = 1000;
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0 && isAdjacent(board, row, col, 1)) {
          board[row][col] = 1;
          int score = alphaBeta(board, depth - 1, alpha, beta, true);
          board[row][col] = 0;
          minScore = min(minScore, score);
          beta = min(beta, score);
          if (beta <= alpha) {
            break; // Alpha cutoff
          }
        }
      }
    }
    return minScore;
  }
}
