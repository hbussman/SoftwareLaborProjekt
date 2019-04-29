package sponsoren;

public class Util {

    public String prettifyTimestamp(String s) {
        // incoming format: YYYY-MM-DD HH:MM
        //                  0123456789ABCDEF
        String year = s.substring(0, 0+4);
        String month = s.substring(5, 5+2);
        String day = s.substring(8, 8+2);
        String time = s.substring(11, 11+5);
        return String.format("%s.%s.%s %s", day, month, year, time);
    }
}
