class ChannelEvent {
  // SEND_ANALYZE_CODE = 0
  // NEED_UPDATE_EVENT_CODE = 1
  int code = 0;
  String desc  = "";
  String? data;

  ChannelEvent(this.code, this.desc, this.data);
}