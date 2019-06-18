package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import sponsoren.Util;
import sponsoren.orm.*;
import sponsoren.security.SponsorenPasswordEncoder;
import sponsoren.service.external.Attraktionen.Attraktion;
import sponsoren.service.external.ExternalServices;
import sponsoren.service.external.Lageplan.Poi;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Controller
@RequestMapping(path="/api")
public class MainController {

    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private SponsorVeranstaltungRepository sponsorVeranstaltungRepository;
    @Autowired private LocationRepository locationRepository;
    @Autowired private AccountRepository accountRepository;
    @Autowired private AttraktionRepository attraktionRepository;


    // GET list of all sponsors
    @GetMapping(path="/sponsor/all")
    public @ResponseBody Iterable<SponsorEntity> getAllSponsors() {
        return sponsorRepository.findAll();
    }

    // GET single sponsor
    @GetMapping(path="/sponsor/{name}")
    public @ResponseBody SponsorEntity getSponsor(@PathVariable String name) {
        return sponsorRepository.findById(name).orElse(null);
    }

    // PATCH save sponsor information
    @PatchMapping(path = "/sponsor")
    public ResponseEntity setSponsorInfo(@AuthenticationPrincipal AccountEntity user, @RequestBody SponsorEntity sponsor) {
        sponsor.setName(user.getSponsorName());
        sponsor.setAdresse(sponsor.getAdresse().trim());
        sponsor.setAnsprechpartnerNachname(sponsor.getAnsprechpartnerNachname().trim());
        sponsor.setAnsprechpartnerVorname(sponsor.getAnsprechpartnerVorname().trim());
        sponsor.setEmail(sponsor.getEmail().trim());
        sponsor.setTelefonnummer(sponsor.getTelefonnummer().trim());
        sponsor.setOrt(sponsor.getOrt().trim());
        String homepage = sponsor.getHomepage().trim();
        if(!homepage.startsWith("http://") && !homepage.startsWith("https://"))
            homepage = "https://" + homepage;
        sponsor.setHomepage(homepage);

        // validate plz
        String plz = sponsor.getPlz().trim();
        if (plz.length() == 0) {
            sponsor.setPlz(null);
        } else if (!plz.matches("\\d{5}")) {
            return ResponseEntity.unprocessableEntity().body("Plz muss aus 5 Zahlen bestehen");
        }

        // TODO Add further validations
        sponsorRepository.save(sponsor);
        return ResponseEntity.ok(null);
    }

    // GET list of all locations
    @GetMapping(path="/location/all")
    public @ResponseBody Iterable<LocationEntity> getAllLocations() {
        return locationRepository.findAll();
    }

    // PATCH save account data
    @PatchMapping(path="/account")
    public @ResponseBody ResponseEntity saveAccount(@AuthenticationPrincipal AccountEntity user, @RequestBody AccountInfo data) {
        String sponsor = user.getSponsorName();

        if(data.getUsername().isEmpty()) {
            return ResponseEntity.unprocessableEntity().body("Der Login-Username kann nicht leer sein!");
        }

        Iterable<AccountEntity> all = accountRepository.findAll();
        AccountEntity account = null;
        for(AccountEntity accountEntity : all) {
            if(accountEntity.getSponsorName().equals(sponsor)) {
                account = accountEntity;
                break;
            }
        }

        if(account == null) {
            return ResponseEntity.unprocessableEntity().body("Fehlerhafter Sponsor-Name " + sponsor);
        }

        accountRepository.delete(account);

        account.setUsername(data.getUsername());
        if(!data.getPassword().isEmpty())
            account.setPassword(new SponsorenPasswordEncoder().encode(data.getPassword()));
        accountRepository.save(account);

        return ResponseEntity.ok("");
    }

    // GET list of all events
    @GetMapping(path="/event/all")
    public @ResponseBody Iterable<VeranstaltungEntity> getAllEvents() {
        return veranstaltungRepository.findAll();
    }

    // GET list of sponsor_veranstaltung
    @GetMapping(path="/event/all/sponsor_mapping")
    public @ResponseBody Iterable<SponsorVeranstaltungEntity> getAllVeranst() {
        return sponsorVeranstaltungRepository.findAll();
    }

    // GET single event
    @GetMapping(path="/event/{eventId}")
    public @ResponseBody VeranstaltungEntity getEvent(@PathVariable int eventId) {
        return veranstaltungRepository.findById(eventId).orElse(null);
    }

    // POST create new event
    @PostMapping(path = "/event")
    public ResponseEntity createNewVeranstaltung(@AuthenticationPrincipal AccountEntity user, @RequestBody EventInfo event) {
        // create Veranstaltung
        VeranstaltungEntity veranstaltung = new VeranstaltungEntity();
        veranstaltung.setName(event.getName());
        veranstaltung.setBeschreibung(event.getBeschreibung());
        System.out.println(event.getBeschreibung());
        try {
            veranstaltung.setStart(parseDate(event.getStart()));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Fehlerhaftes Datumsformat " + event.getStart() + " - "
                    + e.getMessage());
        }
        try {
            veranstaltung.setEnde(parseDate(event.getEnde()));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Fehlerhaftes Datumsformat " + event.getEnde() + " - "
                    + e.getMessage());
        }

        // make sure the start date is before the end date
        if(veranstaltung.getStart().after(veranstaltung.getEnde())) {
            return ResponseEntity.unprocessableEntity().body("Das Ende-Datum kann zeitlich nicht vor dem Start-Datum liegen!");
        }

        // get location id from name
        String ort = event.getOrt();
        LocationEntity location = findLocation(ort);
        if(location == null)
            return ResponseEntity.unprocessableEntity().body("Ort '" + ort + "' existiert nicht");
        veranstaltung.setLocationID(location.getId());

        // save Veranstaltung to database
        veranstaltung.setDiscriminator(event.getDiscriminator());
        veranstaltungRepository.save(veranstaltung);
        veranstaltung = findNewestVeranstaltung();
        System.out.println("Veranstaltung saved; ID=" + veranstaltung.getId());

        // create veranstaltung-sponsor association
        String creator = user.getSponsorName();
        SponsorVeranstaltungEntity sponsorVeranstaltung = new SponsorVeranstaltungEntity();
        sponsorVeranstaltung.setSponsorName(creator);
        sponsorVeranstaltung.setVeranstaltungId(veranstaltung.getId());

        // save veranstaltung-sponsor association to database
        sponsorVeranstaltungRepository.save(sponsorVeranstaltung);

        EventInfo body = new EventInfo(
                veranstaltung.getName(),
                location.getName(),
                Util.prettifyTimestampImpl(veranstaltung.getStart().toString()),
                Util.prettifyTimestampImpl(veranstaltung.getEnde().toString()),
                veranstaltung.getBeschreibung(),
                event.getDiscriminator()
        );

        try {
            return ResponseEntity.created(new URI("/event?id=" + veranstaltung.getId())).body(body);
        } catch(URISyntaxException e) {
            e.printStackTrace();
            return ResponseEntity.accepted().body(body);
        }
    }

    // PATCH edit an event
    @PatchMapping(path="/event/{eventId}")
    public ResponseEntity editVeranstaltung(@AuthenticationPrincipal AccountEntity user, @PathVariable int eventId, @RequestBody EventInfo event) {
        Optional<VeranstaltungEntity> veranstaltungEntity = veranstaltungRepository.findById(eventId);
        if(!veranstaltungEntity.isPresent()) {
            return ResponseEntity.unprocessableEntity().body("Veranstaltung mit ID=" + eventId + " wurde nicht gefunden!");
        }

        // make sure we have permission to edit this
        SponsorVeranstaltungEntityPK sponsorVeranstaltungEntityPK = new SponsorVeranstaltungEntityPK();
        sponsorVeranstaltungEntityPK.setVeranstaltungId(eventId);
        sponsorVeranstaltungEntityPK.setSponsorName(user.getSponsorName());
        Optional<SponsorVeranstaltungEntity> sponsorVeranstaltung = sponsorVeranstaltungRepository.findById(sponsorVeranstaltungEntityPK);
        if(!sponsorVeranstaltung.isPresent()) {
            return ResponseEntity.status(403).body(user.getSponsorName() + " ist nicht als Mitveranstalter dieser Veranstaltung eingetragen!");
        }

        VeranstaltungEntity veranstaltung = veranstaltungEntity.get();
        veranstaltung.setName(event.getName());
        veranstaltung.setBeschreibung(event.getBeschreibung());
        try {
            veranstaltung.setStart(parseDate(event.getStart()));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Start: Fehlerhaftes Datumsformat '" + event.getStart() + "' - "
                    + e.getMessage());
        }
        try {
            veranstaltung.setEnde(parseDate(event.getEnde()));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Ende: Fehlerhaftes Datumsformat " + event.getEnde() + " - "
                    + e.getMessage());
        }

        // make sure the start date is before the end date
        if(veranstaltung.getStart().after(veranstaltung.getEnde())) {
            return ResponseEntity.unprocessableEntity().body("Das Ende-Datum kann zeitlich nicht vor dem Start-Datum liegen!");
        }

        // get location id from name
        LocationEntity location = findLocation(event.getOrt());
        if(location == null) {
            return ResponseEntity.unprocessableEntity().body("Ort " + event.getOrt() + " existiert nicht!");
        }

        veranstaltung.setLocationID(location.getId());
        veranstaltung.setDiscriminator(event.getDiscriminator());

        veranstaltungRepository.save(veranstaltung);
        return ResponseEntity.ok(null);
    }

    // DELETE an event
    @DeleteMapping(path="/event/{eventId}")
    public ResponseEntity deleteVeranstaltung(@AuthenticationPrincipal AccountEntity user, @PathVariable int eventId) {
        System.out.println(user.getSponsorName() + ": delete event " + eventId);

        // receive veranstaltung
        Optional<VeranstaltungEntity> veranstaltungEntity = veranstaltungRepository.findById(eventId);
        if(!veranstaltungEntity.isPresent()) {
            return ResponseEntity.badRequest().body("Veranstaltung mit ID=" + eventId + " wurde nicht gefunden!");
        }
        VeranstaltungEntity veranstaltung = veranstaltungEntity.get();

        // get list of sponsors who organise this event
        Map<String, SponsorVeranstaltungEntity> sponsoren = new HashMap<>();
        Iterable<SponsorVeranstaltungEntity> sponsorVeranstaltungEntities = sponsorVeranstaltungRepository.findAll();
        sponsorVeranstaltungEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getVeranstaltungId() == eventId) {
                sponsoren.put(sponsorVeranstaltungEntity.getSponsorName(), sponsorVeranstaltungEntity);
            }
        });

        // check if we are one of the organisers of this event
        if(!sponsoren.containsKey(user.getSponsorName())) {
            return ResponseEntity.status(403).body(user.getSponsorName() + " ist nicht als Mitveranstalter dieser Veranstaltung eingetragen!");
        }

        // remove the current user from the list of organisers
        sponsorVeranstaltungRepository.delete(sponsoren.get(user.getSponsorName()));

        // if we were the only one organising this, delete the event
        if(sponsoren.size() == 1) {
            System.out.println("Lösche Veranstaltung " + veranstaltung.getName());
            veranstaltungRepository.delete(veranstaltung);
        }

        // otherwise, delete the entire event
        return ResponseEntity.ok().body(null);
    }

    @GetMapping(path="/dbg/update_attraktionen")
    public ResponseEntity dbgUpdateAttraktionen() {
        System.out.println("Requesting Attraktionen from service");

        // request attraktionen from their database
        ExternalServices externalServices = new ExternalServices();
        List<Attraktion> attraktionen = externalServices.getAttraktionen();

        // add all attraktionen to our database
        int ctr = 0;
        for(Attraktion attraktion : attraktionen) {
            AttraktionEntity attraktionEntity = new AttraktionEntity();
            attraktionEntity.setName(attraktion.getName());
            attraktionEntity.setBeschreibung(attraktion.getDescription());
            attraktionEntity.setLat(Double.parseDouble(attraktion.getLatitude()));
            attraktionEntity.setLon(Double.parseDouble(attraktion.getLongitude()));
            attraktionEntity.setId(Integer.parseInt(attraktion.getId()));

            attraktionRepository.save(attraktionEntity);
            ctr++;
        }

        System.out.println("Saved " + ctr + " Attraktionen to our database.");
        return ResponseEntity.ok("success, " + ctr + " updated.");
    }

    @GetMapping(path="/dbg/update_pois")
    public ResponseEntity dbgUpdatePois() {
        System.out.println("Requesting Pois from service");

        // request locations from their database
        ExternalServices externalServices = new ExternalServices();
        List<Poi> pois = externalServices.getPois();

        // add all locations to our database
        int ctr = 0;
        for(Poi poi : pois) {
            // https://confluence-student.it.hs-heilbronn.de/pages/viewpage.action?spaceKey=labswp2019lageplan&title=API+-+Icons
            int CategoryId = Integer.parseInt(poi.getCategoryID());
            if(CategoryId != 3 && CategoryId != 4 && CategoryId != 5 && CategoryId != 8)
                continue;

            LocationEntity locationEntity = new LocationEntity();
            locationEntity.setName(poi.getName());
            locationEntity.setLat(Double.parseDouble(poi.getLatitude()));
            locationEntity.setLon(Double.parseDouble(poi.getLongitude()));

            locationRepository.save(locationEntity);
            ctr++;
        }

        System.out.println("Saved " + ctr + " Locations to our database.");
        return ResponseEntity.ok("success, " + ctr + " updated.");
    }

    @GetMapping(path="/dbg/info")
    public ResponseEntity dbgInfo() {
        return ResponseEntity.ok(
                String.format(
                        "System.getProperty(\"os.name\") = %s<br>" +
                        "SPONSOR_LOGO_PATH = %s",
                        System.getProperty("os.name"),
                        ServerPageController.getSponsorLogoPath()
                )
        );
    }


    private Timestamp parseDate(String dateString) throws ParseException {
        DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date date = fmt.parse(dateString.replace('T', ' '));
        System.out.println("parseDate " + dateString + " -> " + date.toString());
        return new Timestamp(date.getTime());
    }

    private LocationEntity findLocation(String name) {
        Iterable<LocationEntity> locations = locationRepository.findAll();

        for(LocationEntity location : locations) {
            if(location.getName().equals(name)) {
                return location;
            }
        }

        return null;
    }

    private VeranstaltungEntity findNewestVeranstaltung() {
        Iterable<VeranstaltungEntity> veranstaltungen = veranstaltungRepository.findAll();

        int maxId = -1;
        VeranstaltungEntity max = null;
        for(VeranstaltungEntity veranstaltung : veranstaltungen) {
            if(veranstaltung.getId() > maxId) {
                maxId = veranstaltung.getId();
                max = veranstaltung;
            }
        }

        return max;
    }
}


class EventInfo {
    private String name;
    private String ort;
    private String start;
    private String ende;
    private String beschreibung;
    private String discriminator;

    EventInfo() {}

    EventInfo(String name, String ort, String start, String ende, String beschreibung, String discriminator) {
        this.name = name;
        this.ort = ort;
        this.start = start;
        this.ende = ende;
        this.beschreibung = beschreibung;
        this.discriminator = discriminator;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOrt() {
        return ort;
    }

    public void setOrt(String ort) {
        this.ort = ort;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnde() {
        return ende;
    }

    public void setEnde(String ende) {
        this.ende = ende;
    }

    public String getBeschreibung() {
        return beschreibung;
    }

    public void setBeschreibung(String beschreibung) {
        this.beschreibung = beschreibung;
    }

    public String getDiscriminator() {
        return discriminator;
    }

    public void setDiscriminator(String discriminator) {
        this.discriminator = discriminator;
    }
}

class AccountInfo {
    private String username;
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
