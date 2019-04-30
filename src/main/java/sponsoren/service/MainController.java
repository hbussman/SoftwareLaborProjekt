package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import sponsoren.Util;
import sponsoren.orm.*;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping(path="/api")
public class MainController {
    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private SponsorVeranstaltungRepository sponsorVeranstaltungRepository;
    @Autowired private LocationRepository locationRepository;
    @Autowired private AccountRepository accountRepository;

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
    public @ResponseBody void setSponsorInfo(@RequestBody SponsorEntity sponsor) {
        sponsor.setAdresse(sponsor.getAdresse().trim());
        sponsor.setAnsprechpartnerNachname(sponsor.getAnsprechpartnerNachname().trim());
        sponsor.setAnsprechpartnerVorname(sponsor.getAnsprechpartnerVorname().trim());
        sponsor.setEmail(sponsor.getEmail().trim());
        sponsor.setTelefonnummer(sponsor.getTelefonnummer().trim());
        sponsor.setHomepage(sponsor.getHomepage().trim());
        sponsorRepository.save(sponsor);
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
    @PostMapping(path="/event/new", consumes="application/json", produces="application/json")
    public ResponseEntity createNewVeranstaltung(@RequestBody Map<String, String> event) {
        // create Veranstaltung
        VeranstaltungEntity veranstaltung = new VeranstaltungEntity();
        veranstaltung.setName(event.get("name"));
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
        String creator = event.get("creator");
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
        try {
            return ResponseEntity.created(new URI("/event?id=" + veranstaltung.getId())).body(body);
        } catch(URISyntaxException e) {
            e.printStackTrace();
            return ResponseEntity.accepted().body(body);
        }
    }

    // DELETE an event
    @DeleteMapping(path="/event/delete", consumes="application/json")
    public ResponseEntity deleteVeranstaltung(@RequestBody Map<String, String> event) {
        // if this event is organised by multiple sponsors, remove the sponsor from it
        System.out.println(event.get("id"));
        System.out.println(event.get("sponsor"));

        // TODO

        // otherwise, delete the entire event
        return ResponseEntity.ok().body(null);
    }

    private Timestamp parseDate(String dateString) throws ParseException {
        DateFormat fmt = new SimpleDateFormat("dd.MM. HH:mm");
        Date date = fmt.parse(dateString);
        date.setYear(2019 - 1900);
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
