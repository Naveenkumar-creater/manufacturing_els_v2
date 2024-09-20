class ChaneDateformate{
 static String formatDate(String dateStr) {
  // Split the date and time parts
  List<String> parts = dateStr.split(' ');
  
  // Split the date part into year, month, and day
  List<String> dateParts = parts[0].split('-');
  
  // Extract and zero-pad the month and day
  String year = dateParts[0];
  String month = dateParts[1].padLeft(2, '0');
  String day = dateParts[2].padLeft(2, '0');
  
  // Combine back the date and time with the corrected format
  String formattedDate = '$year-$month-$day ${parts[1]}';
  
  return formattedDate;
}
}