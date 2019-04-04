package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import sponsoren.orm.AccountEntity;
import sponsoren.orm.LocationEntity;
import sponsoren.orm.SponsorEntity;
import sponsoren.orm.SponsorVeranstaltungEntity;

import java.util.Optional;

@Controller
@RequestMapping(path="/api")
public class MainController {
    @Autowired private SponsorRepository sponsorRepository;
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

    //GET all table columns of sponsor
    @GetMapping(path = "/sponsor/get_info")
    public @ResponseBody SponsorEntity getSponsorInfo(@RequestParam  String name) {
        Optional<SponsorEntity> optional = sponsorRepository.findById(name);
        return optional.get();
    }

    //Save sponsor information
    @PostMapping(path = "sponsor/set_Info")
    public @ResponseBody void setSponsorInfo(@RequestBody SponsorEntity sponsor) {
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

    // GET list of sponsor_veeanstaltung
    @GetMapping(path="/sponsor_veranstaltung/all")
    public @ResponseBody Iterable<SponsorVeranstaltungEntity> getAllVeranst() {
        return sponsorVeranstaltungRepository.findAll();
    }

    private String jsonify( String value) {
        return String.format("{\"text\":\"%s\"}", value);
    }
}
