import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input_field.dart';

class SupportForm extends StatefulWidget {
  const SupportForm({
    super.key,
    required this.submitting,
    required this.onSubmit,
  });

  final bool submitting;
  final void Function(String email, String description) onSubmit;

  @override
  State<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30.0),
          const Text(
            Strings.supportCenterLabel,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          const Text(
            Strings.supportCenterSubHeader,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 25.0),
          CustomInputField(
            placeholder: 'Email',
            isPasswordField: false,
            isMultilineField: false,
            onChanged: (v) => _email = v,
            validator: (v) =>
                (v == null || v.isEmpty) ? Strings.invalidEmailErrorText : null,
          ),
          const SizedBox(height: 20.0),
          CustomInputField(
            placeholder: Strings.issueDescriptionText,
            isPasswordField: false,
            isMultilineField: true,
            onChanged: (v) => _description = v,
            validator: (v) => (v == null || v.isEmpty)
                ? Strings.invalidIssueDescText
                : null,
          ),
          const SizedBox(height: 25.0),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
              buttonText: widget.submitting ? '...' : Strings.submitText,
              fullWidth: false,
              height: 50,
              onPressed: widget.submitting
                  ? () {}
                  : () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(_email, _description);
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
