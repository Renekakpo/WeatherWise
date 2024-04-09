import 'package:flutter/material.dart';
import 'package:weatherwise/widgets/custom_input_field.dart';

import '../widgets/custom_button.dart';

class ReportWrongLocationScreen extends StatefulWidget {
  const ReportWrongLocationScreen({super.key});

  @override
  State<ReportWrongLocationScreen> createState() =>
      _ReportWrongLocationScreenState();
}

class _ReportWrongLocationScreenState extends State<ReportWrongLocationScreen> {
  final _formKey = GlobalKey<FormState>();

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void _onSubmitPressed() {
    try {
      if (_formKey.currentState!.validate()) {
        print("Form validate. Submit!");
      } else {
        print("Form not validate.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFD),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _onBackArrowPressed,
          ),
          title: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    "Report wrong location",
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ))
                ],
              ))),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        color: const Color(0xFFF8FAFD),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                const Text("Support Center",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                    "Help up improve your experience by filling the form below.",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 25.0,
                ),
                CustomInputField(
                    placeholder: "Email",
                    isPasswordField: false,
                    isMultilineField: false,
                    onChanged: (input) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                CustomInputField(
                    placeholder: "Issue Description",
                    isPasswordField: false,
                    isMultilineField: true,
                    onChanged: (input) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the issue description';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 25.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                      buttonText: "Submit",
                      fullWidth: false,
                      height: 50,
                      onPressed: _onSubmitPressed),
                )
              ],
            )),
      ),
    );
  }
}
