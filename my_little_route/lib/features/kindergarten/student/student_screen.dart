import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/kindergarten/bus/widgets/listtile/custom_bus_listtile.dart';
import 'package:my_little_route/features/kindergarten/home/widgets/text/custom_text.dart';
import 'package:my_little_route/features/kindergarten/student/bloc/student_bloc.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/style/style_size.dart';
 

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc()..add((GetStudentsEvent())),
      child: Builder(
        builder: (context) {
          final bloc = context.read<StudentBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("BusScreen")),
            body: SafeArea(
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Center(child: Text("loading"));
                  }
                  if (state is SuccessState) {
                    return Column(
                      children: [
                        CustomText(title:"StudentManagement"),
                        StyleSize.sizeH24,
                        Expanded(
                          child: ListView.builder(
                            itemCount: bloc.studens!.length,
                            itemBuilder: (context, index) {
                              StudentsModel? student = bloc.studens![index];
                               UserModel driver=bloc.drivers!.firstWhere((driver)=>driver.id==student.driverId);
                              return CustomBusListtile(
                                gender:student.gender ,
                                onEdit: () {},
                                onViewDetails: () {},
                                leadingText: "",
                                imagePath: "assets/image/bus image.png",
                                title: student.name,
                                status: '',
                                name:driver.name,
                                jobName: "Driver",
                              );
                            },
                          ),
                        ),

                        // CustomBusListtile(
                        //   title: "1212",
                        //   status: 'aaaaaaaaa',
                        //   driverName: 'bbb',
                        // ),
                      ],
                    );
                  } else if (state is ErrorState) {
                    return Text("error");
                  }
                  return Text("unknown ");
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
