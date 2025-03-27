class DynamicAudioPlayerHandler{
  final bool canScrub;
  final bool required;
  final String audioUrl;
  bool isOver;
  final String name;

  DynamicAudioPlayerHandler({
    this.required = false,
    this.canScrub = false,
    required this.audioUrl,
    required this.name,
    this.isOver = false,
  });

  void setIsAudioOver({
    required bool isPlayed,
  }) {
    isOver = isPlayed;
  }

  List<Map<String, dynamic>> formFieldData() {
    return !isOver
        ? []
        : [
            {
              "name": name,
              "value": isOver,
            }
          ];
  }
}
