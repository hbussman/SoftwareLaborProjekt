package sponsoren;

import javax.persistence.Column;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.Objects;

public class SponsorVeranstaltungEntityPK implements Serializable {
    private String sponsorName;
    private int veranstaltungId;

    @Column(name = "SponsorName")
    @Id
    public String getSponsorName() {
        return sponsorName;
    }

    public void setSponsorName(String sponsorName) {
        this.sponsorName = sponsorName;
    }

    @Column(name = "VeranstaltungID")
    @Id
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
        SponsorVeranstaltungEntityPK that = (SponsorVeranstaltungEntityPK)o;
        return veranstaltungId == that.veranstaltungId &&
                Objects.equals(sponsorName, that.sponsorName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(sponsorName, veranstaltungId);
    }
}
