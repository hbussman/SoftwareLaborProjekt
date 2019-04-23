package sponsoren.orm;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "veranstaltung", schema = "buga19sponsoren", catalog = "")
public class VeranstaltungEntity {
    private int id;
    private String name;
    private String beschreibung;
    private Timestamp start;
    private Timestamp ende;
    private String discriminator;
    private Integer locationID;

    @Id
    @Column(name = "ID")
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Basic
    @Column(name = "Name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Basic
    @Column(name = "Beschreibung")
    public String getBeschreibung() {
        return beschreibung;
    }

    public void setBeschreibung(String beschreibung) {
        this.beschreibung = beschreibung;
    }

    @Basic
    @Column(name = "Start")
    public Timestamp getStart() {
        return start;
    }

    public void setStart(Timestamp start) {
        this.start = start;
    }

    @Basic
    @Column(name = "Ende")
    public Timestamp getEnde() {
        return ende;
    }

    public void setEnde(Timestamp ende) {
        this.ende = ende;
    }

    @Basic
    @Column(name = "Discriminator")
    public String getDiscriminator() {
        return discriminator;
    }

    public void setDiscriminator(String discriminator) {
        this.discriminator = discriminator;
    }

    @Basic
    @Column(name = "LocationID")
    public Integer getLocationID() {
        return locationID;
    }

    public void setLocationID(Integer locationID) {
        this.locationID = locationID;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        VeranstaltungEntity that = (VeranstaltungEntity)o;
        return id == that.id &&
                Objects.equals(name, that.name) &&
                Objects.equals(beschreibung, that.beschreibung) &&
                Objects.equals(start, that.start) &&
                Objects.equals(ende, that.ende) &&
                Objects.equals(discriminator, that.discriminator);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, beschreibung, start, ende, discriminator);
    }
}
