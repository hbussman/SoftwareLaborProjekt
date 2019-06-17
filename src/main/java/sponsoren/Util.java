package sponsoren;

import sponsoren.orm.AttraktionEntity;
import sponsoren.orm.SponsorEntity;
import sponsoren.orm.VeranstaltungEntity;
import sponsoren.service.external.Attraktionen.Attraktion;

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

    public String parsableDateForHTML(String s) {
        // incoming format: yyyy-mm-dd HH:MM
        //                  0123456789ABCDEF
        // required format: yyyy-mm-ddTHH:MM
        String parsable = s.substring(0, 10);
        return parsable;
    }

    public String parsableTimeForHTML(String s) {
        // incoming format: yyyy-mm-dd HH:MM
        //                  0123456789ABCDEF
        // required format: yyyy-mm-ddTHH:MM
        String parsable = s.substring(11, 11+5);
        return parsable;
    }

    public String truncateLongText(String text, int max_len) {
        max_len = Math.min(text.length(), max_len - 1);

        if(text.length() <= max_len || max_len < 0) {
            return text;
        }

        if(max_len == 0) {
            return "";
        }

        // search for the last space before the limit
        for(int i = max_len; i >= 0; i--) {
            if(text.charAt(i) == ' ') {
                return text.substring(0, i) + "…";
            }
        }

        return "";
    }

    /**
     * returns true if the object is a match for the searchString
     * @param searchString some text to search for
     * @param object object to match the text with
     * @return a bool indicating whether object should be shown
     */
    public boolean searchMatch(String searchString, Object object) {

        if(searchString == null || object == null) {
            return true;
        }

        if(object instanceof SponsorEntity) {
            SponsorEntity ent = ((SponsorEntity)object);

            if(ent.getName() != null && ent.getName().contains(searchString))
                return true;
            if(ent.getHomepage() != null && ent.getHomepage().contains(searchString))
                return true;

        } else if(object instanceof VeranstaltungEntity) {
            VeranstaltungEntity ent = ((VeranstaltungEntity)object);

            if(ent.getName() != null && ent.getName().contains(searchString))
                return true;

        } else if(object instanceof AttraktionEntity) {
            AttraktionEntity ent = ((AttraktionEntity)object);

            if(ent.getName() != null && ent.getName().contains(searchString))
                return true;
        }

        return false;
    }

}
