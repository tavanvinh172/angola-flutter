extension ConvertStatus on String {
  StatusEnum toEnum() {
    switch (this) {
      case 'audio':
        return StatusEnum.audio;
      case 'text':
        return StatusEnum.text;
      case 'image':
        return StatusEnum.image;
      case 'video':
        return StatusEnum.video;
      case 'gif':
        return StatusEnum.gif;
      default:
        return StatusEnum.text;
    }
  }
}

enum StatusEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const StatusEnum(this.type);
  final String type;
}
