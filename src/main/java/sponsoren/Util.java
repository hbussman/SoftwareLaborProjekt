package sponsoren;

public class Util {

    public String prettifyTimestamp(String s) {
        // incoming format: yyyy-mm-dd HH:MM
        //                  0123456789ABCDEF
        // required format: dd.mm.yyyy HH:MM
        String year = s.substring(0, 0+4);
        String month = s.substring(5, 5+2);
        String day = s.substring(8, 8+2);
        String time = s.substring(11, 11+5);
        return String.format("%s.%s.%s %s", day, month, year, time);
    }

    public String prettyTime(String s) {
        // incoming format: yyyy-mm-dd HH:MM
        //                  0123456789ABCDEF
    	String time = s.substring(11, 11+5);
    	return time;
    }

    public String prettyDate(String s) {
    	 // incoming format: yyyy-mm-dd HH:MM
         //                  0123456789ABCDEF
    	 String year = s.substring(0, 0+4);
         String month = s.substring(5, 5+2);
         String day = s.substring(8, 8+2);
         return String.format("%s.%s.%s", day, month, year);
    }

    public String parsableDatetimeForHTML(String s) {
        // incoming format: yyyy-mm-dd HH:MM
        //                  0123456789ABCDEF
        // required format: yyyy-mm-ddTHH:MM
        String parsable = s.replaceFirst(" ", "T").substring(0, 16);
        return parsable;
    }
}
