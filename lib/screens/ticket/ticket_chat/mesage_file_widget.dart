import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siraf3/bloc/ticket/downloadFile/ticket_download_file_bloc.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/screens/ticket/ticket_chat/message_config.dart';

class MessageFileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageFileWidget();

  FileMessage fileMessage;
  MessageConfig messageConfig;
  TextDirection textDirection;

  MessageFileWidget({required this.fileMessage, required this.messageConfig, this.textDirection = TextDirection.ltr});
}

class _MessageFileWidget extends State<MessageFileWidget> with SingleTickerProviderStateMixin {
  late AnimationController loadingController;

  TicketDownloadFileBloc ticketDownloadFileBloc = TicketDownloadFileBloc();

  CancelToken? cancelToken;

  @override
  void initState() {
    super.initState();
    loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    ticketDownloadFileBloc.add(TicketDownloadFileIsExist(widget.fileMessage));
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: ticketDownloadFileBloc,
      builder: (context, TicketDownloadFileState state) {
        if (state is TicketDownloadFileInitial) {
          return widget.fileMessage.uploadedPath.isFill() ? _fileDownloadedWidget(widget.fileMessage.uploadedPath!) : _fileInitWidget();
        }

        if (state is TicketDownloadFileSuccess) {
          return _fileDownloadedWidget(state.file.path);
        }

        if (state is TicketDownloadFileError) {
          return _fileErrorDownload(state.now, state.count);
        }

        if (state is TicketDownloadFileLoading) {
          cancelToken = state.cancelToken;
          return _fileDownloadingWidget(state.now, state.count);
        }

        return Container();
      },
    );
  }

  Widget _fileInitWidget() {
    return _baseFileWidget(
      icon: Icon(Icons.arrow_downward_rounded, color: widget.messageConfig.background, size: 30),
      fileName: widget.fileMessage.name,
      fileInfo: "${widget.fileMessage.fileSize}  ${widget.fileMessage.extension.toUpperCase()}",
      onTap: onClickDownload,
    );
  }

  Widget _fileDownloadedWidget(String filePath) {
    return _baseFileWidget(
      icon: Icon(Icons.insert_drive_file_rounded, color: widget.messageConfig.background, size: 24),
      fileName: widget.fileMessage.name,
      fileInfo: "${widget.fileMessage.fileSize} ${widget.fileMessage.extension.toUpperCase()}",
      onTap: () => onClickOpen(filePath),
    );
  }

  Widget _fileDownloadingWidget(int now, int count) {
    var percent = now / count;

    return _baseFileWidget(
      onTap: onClickCancel,
      icon: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(loadingController),
              child: CircularPercentIndicator(
                radius: 20,
                backgroundColor: Colors.transparent,
                percent: percent < 0.01 ? 0.02 : percent,
                animation: false,
                lineWidth: 3.5,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: widget.messageConfig.background,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.close_rounded, color: widget.messageConfig.background, size: 24),
          ),
        ],
      ),
      fileName: widget.fileMessage.name,
      fileInfo: "${now.toFileSize(unit: false)}/${count.toFileSize()} ${_percentDownloaded(now, count)} ${widget.fileMessage.extension.toUpperCase()}",
    );
  }

  Widget _fileErrorDownload(int now, int count) {
    return _baseFileWidget(
      icon: Icon(Icons.refresh_rounded, color: widget.messageConfig.background, size: 34),
      fileName: widget.fileMessage.name,
      fileInfo: "${now.toFileSize(unit: false)}/${count.toFileSize()} ${_percentDownloaded(now, count)}  ${widget.fileMessage.extension.toUpperCase()}",
      onTap: onClickTryAgain,
    );
  }

  Widget _baseFileWidget({
    required Widget icon,
    required String fileName,
    required String fileInfo,
    required Function() onTap,
  }) {
    return Directionality(
      textDirection: widget.textDirection,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                height: 45,
                width: 45,
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.messageConfig.primaryColor,
                ),
                child: icon,
              ),
            ),
            SizedBox(width: 0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: widget.messageConfig.fileNameColor,
                      fontSize: 11,
                      fontFamily: "sans-serif",
                    ),
                  ),
                  Text(
                    fileInfo,
                    style: TextStyle(
                      color: widget.messageConfig.secondTextColor,
                      fontSize: 8,
                      fontFamily: "sans-serif",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClickDownload() async {
    ticketDownloadFileBloc.add(TicketDownloadFileRequest(widget.fileMessage));
  }

  void onClickOpen(String path) {
    OpenFile.open(path);
  }

  void onClickTryAgain() {
    ticketDownloadFileBloc.add(TicketDownloadFileRequest(widget.fileMessage));
  }

  void onClickCancel() {
    cancelToken?.cancel();
  }

  String _percentDownloaded(now, count) {
    try {
      return ((now / count) * 100).toInt() + "%";
    } catch (e) {
      return "0%";
    }
  }
}
