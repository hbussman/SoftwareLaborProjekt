package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import sponsoren.Util;
import sponsoren.orm.*;
import sponsoren.service.external.Attraktion;

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

    // GET sponsor.Werbetext
    @GetMapping(path="/sponsor/werbetext")
    public @ResponseBody String getSponsorWerbetext(@RequestParam String name) {
        if(name.isEmpty())
            return "missing request parameter ?name="; // TODO use error result code

        Optional<SponsorEntity> s = sponsorRepository.findById(name);
        if(s.isPresent())
        {
            // sponsor found in database
            return jsonify(s.get().getWerbetext());
        }
        else
            return "Unknown Sponsor '" + name + "'"; // TODO use error result code
    }


    // GET list of all sponsors
    @GetMapping(path="/sponsor/all")
    public @ResponseBody Iterable<SponsorEntity> getAllSponsors() {
        return sponsorRepository.findAll();
    }

    // GET all table columns of sponsor
    @GetMapping(path = "/sponsor/get_info")
    public @ResponseBody SponsorEntity getSponsorInfo(@RequestParam  String name) {
        Optional<SponsorEntity> optional = sponsorRepository.findById(name);
        return optional.orElse(null);
    }

    // POST save sponsor information
    @PostMapping(path = "/sponsor/set_info")
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

    // GET list of all accounts
    @GetMapping(path="/account/all")
    public @ResponseBody Iterable<AccountEntity> getAllAccounts() {
        return accountRepository.findAll();
    }

    // GET list of sponsor_veranstaltung
    @GetMapping(path="/sponsor_veranstaltung/all")
    public @ResponseBody Iterable<SponsorVeranstaltungEntity> getAllVeranst() {
        return sponsorVeranstaltungRepository.findAll();
    }

    // POST create new event
    @PostMapping(path = "/event/new", consumes = "application/json", produces = "application/json")
    public ResponseEntity createNewVeranstaltung(@AuthenticationPrincipal AccountEntity user, @RequestBody Map<String, String> event) {
        // create Veranstaltung
        VeranstaltungEntity veranstaltung = new VeranstaltungEntity();
        veranstaltung.setName(event.get("name"));
        veranstaltung.setBeschreibung(event.get("beschreibung"));
        System.out.println(event.get("beschreibung"));
        try {
            veranstaltung.setStart(parseDate(event.get("start")));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Fehlerhaftes Datumsformat " + event.get("start") + " - "
                    + e.getMessage());
        }
        try {
            veranstaltung.setEnde(parseDate(event.get("ende")));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Fehlerhaftes Datumsformat " + event.get("ende") + " - "
                    + e.getMessage());
        }

        // make sure the start date is before the end date
        if(veranstaltung.getStart().after(veranstaltung.getEnde())) {
            return ResponseEntity.unprocessableEntity().body("Das Ende-Datum kann zeitlich nicht vor dem Start-Datum liegen!");
        }

        // get location id from name
        String ort = event.get("ort");
        LocationEntity location = findLocation(ort);
        if(location == null)
            return ResponseEntity.unprocessableEntity().body("Ort '" + ort + "' existiert nicht");
        veranstaltung.setLocationID(location.getId());

        // save Veranstaltung to database
        veranstaltung.setDiscriminator("Veranstaltung");
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

        Map<String, String> body = new HashMap<>();
        body.put("name", veranstaltung.getName());
        body.put("ort", location.getName());
        body.put("start", new Util().prettifyTimestamp(veranstaltung.getStart().toString()));
        body.put("ende", new Util().prettifyTimestamp(veranstaltung.getEnde().toString()));
        body.put("beschreibung", veranstaltung.getBeschreibung());
        try {
            return ResponseEntity.created(new URI("/event?id=" + veranstaltung.getId())).body(body);
        } catch(URISyntaxException e) {
            e.printStackTrace();
            return ResponseEntity.accepted().body(body);
        }
    }

    @PatchMapping(path="/event/edit", consumes="application/json")
    public ResponseEntity editVeranstaltung(@RequestBody Map<String, String> event) {
        Integer eventId = Integer.parseInt(event.get("id"));
        Optional<VeranstaltungEntity> veranstaltungEntity = veranstaltungRepository.findById(eventId);
        if(!veranstaltungEntity.isPresent()) {
            return ResponseEntity.unprocessableEntity().body("Veranstaltung mit ID=" + eventId + " wurde nicht gefunden!");
        }

        VeranstaltungEntity veranstaltung = veranstaltungEntity.get();
        veranstaltung.setName(event.get("name"));
        veranstaltung.setBeschreibung(event.get("beschreibung"));
        try {
            veranstaltung.setStart(parseDate(event.get("start")));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Start: Fehlerhaftes Datumsformat '" + event.get("start") + "' - "
                    + e.getMessage());
        }
        try {
            veranstaltung.setEnde(parseDate(event.get("ende")));
        } catch(ParseException e) {
            e.printStackTrace();
            return ResponseEntity.unprocessableEntity().body("Ende: Fehlerhaftes Datumsformat " + event.get("ende") + " - "
                    + e.getMessage());
        }

        // make sure the start date is before the end date
        if(veranstaltung.getStart().after(veranstaltung.getEnde())) {
            return ResponseEntity.unprocessableEntity().body("Das Ende-Datum kann zeitlich nicht vor dem Start-Datum liegen!");
        }

        // get location id from name
        LocationEntity location = findLocation(event.get("ort"));
        if(location == null) {
            return ResponseEntity.unprocessableEntity().body("Ort " + event.get("ort") + " existiert nicht!");
        }

        veranstaltung.setLocationID(location.getId());

        veranstaltungRepository.save(veranstaltung);
        return ResponseEntity.ok(null);
    }

    // DELETE an event
    @DeleteMapping(path="/event/delete", consumes="application/json")
    public ResponseEntity deleteVeranstaltung(@RequestBody Map<String, String> event) {
        System.out.println(event.get("id"));
        System.out.println(event.get("sponsor"));
        String sponsorName = event.get("sponsor");
        int eventId = Integer.parseInt(event.get("id"));

        // receive veranstaltung
        Optional<VeranstaltungEntity> veranstaltungEntity = veranstaltungRepository.findById(eventId);
        if(!veranstaltungEntity.isPresent()) {
            return ResponseEntity.badRequest().body("Veranstaltung mit ID=" + eventId + " wurde nicht gefunden!");
        }
        VeranstaltungEntity veranstaltung = veranstaltungEntity.get();

        // get sponsor-veranstaltung mappings
        Map<String, SponsorVeranstaltungEntity> sponsoren = new HashMap<>();
        Iterable<SponsorVeranstaltungEntity> sponsorVeranstaltungEntities = sponsorVeranstaltungRepository.findAll();
        sponsorVeranstaltungEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getVeranstaltungId() == eventId) {
                sponsoren.put(sponsorVeranstaltungEntity.getSponsorName(), sponsorVeranstaltungEntity);
            }
        });

        // if this event is organised by multiple sponsors, remove the sponsor from it
        sponsorVeranstaltungRepository.delete(sponsoren.get(sponsorName));
        if(sponsoren.size() == 1) {
            System.out.println("Lösche Veranstaltung " + veranstaltung.getName());
            veranstaltungRepository.delete(veranstaltung);
        }

        // otherwise, delete the entire event
        return ResponseEntity.ok().body(null);
    }

    @GetMapping(path="/dbg/update_attraktionen")
    public void dbgUpdateAttraktionen() {
        System.out.println("Requesting Attraktionen from service");

        // request attraktionen from their database
        AttraktionApi attraktionApi = new AttraktionApi();
        List<Attraktion> attraktionen = attraktionApi.getAttraktionen();

        // add all attraktionen to our database
        int ctr = 0;
        for(Attraktion attraktion : attraktionen) {
            AttraktionEntity attraktionEntity = new AttraktionEntity();
            attraktionEntity.setName(attraktion.getName());
            attraktionEntity.setBeschreibung(attraktion.getDescription());
            attraktionEntity.setLat(Double.parseDouble(attraktion.getLatitude()));
            attraktionEntity.setLon(Double.parseDouble(attraktion.getLongitude()));

            attraktionRepository.save(attraktionEntity);
            ctr++;
        }

        System.out.println("Saved " + ctr + " Attraktionen to our database.");

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

    private String jsonify(String value) {
        return String.format("{\"text\":\"%s\"}", value);
    }
}
