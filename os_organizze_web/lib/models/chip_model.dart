class ChipModel {
  String? chipId;
  String? chipIccid;
  String? chipCompany;
  String? chipApn;
  int? chipStatus;
  DateTime? addAt;
  DateTime? linkedAt;
  DateTime? chipWithAt;
  String? linkedBy;
  String? linkedIn;
  String? cancelledBy;
  DateTime? cancelledAt;
  String? chipWith;

  ChipModel(
      {this.chipId,
      this.chipIccid,
      this.chipCompany,
      this.chipApn,
      this.chipStatus,
      this.addAt,
      this.linkedAt,
      this.chipWithAt,
      this.linkedBy,
      this.linkedIn,
      this.cancelledBy,
      this.cancelledAt,
      this.chipWith});

  ChipModel.fromJson(Map<String, dynamic> json) {
    chipId = json['chip_id'];
    chipIccid = json['chip_iccid'];
    chipCompany = json['chip_company'];
    chipApn = json['chip_apn'];
    chipStatus = json['chip_status'];
    addAt = DateTime.tryParse(json['add_at']);
    linkedAt = DateTime.tryParse(json['linked_at']);
    chipWithAt = DateTime.tryParse(json['chip_with_at']);
    linkedBy = json['linked_by'];
    linkedIn = json['linked_in'];
    cancelledBy = json['cancelled_by'];
    cancelledAt = DateTime.tryParse(json['cancelled_at']);
    chipWith = json['chip_with'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chip_id'] = chipId;
    data['chip_iccid'] = chipIccid;
    data['chip_company'] = chipCompany;
    data['chip_apn'] = chipApn;
    data['chip_status'] = chipStatus;
    data['add_at'] = addAt;
    data['linked_at'] = linkedAt;
    data['chip_with_at'] = chipWithAt;
    data['linked_by'] = linkedBy;
    data['linked_in'] = linkedIn;
    data['cancelled_by'] = cancelledBy;
    data['cancelled_at'] = cancelledAt;
    data['chip_with'] = chipWith;
    return data;
  }
}
