class ChannelDetailModel {
  String channelName, type;
  bool isAvailable;

  ChannelDetailModel(this.isAvailable, this.channelName, this.type);

  factory ChannelDetailModel.fromJson(Map<String, dynamic> json) =>
      ChannelDetailModel(
        json["isAvailable"] == null ? "" : json["isAvailable"],
        json["channelName"] == null ? "" : json["channelName"],
        json["type"] == null ? "" : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "isAvailable": isAvailable,
        "channelName": channelName,
        "type": type,
      };
}
