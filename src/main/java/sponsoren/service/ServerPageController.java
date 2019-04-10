package sponsoren.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sponsoren.orm.SponsorEntity;

@Controller
public class ServerPageController {

  @Autowired
  private SponsorRepository sponsorRepository;

  @GetMapping({"/", "/index"})
  public String getIndex(Model model) {
    //get all Sponsors
    Iterable<SponsorEntity> sponsorEntities = sponsorRepository.findAll();
    List<SponsorEntity> sponsors = new ArrayList<>();
    //convert iterable to List
    sponsorEntities.forEach(sponsors::add);

    model.addAttribute("sponsors", sponsors);
    return "index";
  }

  @GetMapping("/sponsor")
  public String getSponsorSite(Model model,@RequestParam String name) {
    Optional<SponsorEntity> sponsor = sponsorRepository.findById(name);
    model.addAttribute("sponsor", sponsor.get());
    return "sponsor-site";
  }

}
