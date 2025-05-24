class Welcome {
    final List<Resp> resp;
    final String status;
    final String err;

    Welcome({
        required this.resp,
        required this.status,
        required this.err,
    });

}

class Resp {
    final int bankId;
    final String bankName;
    final String branchName;
    final String ifscCode;
    final String address;
    final String createdby;
    final String updatedby;
    final DateTime createdDate;
    final DateTime updatedDate;

    Resp({
        required this.bankId,
        required this.bankName,
        required this.branchName,
        required this.ifscCode,
        required this.address,
        required this.createdby,
        required this.updatedby,
        required this.createdDate,
        required this.updatedDate,
    });

}
