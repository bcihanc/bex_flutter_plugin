class BexPosResult {
  final String? posMessage;
  final String? md;
  final String? signature;
  final String? timestamp;
  final String? token;
  final String? xid;

  BexPosResult(this.posMessage, this.md, this.signature, this.timestamp,
      this.token, this.xid);

  BexPosResult.fromJson(Map<dynamic, dynamic> json)
      : posMessage = json['posMessage'],
        md = json['md'],
        signature = json['signature'],
        timestamp = json['timestamp'],
        token = json['token'],
        xid = json['xid'];
}