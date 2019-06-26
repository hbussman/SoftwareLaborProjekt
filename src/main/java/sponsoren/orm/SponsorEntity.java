package sponsoren.orm;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "sponsor", schema = "buga19sponsoren", catalog = "")
public class SponsorEntity implements Comparable<SponsorEntity> {
    private String name;
    private String beschreibung;
    private String werbetext;
    private String adresse;
    private String ansprechpartnerNachname;
    private String ansprechpartnerVorname;
    private String email;
    private String telefonnummer;
    private String homepage;
    private String plz;
    private String ort;
    private String postfach;
    private byte spendenklasse;
    private int aufrufe;

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

    @Basic
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
    }

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

    @Basic
    @Column(name = "Homepage")
    public String getHomepage() {
        return homepage;
    }

    public void setHomepage(String homepage) {
        this.homepage = homepage;
    }

    @Basic
    @Column(name = "Plz", nullable = true, length = 5)
    public String getPlz() {
        return plz;
    }

    public void setPlz(String plz) {
        this.plz = plz;
    }

    @Basic
    @Column(name = "Stadt", nullable = true, length = 255)
    public String getOrt() {
        return ort;
    }

    public void setOrt(String stadt) {
        this.ort = stadt;
    }

    @Basic
    @Column(name = "Postfach", nullable = true, length = 255)
    public String getPostfach() {
        return postfach;
    }

    public void setPostfach(String postfach) {
        this.postfach = postfach;
    }

    @Basic
    @Column(name = "Spendenklasse", nullable = true)
	public byte getSpendenklasse() {
		return spendenklasse;
	}

	public void setSpendenklasse(byte spendenklasse) {
		this.spendenklasse = spendenklasse;
	}

    @Basic
    @Column(name = "Aufrufe")
    public int getAufrufe() {
        return aufrufe;
    }

    public void setAufrufe(int aufrufe) {
        this.aufrufe = aufrufe;
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
                Objects.equals(telefonnummer, that.telefonnummer) &&
                Objects.equals(homepage, that.homepage) &&
                Objects.equals(plz, that.plz) &&
                Objects.equals(ort, that.ort) &&
                Objects.equals(postfach, that.postfach) &&
                Objects.equals(spendenklasse, that.spendenklasse) &&
                Objects.equals(aufrufe, that.aufrufe);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, beschreibung, werbetext, adresse, ansprechpartnerNachname, ansprechpartnerVorname, email, telefonnummer);
    }

	@Override
	public int compareTo(SponsorEntity comparedSopnsor) {
		// TODO Auto-generated method stub
		return name.compareTo(comparedSopnsor.name);
	}
    
    

   
}
