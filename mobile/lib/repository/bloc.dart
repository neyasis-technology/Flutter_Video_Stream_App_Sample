import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

abstract class BlocRepository<RequestObject, ResultObject> {
  RequestObject? _requestObject;
  bool _isBlocHandling = false;
  ResultObject? _store;

  // ignore: close_sinks
  final PublishSubject<ResultObject?> _fetcher = PublishSubject<ResultObject?>();
  Uuid _uuidGenerator = new Uuid();
  String _lastRequestUniqueId = "";
  Function(ResultObject?)? _listener;

  PublishSubject<ResultObject?> get fetcher => this._fetcher;

  Stream<ResultObject?> get stream => _fetcher.stream;

  ResultObject? get store => this._store;

  // String get lastRequestUniqueId => this._lastRequestUniqueId;

  bool get isBlocHandling => this._isBlocHandling;

  RequestObject? get requestObject => this._requestObject;

  void setStore(ResultObject? store) => this._store = store;

  void clearRequestObject() => this._requestObject = null;

  void clearStore() {
    this._store = null;
    this.fetcher.sink.addError(-1);
  }

  Future prevProcess() async {
    this._lastRequestUniqueId = this._uuidGenerator.v4();
    await process(this._lastRequestUniqueId);
    this._isBlocHandling = false;
  }

  Future process(String lastRequestUniqueId);

  void call({RequestObject? requestObject, bool sinkNullObject = false}) {
    this._isBlocHandling = true;
    this._requestObject = requestObject;
    if (sinkNullObject) this.fetcher.sink.addError(-1);
    this.prevProcess();
  }

  void fetcherSink(ResultObject? resultObject, {bool forceSink = false, required lastRequestUniqueId}) {
    if ((forceSink != null && forceSink) || lastRequestUniqueId == this._lastRequestUniqueId) {
      this._store = resultObject;
      if (resultObject == null)
        this.fetcher.sink.addError(-1);
      else
        this.fetcher.sink.add(resultObject);
      if (this._listener != null) this._listener!(resultObject);
    } else {
//      print("this request is old request" + ResultObject.toString());
    }
  }

  void setListener(Function(ResultObject?) listener) => this._listener = listener;

  dispose() {
    this._fetcher.close();
  }
}
