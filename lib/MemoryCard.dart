class MemoryCard {
  final int id;
  final String imagePath;
  bool isFaceUp;
  bool isMatched;
  MemoryCard({
    required this.id,
    required this.imagePath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
