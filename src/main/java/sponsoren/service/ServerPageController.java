package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sponsoren.orm.LocationEntity;
import sponsoren.orm.SponsorEntity;
import sponsoren.orm.VeranstaltungEntity;

import java.util.*;

@Controller
public class ServerPageController {

    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private LocationRepository locationRepository;

    private void publishSponsors(Model model) {
        // get all Sponsors
        Iterable<SponsorEntity> sponsorEntities = sponsorRepository.findAll();
        List<SponsorEntity> sponsors = new ArrayList<>();

        // convert iterable to List
        sponsorEntities.forEach(sponsors::add);
        model.addAttribute("sponsors", sponsors);
    }

    private void publishEvents(Model model) {
        // get all Veranstaltungen
        Iterable<VeranstaltungEntity> eventEntities = veranstaltungRepository.findAll();
        List<VeranstaltungEntity> events = new ArrayList<>();

        // convert iterable to List
        eventEntities.forEach(events::add);
        model.addAttribute("events", events);
    }

    private void publishLocations(Model model) {
        // get all Locations
        Iterable<LocationEntity> locationEntities = locationRepository.findAll();
        Map<Integer, LocationEntity> locations = new HashMap<>();

        // convert iterable to Map
        locationEntities.forEach(location -> locations.put(location.getId(), location));
        model.addAttribute("locations", locations);
    }


    @GetMapping({"/", "/index"})
    public String getIndex(Model model) {
        return "index";
    }

    @GetMapping("/sponsor")
    public String getSponsorSite(Model model, @RequestParam String name) {
        Optional<SponsorEntity> sponsor = sponsorRepository.findById(name);
        model.addAttribute("sponsor", sponsor.orElse(null));
        return "sponsor-site";
    }

    @GetMapping("/sponsoren")
    public String getSponsorSummary(Model model) {
        publishSponsors(model);
        return "sponsor-summary";
    }

    @GetMapping("/events")
    public String getEventlist(Model model) {
        publishSponsors(model);
        publishEvents(model);
        publishLocations(model);

        return "sponsor-eventlist";
    }

}
