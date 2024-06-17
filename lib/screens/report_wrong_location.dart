import 'package:flutter/material.dart';
import 'package:weatherwise/widgets/custom_input_field.dart';

import '../helpers/SupportCenterHelper.dart';
import '../utils/strings.dart';
import '../widgets/custom_button.dart';

class ReportWrongLocationScreen extends StatefulWidget {
  const ReportWrongLocationScreen({super.key});

  @override
  State<ReportWrongLocationScreen> createState() =>
      _ReportWrongLocationScreenState();
}

class _ReportWrongLocationScreenState extends State<ReportWrongLocationScreen> {
  String _email = "";
  String _issueDescription = "";
  final _formKey = GlobalKey<FormState>();

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void _onSubmitPressed(BuildContext context) {
    try {
      if (_formKey.currentState!.validate()) {
        print("Form validate. Submit!");
        final String email = _email;
        final String issueDescription = _issueDescription;

        // Use the SupportCenterHelper singleton to send the email
        SupportCenterHelper()
            .sendSupportEmail(email, issueDescription, context);
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
                    Strings.wrongLocationLabel,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ))
                ],
              ))),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                  const Text(Strings.supportCenterLabel,
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(Strings.supportCenterSubHeader,
                      style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 25.0,
                  ),
                  CustomInputField(
                      placeholder: "Email",
                      isPasswordField: false,
                      isMultilineField: false,
                      onChanged: (input) {
                        _email = input;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.invalidEmailErrorText;
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomInputField(
                      placeholder: Strings.issueDescriptionText,
                      isPasswordField: false,
                      isMultilineField: true,
                      onChanged: (input) {
                        _issueDescription = input;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.invalidIssueDescText;
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomButton(
                        buttonText: Strings.submitText,
                        fullWidth: false,
                        height: 50,
                        onPressed: () => _onSubmitPressed(context)),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
