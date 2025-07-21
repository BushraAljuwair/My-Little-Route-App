import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/kindergarten/bus/bloc/bus_bloc.dart';
import 'package:my_little_route/features/kindergarten/bus/widgets/listtile/custom_bus_listtile.dart';
import 'package:my_little_route/features/kindergarten/home/widgets/text/custom_text.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/style/style_size.dart';

class ViewDriversScreen extends StatelessWidget {
  const ViewDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusBloc()..add(GetBusesEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<BusBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("BusScreen")),
            body: BlocBuilder<BusBloc, BusState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return Center(child: Text("loading"));
                }
                if (state is SuccessState) {
                  return Column(
                    children: [
                       StyleSize.sizeH8,
                      CustomText(title:"DriverManagement"),
                      StyleSize.sizeH16,
                      Expanded(
                        child: ListView.builder(
                          itemCount: bloc.drivers!.length,
                          itemBuilder: (context, index) {
                            UserModel? driver = bloc.drivers![index];
                            final bus = bloc.buses!.firstWhere(
                              (bus) => driver.id == bus!.driverId,
                            );
                            return CustomBusListtile(
                              onEdit: () {},
                              onViewDetails: () {},
                              leadingText: '',
                              imagePath: "assets/image/driver.png",
                              title: driver.name,
                              status: '',
                              name: bus!.plateNumber,
                              jobName: "Bus",
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
          );
        },
      ),
    );
  }
}
