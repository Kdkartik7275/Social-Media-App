enum MessagesType {
  text('text'),
  image("image"),
  video("video"),
  audio("audio"),
  gif("gif");

  const MessagesType(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessagesType toEnum() {
    switch (this) {
      case 'audio':
        return MessagesType.audio;
      case 'text':
        return MessagesType.text;
      case 'image':
        return MessagesType.image;
      case 'video':
        return MessagesType.video;
      case 'gif':
        return MessagesType.gif;
      default:
        return MessagesType.text;
    }
  }
}
