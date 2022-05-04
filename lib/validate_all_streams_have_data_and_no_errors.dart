import 'dart:async';


//from didier boelens
//see https://www.didierboelens.com/2020/01/form-validation-using-combinelatest-might-give-false-positives/
class ValidateAllStreamsHaveDataAndNoErrors {
  //
  // Array the memorizes the validation "result" of each stream
  //
  List<bool>? errors;
 
  //
  // Stream which emits the actual validation result, combining
  // all the streams involved in the validation
  //
  StreamController<bool>? _controller;
 
  //
  // Method which initializes the validation
  //
  void listen(List<Stream> streams){
    
    //
    //  Initialization of the internal Stream controller
    //
    _controller = StreamController<bool>.broadcast();

    //
    // Initialization of the array that memorizes the errors
    //
    errors = List.generate(streams.length, (_) => true);
    
    //
    // For each of the streams to be considered, listen
    // to the type of information they are going to emit
    //
    List.generate(streams.length, (int index) {
      return streams[index].listen(
      (data){
        // Data was emitted => this is not an error
        errors![index] = false;
        _validate();
      },
      onError: (_){
        // Error was emitted
        errors![index] = true;
        _validate();
      },
    );
    });
  }
 
  //
  // Routine which simply checks whether there is still at least one
  // stream which does not satisfy the validation
  // Depending on this check, emits a positive or negative validation outcome
  // 
  void _validate() {
    bool hasNoErrors = (errors!.firstWhere((b) => b == true, orElse: () => false) == false);
    _controller!.sink.add(hasNoErrors);
  }

  //
  // Public outcome of the validation
  //
  Stream<bool> get status => _controller!.stream;

  void dispose(){
    _controller?.close();
  }
}