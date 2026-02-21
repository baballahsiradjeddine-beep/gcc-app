import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/splash/splash_screen.dart';

class PdfContentScreen extends HookConsumerWidget {
  const PdfContentScreen({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller  = useState<PDFViewController>(
    //   PDFViewController(),
    // );

    final filePath = useState<String?>(null);
    final isLoading = useState<bool>(true);
    final isReady = useState<bool>(false);

    Future<String> downloadPdf(String url) async {
      final dir = await getApplicationDocumentsDirectory();
      final name = url.split('/').last;
      final filePath = '${dir.path}/$name.pdf';
      final file = File(filePath);

      if (!await file.exists()) {
        await Dio().download(url, filePath);
      }

      return filePath;
    }

    Future<void> handleDownload() async {
      try {
        await Future.delayed(const Duration(seconds: 2));
        AppLogger.logInfo('Downloading PDF...');
        final path = await downloadPdf(pdfUrl);
        filePath.value = path;
        isLoading.value = false;
      } catch (e) {
        AppLogger.logError('Error downloading PDF: $e');
        isLoading.value = false;
      }
    }

    useEffect(() {
      handleDownload();
      return null;
    }, []);

    return AppScaffold(
        paddingX: 0,
        paddingY: 0,
        body: isLoading.value
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    10.verticalSpace,
                    const TayssirDataLoader(
                      textSize: 14,
                      iconSize: 30,
                    ),
                  ],
                ),
              )
            : filePath.value == null
                ? const Center(child: Text('No PDF found'))
                : PDFView(
                    filePath: filePath.value,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),

                    onRender: (pages) {
                      // setState(() {
                      //   pages = pages;
                      //   isReady = true;
                      // });

                      isReady.value = true;
                      AppLogger.logInfo('PDF Rendered: $pages');
                    },
                    onError: (error) {
                      AppLogger.logError('PDF Error: $error');
                    },
                    onPageError: (page, error) {
                      AppLogger.logError('PDF Page Error: $page: $error');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      // _controller.complete(pdfViewController);
                      // controller.value = pdfViewController;
                      AppLogger.logInfo('PDF View Created: $pdfViewController');
                    },
                    // onPageChanged: (int page, int total) {
                    //   print('page change: $page/$total');
                    //   return page;
                    // },
                  ));
  }
}
