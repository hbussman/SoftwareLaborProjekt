package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import sponsoren.orm.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.validation.Valid;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;

@Controller
public class ServerPageController {

    public static final String SPONSOR_LOGO_PATH_DEPLOYED = "D:\\pub\\http\\Studenten\\LabSWPPS2019\\BuGa19Sponsoren\\Bilder";
    public static final String SPONSOR_LOGO_PATH_LOCAL = "./data/uploaded_images";

    private Map<String, CachedImage> imagesCache = new HashMap<>();

    @Autowired private SponsorRepository sponsorRepository;
    @Autowired private SponsorVeranstaltungRepository sponsorVeranstaltungRepository;
    @Autowired private VeranstaltungRepository veranstaltungRepository;
    @Autowired private LocationRepository locationRepository;
    @Autowired private AttraktionRepository attractionRepository;
    @Autowired private SponsorAttraktionRepository sponsorAttraktionRepository;

    public static String getSponsorLogoPath() {
        File imagesFolder = new File(SPONSOR_LOGO_PATH_DEPLOYED);
        boolean isDeployed = imagesFolder.exists() && imagesFolder.isDirectory();
        return isDeployed ? SPONSOR_LOGO_PATH_DEPLOYED : SPONSOR_LOGO_PATH_LOCAL;
    }

    private void publishCommon(Model model) {
    }

    private void publishSearch(Model model, String searchString) {
        model.addAttribute("searchString", searchString);
    }

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
    private void publishSponsorEventsAndCompanyPartys(Model model, String sponsorName) {
        // get sponsor-event mapping
        Iterable<SponsorVeranstaltungEntity> sponsorEventEntities = sponsorVeranstaltungRepository.findAll();

        // convert iterable to List, resolving the foreign key association to event
        List<VeranstaltungEntity> events = new ArrayList<>();
        sponsorEventEntities.forEach(sponsorVeranstaltungEntity -> {
            if(sponsorVeranstaltungEntity.getSponsorName().equals(sponsorName)) {
                Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(sponsorVeranstaltungEntity.getVeranstaltungId());
                if(event.isPresent()) {
                        events.add(event.get());
                }

            }
        });
        model.addAttribute("events", events);
    }

    private void publishEvents(Model model) {
        // get all Veranstaltungen
        Iterable<VeranstaltungEntity> eventEntities = veranstaltungRepository.findAll();
        Iterable<VeranstaltungEntity> companyPartyEntities = veranstaltungRepository.findAll();

        // convert iterable to List and filter by Discriminator
        List<VeranstaltungEntity> events = new ArrayList<>();
        eventEntities.forEach(event -> {
            if(event.getDiscriminator().equals("Veranstaltung")) {
                events.add(event);
            }
            
        });

        List<VeranstaltungEntity> companyPartys = new ArrayList<>();
        companyPartyEntities.forEach(event -> {
        	if(event.getDiscriminator().equals("Betriebsfeier")) {
                companyPartys.add(event);
            }
        });

        // sort events by start time ascending (earliest event from now first)
        events.sort(Comparator.comparing(VeranstaltungEntity::getStart));
        companyPartys.sort(Comparator.comparing(VeranstaltungEntity::getStart));
        
        model.addAttribute("companyPartys", companyPartys);
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

    private void publishAttractions(Model model) {
        // get all Attractions
        Iterable<AttraktionEntity> attractionEntities = attractionRepository.findAll();

        // convert iterable to List
        List<AttraktionEntity> attractionList = new ArrayList<>();
        attractionEntities.forEach(attractionList::add);
        model.addAttribute("attractions", attractionList);
    }

    private void publishAttractionSponsors(Model model) {
        // get sponsor-event mapping
        Iterable<SponsorAttraktionEntity> sponsorAttraktionEntities = sponsorAttraktionRepository.findAll();

        // convert iterable to Map, resolving foreign key association to sponsor
        Map<String, String> attraktionSponsorMapping = new HashMap<>();
        for(SponsorAttraktionEntity sponsorVeranstaltungEntity : sponsorAttraktionEntities) {
            attraktionSponsorMapping.put(sponsorVeranstaltungEntity.getAttraktion(), sponsorVeranstaltungEntity.getSponsorName());
        }
        model.addAttribute("attractionSponsors", attraktionSponsorMapping);
    }


    @RequestMapping(value="/webinterface/image_upload", method = RequestMethod.POST, consumes = {"multipart/form-data"})
    public ResponseEntity importQuestion(@Valid @RequestParam("uploadedFileName") MultipartFile multipart, @AuthenticationPrincipal AccountEntity user) {

        final String SPONSOR_LOGO_PATH = getSponsorLogoPath();

        String sponsor = user.getSponsorName();
        System.out.println("IMAGE IMAGE IMAGE");
        System.out.println("sponsor: " + sponsor);
        System.out.println(SPONSOR_LOGO_PATH);

        String file_dest = SPONSOR_LOGO_PATH + "/" + sponsor + "_scaled.png";
        if (!multipart.isEmpty()) {
            try {
                byte[] bytes = multipart.getBytes();
                BufferedOutputStream stream =
                        new BufferedOutputStream(new FileOutputStream(new File(file_dest)));
                stream.write(bytes);
                stream.close();
                return ResponseEntity.ok().body("Successfully uploaded " + multipart.getName() + " as " + file_dest);
            } catch (Exception e) {
                return ResponseEntity.unprocessableEntity().body("Failed to upload " + multipart.getName() + " => " + e.getMessage());
            }
        } else {
            return ResponseEntity.unprocessableEntity().body("Failed to upload " + multipart.getName() + " because the file was empty.");
        }
    }



    @GetMapping({"/", "/index"})
    public String getIndex(Model model) {
        return "index";
    }

    @GetMapping("/sponsor")
    public String getSponsorSite(Model model, @RequestParam String name) {
        publishSponsor(model, name);

        // Aufrufe zaehlen der Besucher
        Optional<SponsorEntity> sponsor = sponsorRepository.findById(name);
        int aktuell = sponsor.get().getAufrufe();
        sponsor.get().setAufrufe(aktuell+1);
        sponsorRepository.save(sponsor.get());

        publishCommon(model);
        publishUtil(model);
        publishSponsorEvents(model, name);
        publishLocations(model);
        return "sponsor-site";
    }

    @GetMapping("/sponsoren")
    public String getSponsorSummary(Model model, @RequestParam(required = false) String search) {
        publishCommon(model);
        publishUtil(model);
        publishSearch(model, search);
        publishSponsors(model);
        return "sponsor-summary";
    }

    @GetMapping("/events")
    public String getEventlist(Model model, @RequestParam(required = false) String search) {
        publishUtil(model);
        publishSearch(model, search);
        publishSponsors(model);
        publishEvents(model);
        publishLocations(model);

        return "sponsor-eventlist";
    }

    @GetMapping("/attractions")
    public String getAttractionlist(Model model, @RequestParam(required = false) String search) {
        publishSearch(model, search);
        publishAttractions(model);
        publishAttractionSponsors(model);
        publishUtil(model);
        return "sponsor-attractionlist";
    }

    @GetMapping("/event")
    public String getEventSite(Model model, @RequestParam Integer id) {
        Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(id);
        model.addAttribute("event", event.orElse(null));

        publishCommon(model);
        publishUtil(model);
        publishLocations(model);
        publishEventSponsors(model, id);
        return "event-site";
    }

    @GetMapping("/webinterface")
    public String getWebinterfaceLogin(Model model, @AuthenticationPrincipal AccountEntity user) {
        if(user == null)
            return "webinterface-login";
        else
            return getWebinterfaceHome(model, user);
    }

    private String getWebinterfaceHome(Model model, @AuthenticationPrincipal AccountEntity user) {
        publishCommon(model);
        publishSponsor(model, user.getSponsorName());

        return "webinterface-home";
    }

    @GetMapping("/webinterface/account")
    public String getWebinterfaceAccount(Model model, @AuthenticationPrincipal AccountEntity user) {
        publishSponsor(model, user.getSponsorName());
        model.addAttribute("currentUsername", user.getUsername());
        return "webinterface-account";
    }

    @GetMapping("/webinterface/events")
    public String getWebinterfaceEvents(Model model, @AuthenticationPrincipal AccountEntity user) {
        String sponsor = user.getSponsorName();
        publishUtil(model);
        publishLocations(model);
        publishSponsor(model, sponsor);
        publishSponsorEventsAndCompanyPartys(model, sponsor);
        return "webinterface-events";
    }

    @RequestMapping(value = "/image/{name}", method = RequestMethod.GET, produces = "image/png")
    public @ResponseBody byte[] getFile(@PathVariable String name)  {

        final String SPONSOR_LOGO_PATH = getSponsorLogoPath();
        System.out.println("GET IMAGE " + SPONSOR_LOGO_PATH + "/" + name);

        try {
            // Retrieve image from the classpath.
            File f = new File(SPONSOR_LOGO_PATH + "/" + name);

            // look up image in cache
            CachedImage cached = imagesCache.get(name);
            if(cached != null && f.lastModified() <= cached.lastModified) {
                // got the image cached and it's up to date
                System.out.println("Serving image '" + name + "' from cache");
                return cached.data;
            }

            // Prepare buffered image.
            BufferedImage img = ImageIO.read(f);

            // Create a byte array output stream.
            ByteArrayOutputStream bao = new ByteArrayOutputStream();

            // Write to output stream
            ImageIO.write(img, "png", bao);

            byte[] imageData = bao.toByteArray();

            // cache the image
            imagesCache.put(name, new CachedImage(f.lastModified(), imageData));
            System.out.println("Updated image '" + name + "' in cache");

            return imageData;

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/companyparty-map")
    public String getCompanypartymap(Model model, @RequestParam Integer id) {
    	 Optional<VeranstaltungEntity> event = veranstaltungRepository.findById(id);
         model.addAttribute("event", event.orElse(null));

         publishCommon(model);
         publishUtil(model);
         publishLocations(model);
         publishEventSponsors(model, id);
		return "companyparty-map";
    }

}

class CachedImage {
    long lastModified;
    byte[] data;

    public CachedImage(long lastModified, byte[] data) {
        this.lastModified = lastModified;
        this.data = data;
    }
}
