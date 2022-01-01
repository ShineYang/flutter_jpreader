class ChannelEvent {
  int code= -1;
  String desc = "";
  String? data;

  ChannelEvent({required this.code, required this.desc, required this.data});

  ChannelEvent.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    desc = json['desc'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['desc'] = this.desc;
    data['data'] = this.data;
    return data;
  }
}