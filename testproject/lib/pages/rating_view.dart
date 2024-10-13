import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testproject/pages/rating_viewmodel.dart';

class RatingView extends StatefulWidget {
  RatingView({super.key});

  @override
  _ratingViewState createState() => _ratingViewState();
}

class _ratingViewState extends State<RatingView> {
  final RatingViewModel ratingViewModel = RatingViewModel();
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rating View"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          MaterialButton(onPressed: (){
            setState(() {
              ratingViewModel.clear();
            });
          },child: Text("Clear"),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ratingViewModel.ratingList.length,
                itemBuilder: (context, index) {
                  var item = ratingViewModel.ratingList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.tealAccent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: ratingViewModel.isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                ratingViewModel.isChecked = newValue!;
                              });
                            },
                          ),
                          Text(item.toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Enter a rating',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Example action: Print a message to the console
                      print('Add button pressed!');
                      setState(() {
                        if(_textController.text.isNotEmpty){
                          ratingViewModel.ratingList.add(_textController.text);
                          _textController.clear();
                        }
                      });
                    },
                    icon: Icon(Icons.add),
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
