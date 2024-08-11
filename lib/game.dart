import 'package:flutter/material.dart';
import 'dart:math';

class Game {
  final int gridSize;
  late List<List<int>> grid;
  late bool playerTurn;
  int playerCount = 0;
  int aiCount = 0;
  Game({this.gridSize = 8}) {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    playerTurn = true; // true for player, false for AI
  }

  bool isCellEmpty(int row, int col) {
    return grid[row][col] == 0;
  }

  bool isAdjacent(int row, int col, int player) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (row + i >= 0 &&
            row + i < gridSize &&
            col + j >= 0 &&
            col + j < gridSize) {
          if (grid[row + i][col + j] == player) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void placePiece(int row, int col, int player) {
    if (isCellEmpty(row, col)) {
      grid[row][col] = player;
      captureAdjacent(row, col, player);
      playerTurn = !playerTurn; // Switch turn
    }
  }

  void captureAdjacent(int row, int col, int player) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (row + i >= 0 &&
            row + i < gridSize &&
            col + j >= 0 &&
            col + j < gridSize) {
          if (grid[row + i][col + j] != player && grid[row + i][col + j] != 0) {
            grid[row + i][col + j] = player;
          }
        }
      }
    }
    playerCount = 0;
    aiCount = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (cell == 1) playerCount++;
        if (cell == 2) aiCount++;
      }
    }
  }

  bool isGameOver() {
    for (var row in grid) {
      for (var cell in row) {
        if (cell == 0) return false;
      }
    }
    return true;
  }

  int getWinner() {
    int playerCount = 0;
    int aiCount = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (cell == 1) playerCount++;
        if (cell == 2) aiCount++;
      }
    }
    return playerCount > aiCount ? 1 : 2;
  }
}
