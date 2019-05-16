package sponsoren.orm;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "sponsor_veranstaltung", schema = "buga19sponsoren", catalog = "")
@IdClass(SponsorVeranstaltungEntityPK.class)
public class AttraktionEntity {
    private String sponsorName;
    private int veranstaltungId;

    @Id
    @Column(name = "SponsorName")
    public String getSponsorName() {
        return sponsorName;
    }

    public void setSponsorName(String sponsorName) {
        this.sponsorName = sponsorName;
    }

    @Id
    @Column(name = "VeranstaltungID")
    public int getVeranstaltungId() {
        return veranstaltungId;
    }

    public void setVeranstaltungId(int veranstaltungId) {
        this.veranstaltungId = veranstaltungId;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        SponsorVeranstaltungEntity that = (SponsorVeranstaltungEntity)o;
        return veranstaltungId == that.veranstaltungId &&
                Objects.equals(sponsorName, that.sponsorName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(sponsorName, veranstaltungId);
    }
}
