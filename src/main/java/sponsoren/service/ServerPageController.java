package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sponsoren.orm.LocationEntity;
import sponsoren.orm.SponsorEntity;
import sponsoren.orm.SponsorVeranstaltungEntity;
import sponsoren.orm.VeranstaltungEntity;

import java.util.*;

@Controller
public class ServerPageController {

    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private SponsorVeranstaltungRepository sponsorVeranstaltungRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private LocationRepository locationRepository;

    private void publishUtil(Model model) {
        model.addAttribute("util", new sponsoren.Util());
    }

    private void publishSponsor(Model model, String name) {
        Optional<SponsorEntity> sponsor = sponsorRepository.findById(name);
        if(!sponsor.isPresent())
            throw new RuntimeException("Sponsor '" + name + "' existiert nicht!");
        model.addAttribute("sponsor", sponsor.get());
    }

    private void publishSponsors(Model model) {
        // get all Sponsors
        Iterable<SponsorEntity> sponsorEntities = sponsorRepository.findAll();
        
        //get a list off all different sponsors (divided by Spendenklasse)
        List<SponsorEntity> sponsor0 = sponsorRepository.findBySpendenklasse((byte) 0);
        List<SponsorEntity> sponsor1 = sponsorRepository.findBySpendenklasse((byte) 1);
        List<SponsorEntity> sponsor2 = sponsorRepository.findBySpendenklasse((byte) 2);
        List<SponsorEntity> sponsor3 = sponsorRepository.findBySpendenklasse((byte) 3);
        List<SponsorEntity> sponsor4 = sponsorRepository.findBySpendenklasse((byte) 4);
        
        Collections.sort(sponsor0);
        Collections.sort(sponsor1);
        Collections.sort(sponsor2);
        Collections.sort(sponsor3);
        Collections.sort(sponsor4);
        
        List<List<SponsorEntity>> sortedSponsors = new ArrayList<List<SponsorEntity>>();
        sortedSponsors.add(sponsor0);
        sortedSponsors.add(sponsor1);
        sortedSponsors.add(sponsor2);
        sortedSponsors.add(sponsor3);
        sortedSponsors.add(sponsor4);

        // convert iterable to List
        //kann eventuell gelöscht werden
        List<SponsorEntity> sponsors = new ArrayList<>();
        sponsorEntities.forEach(sponsors::add);
        model.addAttribute("sponsors", sponsors);
        //bis hier
        
        
        //model.addAttribute("sponsors0", sponsor0);
        model.addAttribute("sponsorsSorted", sortedSponsors);
    }

    private void publishSponsorEvents(Model model, String sponsorName) {
        // get sponsor-event mapping
        Iterable<SponsorVeranstaltungEntity> sponsorEventEntities = sponsorVeranstaltungRepository.findAll();

        // convert iterable to List, resolving the foreign key association to event
        List<VeranstaltungEntity> sponsorEvents = new ArrayList<>();
        sponsorEventEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getSponsorName().equals(sponsorName)) {
                Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(sponsorVeranstaltungEntity.getVeranstaltungId());
                if(event.isPresent()) {
                    if(event.get().getDiscriminator().equals("Veranstaltung")) {
                        sponsorEvents.add(event.get());
                    }

                }

            }
        });
        model.addAttribute("sponsorEvents", sponsorEvents);
    }

    private void publishEvents(Model model) {
        // get all Veranstaltungen
        Iterable<VeranstaltungEntity> eventEntities = veranstaltungRepository.findAll();

        // convert iterable to List and filter by Discriminator
        List<VeranstaltungEntity> events = new ArrayList<>();
        eventEntities.forEach(event -> {
            if(event.getDiscriminator().equals("Veranstaltung")) {
                events.add(event);
            }
        });

        // sort events by start time ascending (earliest event from now first)
        events.sort(Comparator.comparing(VeranstaltungEntity::getStart));

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

        // convert iterable to List
        List<LocationEntity> locationList = new ArrayList<>();
        locationEntities.forEach(locationList::add);
        model.addAttribute("locationList", locationList);

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
        publishSponsor(model, name);
        publishUtil(model);
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
        publishUtil(model);
        publishSponsors(model);
        publishEvents(model);
        publishLocations(model);

        return "sponsor-eventlist";
    }

    @GetMapping("/event")
    public String getEventSite(Model model, @RequestParam Integer id) {
        Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(id);
        model.addAttribute("event", event.orElse(null));

        publishUtil(model);
        publishLocations(model);
        publishEventSponsors(model, id);
        return "event-site";
    }

    @GetMapping("/webinterface/login")
    public String getWebinterfaceLogin(Model model) {
        return "webinterface-login";
    }

    @GetMapping("/webinterface/home")
    public String getWebinterfaceHome(Model model, @RequestParam String sponsor) {
        publishSponsor(model, sponsor);
        return "webinterface-home";
    }

    @GetMapping("/webinterface/events")
    public String getWebinterfaceEvents(Model model, @RequestParam String sponsor) {
        publishUtil(model);
        publishLocations(model);
        publishSponsor(model, sponsor);
        publishSponsorEvents(model, sponsor);
        return "webinterface-events";
    }

    @GetMapping("/webinterface")
    public String getWebinterface(Model model) {
        return "webinterface-redirect";
    }
}
