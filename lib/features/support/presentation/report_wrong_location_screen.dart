import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/strings.dart';
import '../domain/entities/support_request.dart';
import 'view_model/report_view_model.dart';
import 'widgets/support_form.dart';

class ReportWrongLocationScreen extends ConsumerWidget {
  const ReportWrongLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
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
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          color: const Color(0xFFF8FAFD),
          child: SupportForm(
            submitting: state.isLoading,
            onSubmit: (email, description) async {
              final messenger = ScaffoldMessenger.of(context);
              final ok = await ref
                  .read(reportViewModelProvider.notifier)
                  .submit(SupportRequest(
                    userEmail: email,
                    description: description,
                  ));
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    ok
                        ? 'Report sent successfully!'
                        : 'Failed to send report. Please try again.',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
