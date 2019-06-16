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

    // GET list of all accounts - LOL NO
    /*@GetMapping(path="/account/all")
    public @ResponseBody Iterable<AccountEntity> getAllAccounts() {
        return accountRepository.findAll();
    }*/

    // PATCH account data
    @PatchMapping(path="/account/save", consumes = "application/json")
    public @ResponseBody ResponseEntity saveAccount(@AuthenticationPrincipal AccountEntity user, @RequestBody Map<String, String> data) {
        String sponsor = user.getSponsorName();
        String username = data.get("username");
        String password = data.get("password");

        if(username.isEmpty()) {
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

        account.setUsername(username);
        if(!password.isEmpty())
            account.setPassword(new SponsorenPasswordEncoder().encode(password));
        accountRepository.save(account);

        return ResponseEntity.ok("");
    }

    // GET list of sponsor_veranstaltung
    @GetMapping(path="/event/all/sponsor_mapping")
    public @ResponseBody Iterable<SponsorVeranstaltungEntity> getAllVeranst() {
        return sponsorVeranstaltungRepository.findAll();
    }

    // GET list of all events
    @GetMapping(path="/event/all")
    public @ResponseBody Iterable<VeranstaltungEntity> getAllEvents() {
        return veranstaltungRepository.findAll();
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
        veranstaltung.setDiscriminator(event.get("discriminator"));
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
        veranstaltung.setDiscriminator(event.get("discriminator"));

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
                        ServerPageController.SPONSOR_LOGO_PATH
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

    private String jsonify(String value) {
        return String.format("{\"text\":\"%s\"}", value);
    }
}
