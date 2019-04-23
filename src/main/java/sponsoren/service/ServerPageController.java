package sponsoren.service;

import com.sun.org.apache.xpath.internal.operations.Mod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sponsoren.orm.*;

import java.util.*;

@Controller
public class ServerPageController {

    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private SponsorVeranstaltungRepository sponsorVeranstaltungRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private LocationRepository locationRepository;

    private void publishSponsors(Model model) {
        // get all Sponsors
        Iterable<SponsorEntity> sponsorEntities = sponsorRepository.findAll();

        // convert iterable to List
        List<SponsorEntity> sponsors = new ArrayList<>();
        sponsorEntities.forEach(sponsors::add);
        model.addAttribute("sponsors", sponsors);
    }

    private void publishSponsorEvents(Model model, String sponsorName) {
        // get sponsor-event mapping
        Iterable<SponsorVeranstaltungEntity> sponsorEventEntities = sponsorVeranstaltungRepository.findAll();

        // convert iterable to List, resolving the foreign key association to event
        List<VeranstaltungEntity> sponsorEvents = new ArrayList<>();
        sponsorEventEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getSponsorName().equals(sponsorName)) {
                Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(sponsorVeranstaltungEntity.getVeranstaltungId());
                event.ifPresent(sponsorEvents::add);
            }
        });
        model.addAttribute("sponsorEvents", sponsorEvents);
    }

    private void publishEvents(Model model) {
        // get all Veranstaltungen
        Iterable<VeranstaltungEntity> eventEntities = veranstaltungRepository.findAll();

        // convert iterable to List
        List<VeranstaltungEntity> events = new ArrayList<>();
        eventEntities.forEach(events::add);
        model.addAttribute("events", events);
    }

    private void publishEventSponsors(Model model, Integer id) {
        // get sponsor-event mapping
        Iterable<SponsorVeranstaltungEntity> sponsorEventEntities = sponsorVeranstaltungRepository.findAll();

        // convert iterable to List, resolving foreign key association to sponsor
        List<SponsorEntity> eventSponsors = new ArrayList<>();
        sponsorEventEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getVeranstaltungId() == id) {
                Optional<SponsorEntity> sponsor = sponsorRepository.findById(sponsorVeranstaltungEntity.getSponsorName());
                sponsor.ifPresent(eventSponsors::add);
            }
        });
        model.addAttribute("eventSponsors", eventSponsors);
    }

    private void publishLocations(Model model) {
        // get all Locations
        Iterable<LocationEntity> locationEntities = locationRepository.findAll();

        // convert iterable to Map
        Map<Integer, LocationEntity> locations = new HashMap<>();
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

        publishSponsorEvents(model, name);
        publishLocations(model);
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

    @GetMapping("/event")
    public String getEventSite(Model model, @RequestParam Integer id) {
        Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(id);
        model.addAttribute("event", event.orElse(null));

        publishLocations(model);
        publishEventSponsors(model, id);
        return "event-site";
    }

}
