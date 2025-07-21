import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/kindergarten/bus/bloc/bus_bloc.dart';
import 'package:my_little_route/features/kindergarten/bus/widgets/listtile/custom_bus_listtile.dart';
import 'package:my_little_route/features/kindergarten/home/widgets/text/custom_text.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/style/style_size.dart';

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusBloc()..add(GetBusesEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<BusBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("BusScreen")),
            body: SafeArea(
              child: BlocBuilder<BusBloc, BusState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Center(child: Text("loading"));
                  }
                  if (state is SuccessState) {
                    return Column(
                      children: [
                        CustomText(title: "BusManagement"),
                        StyleSize.sizeH24,
                        Expanded(
                          child: ListView.builder(
                            itemCount: bloc.buses!.length,
                            itemBuilder: (context, index) {
                              BusesModel? bus = bloc.buses![index];
                              final driver = bloc.drivers!.firstWhere(
                                (driver) => driver.id == bus!.driverId,
                              );
                              return CustomBusListtile(
                                onEdit: () {},
                                onViewDetails: () {},
                                leadingText: "Bus",
                                imagePath: "assets/image/bus image.png",
                                title: bus!.plateNumber,
                                status: '',
                                name: driver.name,
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
