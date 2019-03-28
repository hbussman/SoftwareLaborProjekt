package sponsoren.orm;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "location", schema = "buga19sponsoren", catalog = "")
public class LocationEntity {
    private int id;
    private String name;
    private double lat;
    private double lon;

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
    @Column(name = "Lat")
    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    @Basic
    @Column(name = "Lon")
    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        LocationEntity that = (LocationEntity)o;
        return id == that.id &&
                Double.compare(that.lat, lat) == 0 &&
                Double.compare(that.lon, lon) == 0 &&
                Objects.equals(name, that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, lat, lon);
    }
}
