package sponsoren.orm;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "sponsor", schema = "buga19sponsoren", catalog = "")
public class SponsorEntity {
    private String name;
    private String beschreibung;
    private String werbetext;
    private String adresse;
    private String ansprechpartnerNachname;
    private String ansprechpartnerVorname;
    private String email;
    private String telefonnummer;

    @Id
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
    @Column(name = "Werbetext")
    public String getWerbetext() {
        return werbetext;
    }

    public void setWerbetext(String werbetext) {
        this.werbetext = werbetext;
    }

    @Basic
    @Column(name = "Adresse")
    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    /*@Basic
    @Column(name = "AnsprechpartnerNachname")
    public String getAnsprechpartnerNachname() {
        return ansprechpartnerNachname;
    }

    public void setAnsprechpartnerNachname(String ansprechpartnerNachname) {
        this.ansprechpartnerNachname = ansprechpartnerNachname;
    }

    @Basic
    @Column(name = "AnsprechpartnerVorname")
    public String getAnsprechpartnerVorname() {
        return ansprechpartnerVorname;
    }

    public void setAnsprechpartnerVorname(String ansprechpartnerVorname) {
        this.ansprechpartnerVorname = ansprechpartnerVorname;
    }*/

    @Basic
    @Column(name = "Email")
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Basic
    @Column(name = "Telefonnummer")
    public String getTelefonnummer() {
        return telefonnummer;
    }

    public void setTelefonnummer(String telefonnummer) {
        this.telefonnummer = telefonnummer;
    }

    @Override
    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || getClass() != o.getClass()) return false;
        SponsorEntity that = (SponsorEntity)o;
        return Objects.equals(name, that.name) &&
                Objects.equals(beschreibung, that.beschreibung) &&
                Objects.equals(werbetext, that.werbetext) &&
                Objects.equals(adresse, that.adresse) &&
                Objects.equals(ansprechpartnerNachname, that.ansprechpartnerNachname) &&
                Objects.equals(ansprechpartnerVorname, that.ansprechpartnerVorname) &&
                Objects.equals(email, that.email) &&
                Objects.equals(telefonnummer, that.telefonnummer);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, beschreibung, werbetext, adresse, ansprechpartnerNachname, ansprechpartnerVorname, email, telefonnummer);
    }
}
