/*
package sponsoren.orm;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "sponsor_attraktion", schema = "buga19sponsoren", catalog = "")
//@IdClass(SponsorVeranstaltungEntityPK.class)
public class AttraktionEntity {
    private String sponsorName;
    private int attraktionID;

    @Id
    @Column(name = "SponsorName")
    public String getSponsorName() {
        return sponsorName;
    }

    public void setSponsorName(String sponsorName) {
        this.sponsorName = sponsorName;
    }

    @Id
    @Column(name = "AttraktionID")
    public int getAttraktionID() {
        return attraktionID;
    }

    public void setAttraktionID(int attraktionID) {
        this.attraktionID = attraktionID;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        AttraktionEntity that = (AttraktionEntity)o;
        return attraktionID == that.attraktionID &&
                Objects.equals(sponsorName, that.sponsorName);
            }

    @Override
    public int hashCode() {
        return Objects.hash(sponsorName, attraktionID);
    }
}
*/
