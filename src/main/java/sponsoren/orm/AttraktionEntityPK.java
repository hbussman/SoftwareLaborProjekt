package sponsoren.orm;

import javax.persistence.Column;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.Objects;

public class AttraktionEntityPK implements Serializable {
    private String sponsorName;
    private String attraktion;

    @Column(name = "SponsorName")
    @Id
    public String getSponsorName() {
        return sponsorName;
    }

    public void setSponsorName(String sponsorName) {
        this.sponsorName = sponsorName;
    }

    @Column(name = "Attraktion")
    @Id
    public String getAttraktion() {
        return attraktion;
    }

    public void setAttraktion(String attraktion) {
        this.attraktion = attraktion;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        AttraktionEntityPK that = (AttraktionEntityPK)o;
        return Objects.equals(sponsorName, that.sponsorName) &&
                Objects.equals(attraktion, that.attraktion);
    }

    @Override
    public int hashCode() {
        return Objects.hash(sponsorName, attraktion);
    }
}
