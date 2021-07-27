class Data<T> {
  List<T>? data;
  String? error;

  Data(this.data);
  Data.withError(this.error);
}
