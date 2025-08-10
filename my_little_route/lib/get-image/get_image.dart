// get-image/get_image.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/get-image/bloc/get_image_bloc.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';

class GetImage extends StatelessWidget {
  const GetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Initialize the bloc and immediately add the event to load the image
        final bloc = GetImageBloc();
        bloc.add(LoadInitialImageEvent());
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<GetImageBloc, GetImageState>(
          listener: (context, state) {
            if (state is ErrorGetImage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: StyleText.bold18(context).copyWith(color: StyleColor.white),
                  ),
                  backgroundColor: StyleColor.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<GetImageBloc>();
            ImageProvider imageProvider;
            
            // Determine the image to display
            if (state is ImageUploadedState) {
              // Add a unique timestamp to the URL to bust the cache and force a reload
              final newImageUrl = '${state.imageUrl}?v=${DateTime.now().millisecondsSinceEpoch}';
              imageProvider = NetworkImage(newImageUrl);
            } else if (bloc.imageUrl != null) {
              // Add a unique timestamp to the URL for the initial load as well
              final currentImageUrl = '${bloc.imageUrl!}?v=${DateTime.now().millisecondsSinceEpoch}';
              imageProvider = NetworkImage(currentImageUrl);
            } else {
              // Fallback to the default asset image
              imageProvider = const AssetImage("assets/image/driver (2).png");
            }

            return Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Call the event to pick a new image from the gallery
                    bloc.add(GetImageFromGalleryEvent());
                  },
                  child: const Text("Upload Image"),
                ),
                // Show a loading indicator while the image is being uploaded
                if (state is UploadingImageState)
                  const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
