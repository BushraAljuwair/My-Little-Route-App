import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/user/user_model.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  List<StudentsModel>? studens;
    List<UserModel>? drivers;

  StudentBloc() : super(StudentInitial()) {
    on<StudentEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetStudentsEvent>(getStudentsMethod);
  }

  FutureOr<void> getStudentsMethod(
    GetStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(LoadingState());
    try {
      studens = await appGetit.getStudens();
      drivers=await appGetit.getDrivers();
      for (var i in studens!) {
        log(i.toString());
      }
      
      emit(SuccessState());
    } catch (e) {
      log("error in boc $e");
      emit(ErrorState(message: e.toString()));
    }
  }
}
