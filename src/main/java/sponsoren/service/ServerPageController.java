package sponsoren.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sponsoren.orm.SponsorEntity;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class ServerPageController {

    @Autowired
    private SponsorRepository sponsorRepository;

    private void publishSponsors(Model model) {
        // get all Sponsors
        Iterable<SponsorEntity> sponsorEntities = sponsorRepository.findAll();
        List<SponsorEntity> sponsors = new ArrayList<>();

        // convert iterable to List
        sponsorEntities.forEach(sponsors::add);
        model.addAttribute("sponsors", sponsors);
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
        return "sponsor-eventlist";
    }

}
