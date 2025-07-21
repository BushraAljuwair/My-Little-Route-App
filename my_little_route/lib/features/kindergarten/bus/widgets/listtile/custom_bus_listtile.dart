import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class CustomBusListtile extends StatelessWidget {
  final String title; // This will be the bus number, e.g., "12"
  final String status; // e.g., "Active"
  final String name; // e.g., "John Smith"
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
    String imagePath;
  final String leadingText;
  final String jobName;
  String? gender;
    CustomBusListtile({
    super.key,
    required this.title,
    required this.status,
    required this.name,
    this.onViewDetails,
    this.onEdit,
    required this.imagePath,
    required this.leadingText,
    required this.jobName,
    this.gender
  });

  @override
  Widget build(BuildContext context) {
    if(gender!=null){
      if(gender=="Male"){
        imagePath="assets/image/m-child.png";
      }else{
         imagePath="assets/image/f-child.png";
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ), // Added vertical margin for better spacing
      height:
          context.getHeight() *
          .15, // Increased height slightly to accommodate content
      width: context.getWidth() * .95,
      decoration: BoxDecoration(
        color: StyleColor.white, // Assuming white background for the card
        border: Border.all(
          width: .4,
          color: Colors.grey.shade300,
        ), // Lighter border
        borderRadius: BorderRadius.circular(
          12,
        ), // Slightly more rounded corners
        boxShadow: [
          // Added a subtle shadow for a card-like effect
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ), // Added padding inside the container
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align items vertically in the center
          children: [
            // Bus Icon
            Container(
              width: context.getWidth() * .12, // Smaller icon container
              height: context.getHeight() * .12,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Image.asset(
                  imagePath, // Ensure this path is correct
                  fit: BoxFit.contain, // Use contain to ensure the image fits
                ),
              ),
            ),
            const SizedBox(width: 8), // Spacing between icon and text
            // Bus Details (Number, Status, Driver)
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center text vertically
                children: [
                  Text(
                    "${leadingText.tr()} $title", // Bus Number
                    style: StyleText.bold20(context),
                  ),
                  const SizedBox(height: 4), // Spacing between text lines
                  if (status.isNotEmpty)
                    Text(
                      status.tr(), // Status (e.g., Active)
                      style: StyleText.regular16Green(
                        context,
                      ), // Assuming green for active status
                    ),
                  if (status.isNotEmpty) const SizedBox(height: 4),
                  Text(
                    "${jobName.tr()}: $name", // Driver Name
                    style: StyleText.regular16Green(
                      context,
                    ), // Grey for driver name
                  ),
                ],
              ),
            ),

            // Buttons (View Details, Edit)
            // Wrapped the Column in a SizedBox to provide a finite width,
            // which resolves the "infinite width" constraint error for the buttons.
            SizedBox(
              width: context.getWidth()*.3, // Explicitly constrain the width of the button column
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center buttons vertically
                children: [
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style
                        ?.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            Size(
                              context.getWidth() * .23,
                              context.getHeight() * .042,
                            ),
                          ), // Smaller button size
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10),
                          ), // Adjust padding
                          textStyle: WidgetStateProperty.all(
                            StyleText.buttonText12(
                              context,
                            ).copyWith(color: StyleColor.white),
                          ), // Ensure text color is white
                        ),
                    onPressed: onViewDetails,
                    child: Text("ViewDetails".tr()),
                  ),
                  const SizedBox(height: 4), // Spacing between buttons
                  ElevatedButton(
                    // Style for the 'Edit' button, assuming a white background and blue text
                    style: Theme.of(context).elevatedButtonTheme.style
                        ?.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            Size(
                              context.getWidth() * .22,
                              context.getHeight() * .04,
                            ),
                          ), // Smaller button size
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            StyleColor.white,
                          ), // White background
                          foregroundColor: WidgetStateProperty.all(
                            StyleColor.blue,
                          ), // Blue text
                          side: WidgetStateProperty.all(
                            BorderSide(color: StyleColor.blue, width: 1),
                          ), // Blue border
                          textStyle: WidgetStateProperty.all(
                            StyleText.buttonText12(
                              context,
                            ).copyWith(color: StyleColor.blue),
                          ), // Ensure text color is blue
                        ),
                    onPressed: onEdit,
                    child: Text("Edit".tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
