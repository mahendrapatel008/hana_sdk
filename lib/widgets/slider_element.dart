import 'package:flutter/material.dart';

class ImageSliderElement extends StatefulWidget {
  final String label;
  final List<Map<String, dynamic>>
      items; // Contains image URL and optional text for each slide

  const ImageSliderElement({super.key, 
    required this.label,
    required this.items,
  });

  @override
  _ImageSliderElementState createState() => _ImageSliderElementState();
}

class _ImageSliderElementState extends State<ImageSliderElement> {
  int _currentIndex = 0; // To track the currently displayed slide

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the label
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Slider that shows images and text in a sliding PageView
        SizedBox(
          height: 250, // Set the height for the slider
          child: PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              var item = widget.items[index];
              return _buildSliderItem(item);
            },
          ),
        ),

        // Dots indicator to show the current slide
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            return _buildDotIndicator(index == _currentIndex);
          }),
        ),
      ],
    );
  }

  // Build each slide (contains image and text)
  Widget _buildSliderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.network(
            item['imgurl'], // Assuming 'imgurl' contains the image URL
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          // Optional text below the image
          if (item.containsKey('text')) ...[
            Text(
              item['text'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  // Build dot indicator for current slide
  Widget _buildDotIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }
}

Widget buildSliderElement(Map<String, dynamic> fieldData) {
  // Extract the label and image data from the field data
  String label = fieldData['label'];
  List<Map<String, dynamic>> items = (fieldData['items'] as List)
      .map((item) => {
            'imgurl': item['imgurl'],
            'text': item.containsKey('text') ? item['text'] : '',
          })
      .toList();

  return ImageSliderElement(
    label: label,
    items: items,
  );
}
